import { Controller,Get,Post,Put,Patch,Delete,Param,Query,Body,Req,UseGuards,BadRequestException,ForbiddenException,NotFoundException,ConflictException,UseInterceptors,UploadedFile,Res, StreamableFile } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository,In } from 'typeorm';
import { IsBoolean, IsIn, IsInt, IsNumber, IsOptional, IsString, IsUUID, Max,MaxLength,Min,MinLength,IsArray } from 'class-validator';
import { diskStorage, memoryStorage } from 'multer';
import { randomUUID } from 'node:crypto';
import { join,resolve } from 'node:path';
import { mkdir,readFile,writeFile } from 'node:fs/promises';
import sharp from 'sharp';
import { AppSetting,Booking,BookingStatus,Location,Message,Notification,Review,Role,ServiceType,User,WorkerPayment,WorkerProfile,WorkerStatus } from './entities';
import { AuthGuard,Roles } from './auth';
import {UI_TEXT_LABELS} from './text-labels';

const assertLatLng=(lat?:number|null,lng?:number|null)=>{if(lat!==null&&lat!==undefined&&(!Number.isFinite(lat)||lat < -90||lat>90))throw new BadRequestException('Invalid latitude');if(lng!==null&&lng!==undefined&&(!Number.isFinite(lng)||lng < -180||lng>180))throw new BadRequestException('Invalid longitude');};
export class WorkerUpdateDto {
 @IsOptional() @IsArray() @IsUUID('4',{each:true}) serviceIds?:string[];
 @IsOptional() @IsUUID() cityId?:string;
 @IsOptional() @IsUUID() areaId?:string;
 @IsOptional() @IsNumber() @Min(-90) @Max(90) latitude?:number;
 @IsOptional() @IsNumber() @Min(-180) @Max(180) longitude?:number;
 @IsOptional() @IsNumber() @Min(1) @Max(100) serviceRadiusKm?:number;
 @IsOptional() @IsInt() @Min(0) @Max(70) experienceYears?:number;
 @IsOptional() @IsString() @MaxLength(2000) bio?:string;
 @IsOptional() @IsBoolean() publicContact?:boolean;
 @IsOptional() @IsBoolean() homeVisits?:boolean;
 @IsOptional() @IsBoolean() shopVisits?:boolean;
 @IsOptional() @IsBoolean() emergencyAvailable?:boolean;
}
export class FeeDto {
 @IsIn(['EASYPAISA','JAZZCASH']) method!:'EASYPAISA'|'JAZZCASH';
 @IsString() @MinLength(3) @MaxLength(100) transactionReference!:string;
}
export class BookingDto {
 @IsUUID() workerId!:string; @IsUUID() serviceId!:string;
 @IsString() @MinLength(5) @MaxLength(2000) description!:string;
 @IsOptional() @IsInt() @Min(0) @Max(10000000) proposedPricePkr?:number;
 @IsOptional() @IsUUID() cityId?:string; @IsOptional() @IsUUID() areaId?:string;
 @IsOptional() @IsNumber() @Min(-90) @Max(90) latitude?:number;
 @IsOptional() @IsNumber() @Min(-180) @Max(180) longitude?:number;
 @IsOptional() @IsString() @MaxLength(500) address?:string;
}
export class ReviewDto { @IsUUID() bookingId!:string; @IsInt() @Min(1) @Max(5) stars!:number; @IsOptional() @IsString() @MaxLength(800) comment?:string; }
export class MessageDto { @IsString() @MinLength(1) @MaxLength(1500) body!:string; }
export class QuoteDto { @IsInt() @Min(0) @Max(10000000) amountPkr!:number; }
export class StatusDto { @IsIn(['ACCEPTED','IN_PROGRESS','COMPLETED','CANCELLED','DISPUTED']) status!:BookingStatus; }

export const DEFAULT_CONTENT={
 appName:'Hunar Near Me', appNameUrdu:'ہنر آپ کے قریب', primaryColor:'#006B4F',
 labels:{en:{...UI_TEXT_LABELS,welcomeTitle:'Find trusted skilled professionals near you',customerSignup:'Register as Customer',workerSignup:'Register as Worker',login:'Login',chooseService:'Choose Service Type',location:'City / Area',nearest:'Nearest Workers',bestRated:'Top Rated Workers'},ur:{...UI_TEXT_LABELS,welcomeTitle:'اپنے قریب قابل اعتماد ہنرمند تلاش کریں',customerSignup:'بطور کسٹمر رجسٹر کریں',workerSignup:'بطور ہنرمند رجسٹر کریں',login:'لاگ ان',chooseService:'سروس منتخب کریں',location:'شہر / علاقہ',nearest:'قریب ترین ہنرمند',bestRated:'بہترین ریٹنگ والے'}},
 images:{welcomeHero:'',customerSignupHero:'',workerSignupHero:'',logo:''},
 workerFeePkr:500, easypaisaNumber:'', jazzcashNumber:'', currency:'PKR', supportPhone:''
};

@Controller('public')
export class PublicController {
 constructor(@InjectRepository(ServiceType) private services:Repository<ServiceType>,@InjectRepository(Location) private locations:Repository<Location>,@InjectRepository(AppSetting) private settings:Repository<AppSetting>,@InjectRepository(WorkerProfile) private profiles:Repository<WorkerProfile>,@InjectRepository(User) private users:Repository<User>,@InjectRepository(Review) private reviews:Repository<Review>){}
 @Get('config') async config(){const s=await this.settings.findOneBy({key:'appContent'});return s?.value||DEFAULT_CONTENT;}
 @Get('services') servicesList(){return this.services.find({where:{active:true},order:{sortOrder:'ASC',name:'ASC'}});}
 @Get('locations') locationsList(@Query('parentId') parentId?:string,@Query('kind') kind?:string){return this.locations.find({where:{active:true,...(parentId?{parentId}:{}),...(kind?{kind:kind as any}:{})},order:{name:'ASC'}});}
 @Get('workers') async directory(@Query() q:Record<string,string>){
  const take=Math.min(50,Math.max(1,parseInt(q.limit||'30',10)||30));
  const lat=q.lat!==undefined?Number(q.lat):undefined,lng=q.lng!==undefined?Number(q.lng):undefined;
  if((lat===undefined)!==(lng===undefined))throw new BadRequestException('Both lat and lng are required');assertLatLng(lat,lng);
  const requestedRadiusKm=Number(q.radiusKm||25);
  const radiusKm=Number.isFinite(requestedRadiusKm)?Math.min(100,Math.max(1,requestedRadiusKm)):25;
  const list=await this.profiles.find({where:{status:WorkerStatus.APPROVED},take:500});
  const selected=list.filter(w=>(!q.serviceId||w.serviceIds.includes(q.serviceId))&&(!q.cityId||w.cityId===q.cityId)&&(!q.areaId||w.areaId===q.areaId));
  const ids=selected.map(x=>x.userId);const users=ids.length?await this.users.findBy({id:In(ids),active:true}):[];const byId=new Map(users.map(u=>[u.id,u]));
  let geo=new Map<string,number>();
  // PostGIS ST_DistanceSphere yields geodesic/straight-line distance, not road travel distance.
  if(lat!==undefined&&lng!==undefined&&selected.length){
   const rows=await this.profiles.query('SELECT id, ST_DistanceSphere(ST_MakePoint(longitude, latitude), ST_MakePoint($1,$2))/1000.0 AS km FROM worker_profiles WHERE status = $3 AND latitude IS NOT NULL AND longitude IS NOT NULL',[lng,lat,WorkerStatus.APPROVED]);
   geo=new Map(rows.map((r:any)=>[r.id,Number(r.km)]));
  }
  const ranked=selected.filter(w=>byId.has(w.userId)).map(w=>{
   const u=byId.get(w.userId)!;const distanceKm=geo.get(w.id)??null;
   const eligible=distanceKm===null||distanceKm<=radiusKm&&distanceKm<=w.serviceRadiusKm;
   const score=(w.ratingCount*w.ratingAverage+20*4.2)/(w.ratingCount+20);
   return {id:w.id,name:u.name,phone:w.publicContact?u.phone:null,photoUrl:u.photoUrl,cityId:w.cityId,areaId:w.areaId,serviceIds:w.serviceIds,experienceYears:w.experienceYears,bio:w.bio,homeVisits:w.homeVisits,shopVisits:w.shopVisits,emergencyAvailable:w.emergencyAvailable,ratingAverage:w.ratingAverage,ratingCount:w.ratingCount,verifiedBadge:w.verifiedBadge,completedJobs:w.completedJobs,distanceKm:distanceKm!==null?Math.round(distanceKm*100)/100:null,score,eligible};
  }).filter(w=>w.eligible);
  const sort=q.sort||'best';
  ranked.sort((a,b)=>sort==='nearest'?(a.distanceKm??999999)-(b.distanceKm??999999):sort==='rating'?b.ratingAverage-a.ratingAverage:sort==='reviews'?b.ratingCount-a.ratingCount:b.score-a.score);
  return ranked.slice(0,take).map(({score,eligible,...rest})=>rest);
 }
 @Get('workers/:id') async worker(@Param('id') id:string){const w=await this.profiles.findOneBy({id,status:WorkerStatus.APPROVED});if(!w)throw new NotFoundException();const u=await this.users.findOneBy({id:w.userId,active:true});if(!u)throw new NotFoundException();
  const reviews=await this.reviews.find({where:{workerId:w.userId,visible:true},order:{createdAt:'DESC'},take:50});
  return {id:w.id,userId:u.id,name:u.name,phone:w.publicContact?u.phone:null,photoUrl:u.photoUrl,serviceIds:w.serviceIds,cityId:w.cityId,areaId:w.areaId,bio:w.bio,experienceYears:w.experienceYears,photoUrls:w.photoUrls,ratingAverage:w.ratingAverage,ratingCount:w.ratingCount,completedJobs:w.completedJobs,verifiedBadge:w.verifiedBadge,homeVisits:w.homeVisits,shopVisits:w.shopVisits,reviews:reviews.map(r=>({id:r.id,stars:r.stars,comment:r.comment,workerReply:r.workerReply,createdAt:r.createdAt}))};
 }
}

@Controller('worker') @UseGuards(AuthGuard) @Roles(Role.WORKER)
export class WorkerController {
 constructor(@InjectRepository(WorkerProfile) private profiles:Repository<WorkerProfile>,@InjectRepository(WorkerPayment) private payments:Repository<WorkerPayment>,@InjectRepository(ServiceType) private services:Repository<ServiceType>,@InjectRepository(Location) private locations:Repository<Location>,@InjectRepository(AppSetting) private settings:Repository<AppSetting>,@InjectRepository(User) private users:Repository<User>,@InjectRepository(Review) private reviews:Repository<Review>){}
 @Get('me') async me(@Req() req:any){const p=await this.profiles.findOneByOrFail({userId:req.user.id});const payments=await this.payments.find({where:{workerId:req.user.id},order:{createdAt:'DESC'}});return {profile:p,payments:payments.map(({screenshotPath,...rest})=>({...rest,hasScreenshot:!!screenshotPath}))};}
 @Put('profile') async update(@Req() req:any,@Body() dto:WorkerUpdateDto){const p=await this.profiles.findOneByOrFail({userId:req.user.id});
  if(dto.serviceIds){const active=await this.services.findBy({id:In(dto.serviceIds),active:true});if(active.length!==dto.serviceIds.length)throw new BadRequestException('Unknown service selection');}
  if(dto.cityId&&!await this.locations.exist({where:{id:dto.cityId,kind:'city',active:true}}))throw new BadRequestException('Invalid city');
  if(dto.areaId&&!await this.locations.exist({where:{id:dto.areaId,active:true}}))throw new BadRequestException('Invalid area');
  if(dto.areaId&&dto.cityId&&!await this.locations.exist({where:{id:dto.areaId,parentId:dto.cityId}}))throw new BadRequestException('Area does not belong to city');
  Object.assign(p,dto);if(p.status===WorkerStatus.APPROVED)p.status=WorkerStatus.PENDING;return this.profiles.save(p);
 }
 @Patch('location') async updateLiveLocation(@Req() req:any,@Body() data:{latitude:number;longitude:number}){
  if(typeof data.latitude!=='number'||typeof data.longitude!=='number')throw new BadRequestException('GPS coordinates required');assertLatLng(data.latitude,data.longitude);
  const p=await this.profiles.findOneByOrFail({userId:req.user.id});if(p.status!==WorkerStatus.APPROVED)throw new BadRequestException('Profile must be approved first');
  p.latitude=data.latitude;p.longitude=data.longitude;await this.profiles.save(p);return {updatedAt:p.updatedAt};
 }
 @Post('fee') async fee(@Req() req:any,@Body() dto:FeeDto){const setting=await this.settings.findOneBy({key:'appContent'});const price=Number((setting?.value as any)?.workerFeePkr??DEFAULT_CONTENT.workerFeePkr);
  if(!Number.isInteger(price)||price<0)throw new BadRequestException('Fee configuration invalid');
  if(await this.payments.exist({where:{workerId:req.user.id,status:'VERIFIED'}}))throw new ConflictException('Fee already verified');
  const prev=await this.payments.findOne({where:{method:dto.method,transactionReference:dto.transactionReference}});if(prev)throw new ConflictException('Transaction reference already submitted');
  return this.payments.save(this.payments.create({...dto,workerId:req.user.id,amountPkr:price,status:'PENDING'}));
 }
 @Post('fee/:id/screenshot') @UseInterceptors(FileInterceptor('file',{storage:memoryStorage(),limits:{fileSize:4*1024*1024}}))
 async screenshot(@Req() req:any,@Param('id') id:string,@UploadedFile() file?:Express.Multer.File){if(!file)throw new BadRequestException('Attach a JPEG, PNG or WebP file');
  const p=await this.payments.findOneBy({id,workerId:req.user.id,status:'PENDING'});if(!p)throw new NotFoundException();
  let converted:Buffer;try{converted=await sharp(file.buffer,{limitInputPixels:12_000_000}).rotate().resize({width:1600,withoutEnlargement:true}).webp({quality:80}).toBuffer();}catch{throw new BadRequestException('Invalid image file');}
  const dir=resolve(process.env.UPLOAD_DIR||'uploads','private');await mkdir(dir,{recursive:true});const fileName=randomUUID()+'.webp';await writeFile(join(dir,fileName),converted,{flag:'wx'});p.screenshotPath=fileName;await this.payments.save(p);return {attached:true};
 }
 @Post('photos') @UseInterceptors(FileInterceptor('file',{storage:memoryStorage(),limits:{fileSize:5*1024*1024}}))
 async photo(@Req() req:any,@UploadedFile() file?:Express.Multer.File){if(!file)throw new BadRequestException('Choose a photo');let converted:Buffer;
  try{converted=await sharp(file.buffer,{limitInputPixels:16_000_000}).rotate().resize({width:1200,withoutEnlargement:true}).webp({quality:78}).toBuffer();}catch{throw new BadRequestException('Invalid image');}
  const p=await this.profiles.findOneByOrFail({userId:req.user.id});if(p.photoUrls.length>=8)throw new BadRequestException('Maximum 8 portfolio images');
  const dir=resolve(process.env.UPLOAD_DIR||'uploads','public');await mkdir(dir,{recursive:true});const f=randomUUID()+'.webp';await writeFile(join(dir,f),converted,{flag:'wx'});
  const url=`${process.env.PUBLIC_API_URL||'http://localhost:4000'}/media/${f}`;p.photoUrls=[...p.photoUrls,url];if(p.status===WorkerStatus.APPROVED)p.status=WorkerStatus.PENDING;await this.profiles.save(p);const user=await this.users.findOneBy({id:req.user.id});if(user && !user.photoUrl){user.photoUrl=url;await this.users.save(user);}return {url};
 }
 @Post('reviews/:id/reply') async reply(@Req() req:any,@Param('id') id:string,@Body('reply') reply:string){if(typeof reply!=='string'||reply.length>600)throw new BadRequestException('Reply too long');const r=await this.reviews.findOneBy({id,workerId:req.user.id});if(!r)throw new NotFoundException();r.workerReply=reply.trim();return this.reviews.save(r);}
}

@Controller('bookings') @UseGuards(AuthGuard)
export class BookingController {
 constructor(@InjectRepository(Booking) private bookings:Repository<Booking>,@InjectRepository(WorkerProfile) private workers:Repository<WorkerProfile>,@InjectRepository(Review) private reviews:Repository<Review>,@InjectRepository(Message) private messages:Repository<Message>,@InjectRepository(Notification) private notifications:Repository<Notification>){}
 private async accessible(id:string,user:any){const b=await this.bookings.findOneBy({id});if(!b || (b.customerId!==user.id&&b.workerId!==user.id&&user.role!==Role.ADMIN))throw new NotFoundException();return b;}
 @Get() mine(@Req() req:any){return this.bookings.find({where:req.user.role===Role.WORKER?{workerId:req.user.id}:{customerId:req.user.id},order:{createdAt:'DESC'},take:100});}
 @Post() @Roles(Role.CUSTOMER) async create(@Req() req:any,@Body() dto:BookingDto){const w=await this.workers.findOneBy({userId:dto.workerId,status:WorkerStatus.APPROVED});if(!w||!w.serviceIds.includes(dto.serviceId))throw new BadRequestException('Worker is not available for this service');
  const booking=await this.bookings.save(this.bookings.create({...dto,customerId:req.user.id,workerId:dto.workerId,status:BookingStatus.REQUESTED}));
  await this.notifications.save(this.notifications.create({recipientId:dto.workerId,title:'New job request',body:'A customer has requested your service.'}));return booking;
 }
 @Patch(':id/quote') @Roles(Role.WORKER) async quote(@Req() req:any,@Param('id') id:string,@Body() dto:QuoteDto){const b=await this.accessible(id,req.user);if(b.workerId!==req.user.id||![BookingStatus.REQUESTED,BookingStatus.QUOTED].includes(b.status))throw new ForbiddenException();b.quotedPricePkr=dto.amountPkr;b.status=BookingStatus.QUOTED;await this.bookings.save(b);await this.notifications.save({recipientId:b.customerId,title:'New price quote',body:'Your worker has sent a price quote.'});return b;}
 @Patch(':id/status') async status(@Req() req:any,@Param('id') id:string,@Body() dto:StatusDto){const b=await this.accessible(id,req.user);const from=b.status,to=dto.status;
  const transitions:Record<string,string[]>={REQUESTED:['CANCELLED','DISPUTED'],QUOTED:['ACCEPTED','CANCELLED','DISPUTED'],ACCEPTED:['IN_PROGRESS','CANCELLED','DISPUTED'],IN_PROGRESS:['COMPLETED','DISPUTED'],COMPLETED:['DISPUTED'],DISPUTED:[],CANCELLED:[]};
  if(!transitions[from]?.includes(to))throw new BadRequestException('Invalid status transition');
  if(to===BookingStatus.ACCEPTED&&req.user.id!==b.customerId)throw new ForbiddenException('Customer accepts quotes');
  if([BookingStatus.IN_PROGRESS,BookingStatus.COMPLETED].includes(to)&&req.user.id!==b.workerId)throw new ForbiddenException('Worker updates work progress');
  if(to===BookingStatus.DISPUTED&&![b.customerId,b.workerId].includes(req.user.id))throw new ForbiddenException();
  b.status=to;await this.bookings.save(b);
  if(to===BookingStatus.COMPLETED){const w=await this.workers.findOneBy({userId:b.workerId});if(w){w.completedJobs++;await this.workers.save(w);}}
  await this.notifications.save({recipientId:req.user.id===b.customerId?b.workerId:b.customerId,title:'Booking updated',body:`Booking status: ${to}`});return b;
 }
 @Get(':id/messages') async listMessages(@Req() req:any,@Param('id') id:string){await this.accessible(id,req.user);return this.messages.find({where:{bookingId:id},order:{createdAt:'ASC'},take:200});}
 @Post(':id/messages') async message(@Req() req:any,@Param('id') id:string,@Body() dto:MessageDto){const b=await this.accessible(id,req.user);if([BookingStatus.CANCELLED].includes(b.status))throw new BadRequestException('Booking closed');const msg=await this.messages.save({bookingId:id,senderId:req.user.id,body:dto.body});await this.notifications.save({recipientId:req.user.id===b.customerId?b.workerId:b.customerId,title:'New message',body:'You have a new booking message.'});return msg;}
 @Post('reviews') @Roles(Role.CUSTOMER) async review(@Req() req:any,@Body() dto:ReviewDto){const b=await this.bookings.findOneBy({id:dto.bookingId,customerId:req.user.id,status:BookingStatus.COMPLETED});if(!b)throw new ForbiddenException('Only completed bookings may be reviewed');if(await this.reviews.exist({where:{bookingId:b.id}}))throw new ConflictException('Already reviewed');
  const review=await this.reviews.save(this.reviews.create({...dto,customerId:req.user.id,workerId:b.workerId,visible:true}));
  const stats=await this.reviews.createQueryBuilder('r').select('COUNT(*)','count').addSelect('AVG(r.stars)','avg').where('r.workerId=:id AND r.visible = true',{id:b.workerId}).getRawOne();
  const w=await this.workers.findOneBy({userId:b.workerId});if(w){w.ratingCount=Number(stats.count);w.ratingAverage=Number(Number(stats.avg||0).toFixed(2));await this.workers.save(w);}return review;
 }
}

@Controller('notifications') @UseGuards(AuthGuard)
export class NotificationController {
 constructor(@InjectRepository(Notification) private data:Repository<Notification>){}
 @Get() list(@Req() req:any){return this.data.find({where:{recipientId:req.user.id},order:{createdAt:'DESC'},take:100});}
 @Patch(':id/read') async read(@Req() req:any,@Param('id') id:string){const n=await this.data.findOneBy({id,recipientId:req.user.id});if(!n)throw new NotFoundException();n.read=true;return this.data.save(n);}
}
