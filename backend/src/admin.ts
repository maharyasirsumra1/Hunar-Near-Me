import {BadRequestException,Body,Controller,Get,Param,Patch,Post,Put,Query,Req,Res,UseGuards,UseInterceptors,UploadedFile,NotFoundException,ForbiddenException} from '@nestjs/common';
import {FileInterceptor} from '@nestjs/platform-express';
import {memoryStorage} from 'multer';
import {InjectRepository} from '@nestjs/typeorm';
import {Repository} from 'typeorm';
import {IsBoolean,IsIn,IsNumber,IsOptional,IsString,IsUUID,Max,MaxLength,Min} from 'class-validator';
import {randomUUID} from 'node:crypto';
import {mkdir,readFile,writeFile} from 'node:fs/promises';
import {join,resolve} from 'node:path';
import sharp from 'sharp';
import {AdminAuditEvent,AppSetting,Booking,Location,Notification,Review,Role,ServiceType,User,WorkerPayment,WorkerProfile,WorkerStatus} from './entities';
import {AuthGuard,Roles} from './auth';
import {DEFAULT_CONTENT} from './market';

class ServiceDto {
 @IsString() @MaxLength(100) name!:string;
 @IsOptional() @IsString() @MaxLength(100) nameUrdu?:string;
 @IsString() @MaxLength(90) slug!:string;
 @IsOptional() @IsString() @MaxLength(50) icon?:string;
 @IsOptional() @IsString() @MaxLength(1500) imageUrl?:string;
 @IsOptional() @IsBoolean() active?:boolean;
 @IsOptional() @IsNumber() sortOrder?:number;
}
class LocationDto {
 @IsString() @MaxLength(100) name!:string;
 @IsIn(['province','city','area','subarea']) kind!:'province'|'city'|'area'|'subarea';
 @IsOptional() @IsUUID() parentId?:string;
 @IsOptional() @IsNumber() @Min(-90) @Max(90) latitude?:number;
 @IsOptional() @IsNumber() @Min(-180) @Max(180) longitude?:number;
 @IsOptional() @IsBoolean() active?:boolean;
}
@Controller('admin') @UseGuards(AuthGuard) @Roles(Role.ADMIN)
export class AdminController {
 constructor(@InjectRepository(User) private users:Repository<User>,@InjectRepository(WorkerProfile) private workers:Repository<WorkerProfile>,@InjectRepository(WorkerPayment) private payments:Repository<WorkerPayment>,@InjectRepository(ServiceType) private services:Repository<ServiceType>,@InjectRepository(Location) private locations:Repository<Location>,@InjectRepository(AppSetting) private settings:Repository<AppSetting>,@InjectRepository(Review) private reviews:Repository<Review>,@InjectRepository(Booking) private bookings:Repository<Booking>,@InjectRepository(AdminAuditEvent) private audits:Repository<AdminAuditEvent>,@InjectRepository(Notification) private notifications:Repository<Notification>){}
 private async audit(req:any,action:string,targetId:string,detail?:unknown){await this.audits.save({adminId:req.user.id,action,targetId,detail});}
 @Get('summary') async summary(){const [customers,workers,pending,approved,payments,bookings,reviews]=await Promise.all([
  this.users.count({where:{role:Role.CUSTOMER}}),this.users.count({where:{role:Role.WORKER}}),this.workers.count({where:{status:WorkerStatus.PENDING}}),this.workers.count({where:{status:WorkerStatus.APPROVED}}),this.payments.count({where:{status:'PENDING'}}),this.bookings.count(),this.reviews.count()]);return {customers,workers,pending,approved,pendingPayments:payments,bookings,reviews};}
 @Get('customers') async customers(){return this.users.find({where:{role:Role.CUSTOMER},order:{createdAt:'DESC'},take:400}).then(rows=>rows.map(u=>({id:u.id,name:u.name,phone:u.phone,active:u.active,phoneVerified:u.phoneVerified,createdAt:u.createdAt})));}
 @Patch('customers/:id/active') async customerActive(@Req() req:any,@Param('id') id:string,@Body('active') active:boolean){
  if(typeof active!=='boolean')throw new BadRequestException('active must be a boolean');
  const u=await this.users.findOneBy({id,role:Role.CUSTOMER});if(!u)throw new NotFoundException();
  u.active=active;await this.users.save(u);await this.audit(req,active?'CUSTOMER_RESTORED':'CUSTOMER_SUSPENDED',id);return {id,active};
 }
 @Post('notifications/send') async sendNotification(@Req() req:any,@Body() body:{audience:string;title:string;message:string}){
  if(!['customers','workers','all'].includes(body.audience)||typeof body.title!=='string'||body.title.trim().length<3||body.title.length>140||typeof body.message!=='string'||body.message.trim().length<3||body.message.length>700)throw new BadRequestException('Invalid audience, title or message');
  const recipients=await this.users.find({where:{active:true}});const targets=recipients.filter(u=>u.role!==Role.ADMIN&&(body.audience==='all'||u.role===(body.audience==='workers'?Role.WORKER:Role.CUSTOMER)));
  if(targets.length>10000)throw new BadRequestException('Use a queued batch job for large broadcasts');
  for(const batch of Array.from({length:Math.ceil(targets.length/250)},(_,i)=>targets.slice(i*250,(i+1)*250))){await this.notifications.insert(batch.map(u=>({recipientId:u.id,title:body.title.trim(),body:body.message.trim(),read:false})));}
  await this.audit(req,'ANNOUNCEMENT_SENT',body.audience,{recipients:targets.length});return {sent:targets.length};
 }
 @Get('workers') async listWorkers(@Query('status') status?:WorkerStatus){const profiles=await this.workers.find({where:status?{status}:{},order:{createdAt:'DESC'},take:400});const users=await this.users.find();const u=new Map(users.map(x=>[x.id,x]));return profiles.map(w=>({...w,user:{id:w.userId,name:u.get(w.userId)?.name||'',phone:u.get(w.userId)?.phone||'',phoneVerified:u.get(w.userId)?.phoneVerified||false}}));}
 @Get('payments') async listPayments(){return this.payments.find({order:{createdAt:'DESC'},take:400}).then(rows=>rows.map(({screenshotPath,...x})=>({...x,hasScreenshot:!!screenshotPath})));}
 @Get('payments/:id/screenshot') async screenshot(@Param('id') id:string,@Res() res:any){const payment=await this.payments.findOneBy({id});if(!payment?.screenshotPath)throw new NotFoundException();
  if(!/^[a-f\d-]{36}\.webp$/i.test(payment.screenshotPath))throw new BadRequestException();const file=await readFile(join(resolve(process.env.UPLOAD_DIR||'uploads','private'),payment.screenshotPath));res.set('Content-Type','image/webp');res.set('Cache-Control','no-store');res.send(file);
 }
 @Patch('payments/:id') async paymentDecision(@Req() req:any,@Param('id') id:string,@Body() body:{status:string;adminNote?:string}){
  if(!['VERIFIED','REJECTED'].includes(body.status))throw new BadRequestException('Invalid payment status');const p=await this.payments.findOneBy({id,status:'PENDING'});if(!p)throw new NotFoundException();
  p.status=body.status as any;p.reviewedBy=req.user.id;p.adminNote=String(body.adminNote||'').slice(0,1000);await this.payments.save(p);await this.audit(req,'PAYMENT_'+body.status,id,{amount:p.amountPkr,method:p.method});
  await this.notifications.save({recipientId:p.workerId,title:'Payment verification update',body:`Your registration payment is ${body.status.toLowerCase()}.`});return p;
 }
 @Patch('workers/:id/status') async workerDecision(@Req() req:any,@Param('id') id:string,@Body() body:{status:WorkerStatus;verifiedBadge?:boolean;note?:string}){
  if(![WorkerStatus.APPROVED,WorkerStatus.REJECTED,WorkerStatus.SUSPENDED,WorkerStatus.PENDING].includes(body.status))throw new BadRequestException('Invalid worker status');
  const w=await this.workers.findOneBy({id});if(!w)throw new NotFoundException();
  if(body.status===WorkerStatus.APPROVED){
   const u=await this.users.findOneBy({id:w.userId});if(!u?.phoneVerified)throw new BadRequestException('Worker phone must be verified');
   if(!w.serviceIds.length || !w.cityId || w.latitude===null || w.longitude===null)throw new BadRequestException('Worker must complete skills, city and location');
   const s=await this.settings.findOneBy({key:'appContent'});const fee=Number((s?.value as any)?.workerFeePkr??DEFAULT_CONTENT.workerFeePkr);
   if(fee>0 && !await this.payments.exist({where:{workerId:w.userId,status:'VERIFIED'}}))throw new BadRequestException('Verify registration payment before approval');
  }
  w.status=body.status;w.verifiedBadge=body.verifiedBadge===true;w.verificationNotes=String(body.note||'').slice(0,1500);await this.workers.save(w);
  await this.audit(req,'WORKER_'+body.status,id,{verifiedBadge:w.verifiedBadge});await this.notifications.save({recipientId:w.userId,title:'Worker application update',body:`Application status: ${w.status}`});return w;
 }
 @Get('services') servicesList(){return this.services.find({order:{sortOrder:'ASC',name:'ASC'}});}
 @Post('services') async createService(@Req() req:any,@Body() dto:ServiceDto){if(!/^[a-z0-9-]+$/.test(dto.slug))throw new BadRequestException('Slug must be lowercase letters, numbers or hyphens');const s=await this.services.save(this.services.create(dto));await this.audit(req,'SERVICE_CREATED',s.id);return s;}
 @Put('services/:id') async editService(@Req() req:any,@Param('id') id:string,@Body() dto:ServiceDto){const s=await this.services.findOneBy({id});if(!s)throw new NotFoundException();Object.assign(s,dto);await this.services.save(s);await this.audit(req,'SERVICE_UPDATED',id);return s;}
 @Get('locations') locationsList(){return this.locations.find({order:{kind:'ASC',name:'ASC'}});}
 @Post('locations') async createLocation(@Req() req:any,@Body() dto:LocationDto){if(dto.kind!=='province'&&!dto.parentId)throw new BadRequestException('Select a parent location');const loc=await this.locations.save(this.locations.create(dto));await this.audit(req,'LOCATION_CREATED',loc.id);return loc;}
 @Put('locations/:id') async editLocation(@Req() req:any,@Param('id') id:string,@Body() dto:LocationDto){const loc=await this.locations.findOneBy({id});if(!loc)throw new NotFoundException();Object.assign(loc,dto);await this.locations.save(loc);await this.audit(req,'LOCATION_UPDATED',id);return loc;}
 @Get('config') async config(){return (await this.settings.findOneBy({key:'appContent'}))?.value||DEFAULT_CONTENT;}
 @Put('config') async editConfig(@Req() req:any,@Body() data:any){
  if(!data || typeof data!=='object'||Array.isArray(data))throw new BadRequestException('Config must be an object');
  if(typeof data.appName!=='string'||typeof data.labels!=='object'||typeof data.images!=='object')throw new BadRequestException('Required branding fields missing');
  const amount=Number(data.workerFeePkr);if(!Number.isInteger(amount)||amount<0||amount>1_000_000)throw new BadRequestException('Worker fee must be 0–1,000,000 PKR');
  if(JSON.stringify(data).length>40000)throw new BadRequestException('Config too large');
  const s=await this.settings.findOneBy({key:'appContent'});await this.settings.save(s?{...s,value:data}:{key:'appContent',value:data});await this.audit(req,'CONFIG_UPDATED','appContent');return data;
 }
 @Post('content-image') @UseInterceptors(FileInterceptor('file',{storage:memoryStorage(),limits:{fileSize:5*1024*1024}}))
 async contentImage(@Req() req:any,@UploadedFile() file?:Express.Multer.File){if(!file)throw new BadRequestException('Select a file');let bytes:Buffer;
  try{bytes=await sharp(file.buffer,{limitInputPixels:16_000_000}).rotate().resize({width:1500,withoutEnlargement:true}).webp({quality:80}).toBuffer();}catch{throw new BadRequestException('Invalid image');}
  const dir=resolve(process.env.UPLOAD_DIR||'uploads','public');await mkdir(dir,{recursive:true});const name=randomUUID()+'.webp';await writeFile(join(dir,name),bytes,{flag:'wx'});await this.audit(req,'IMAGE_UPLOADED',name);return {url:`${process.env.PUBLIC_API_URL||'http://localhost:4000'}/media/${name}`};
 }
 @Get('reviews') listReviews(){return this.reviews.find({order:{createdAt:'DESC'},take:400});}
 @Patch('reviews/:id') async moderation(@Req() req:any,@Param('id') id:string,@Body() body:{visible?:boolean;reported?:boolean}){const r=await this.reviews.findOneBy({id});if(!r)throw new NotFoundException();if(typeof body.visible==='boolean')r.visible=body.visible;if(typeof body.reported==='boolean')r.reported=body.reported;await this.reviews.save(r);
  const stats=await this.reviews.createQueryBuilder('x').select('COUNT(*)','count').addSelect('AVG(x.stars)','avg').where('x.workerId=:id AND x.visible = true',{id:r.workerId}).getRawOne();const w=await this.workers.findOneBy({userId:r.workerId});if(w){w.ratingCount=Number(stats.count);w.ratingAverage=Number(Number(stats.avg||0).toFixed(2));await this.workers.save(w);}await this.audit(req,'REVIEW_MODERATED',id,body);return r;
 }
 @Get('bookings') bookingsList(){return this.bookings.find({order:{createdAt:'DESC'},take:400});}
 @Get('audit') auditList(){return this.audits.find({order:{createdAt:'DESC'},take:200});}
}
