import { Injectable, Controller, Body, Post, Get, Req, UnauthorizedException, ConflictException, BadRequestException, CanActivate, ExecutionContext, SetMetadata, UseGuards, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { JwtService } from '@nestjs/jwt';
import { Repository, MoreThan } from 'typeorm';
import { IsEnum, IsString, Matches, MaxLength, MinLength } from 'class-validator';
import { Reflector } from '@nestjs/core';
import {Throttle} from '@nestjs/throttler';
import * as bcrypt from 'bcryptjs';
import { randomInt } from 'node:crypto';
import { User,Role,WorkerProfile,PhoneOtp } from './entities';

export function normalizePhone(raw:string):string {
 const digits=String(raw??'').replace(/\D/g,'');
 if (/^03\d{9}$/.test(digits)) return '+92'+digits.substring(1);
 if (/^923\d{9}$/.test(digits)) return '+'+digits;
 throw new BadRequestException('Enter a valid Pakistani mobile number (03XXXXXXXXX).');
}
export class RegisterDto {
 @IsString() @MinLength(2) @MaxLength(120) name!:string;
 @IsString() phone!:string;
 @IsString() @MinLength(10) @MaxLength(128) password!:string;
 @IsEnum(Role) role!:Role;
}
export class LoginDto { @IsString() phone!:string; @IsString() password!:string; }
export class CodeDto { @IsString() phone!:string; @IsString() @Matches(/^\d{6}$/) code!:string; }

@Injectable()
export class AuthService {
 constructor(@InjectRepository(User) private users:Repository<User>,@InjectRepository(WorkerProfile) private workers:Repository<WorkerProfile>,@InjectRepository(PhoneOtp) private otps:Repository<PhoneOtp>,private jwt:JwtService){}
 async register(dto:RegisterDto){
  if(dto.role!==Role.CUSTOMER && dto.role!==Role.WORKER) throw new BadRequestException('Invalid registration role');
  const phone=normalizePhone(dto.phone);
  if(await this.users.exist({where:{phone}})) throw new ConflictException('Phone already registered');
  const user=await this.users.save(this.users.create({name:dto.name.trim(),phone,role:dto.role,passwordHash:await bcrypt.hash(dto.password,12)}));
  if(dto.role===Role.WORKER) await this.workers.save(this.workers.create({userId:user.id}));
  await this.issueCode(user);
  return {message:'Account created. Verify your phone with the 6-digit code.',phone:user.phone};
 }
 private async issueCode(user:User){
  const code=String(randomInt(100000,1000000));
  await this.otps.update({userId:user.id,consumed:false},{consumed:true});
  await this.otps.save(this.otps.create({userId:user.id,codeHash:await bcrypt.hash(code,11),expiresAt:new Date(Date.now()+5*60_000)}));
  const endpoint=process.env.SMS_API_URL;
  if(endpoint){
   const res=await fetch(endpoint,{method:'POST',headers:{'Content-Type':'application/json',Authorization:`Bearer ${process.env.SMS_API_KEY||''}`},body:JSON.stringify({phone:user.phone,message:`Hunar Near Me: your verification code is ${code}. Expires in 5 minutes.`})});
   if(!res.ok) throw new BadRequestException('SMS delivery failed. Please retry.');
  } else if(process.env.NODE_ENV!=='production') {
   console.log(`[DEVELOPMENT ONLY] OTP for ${user.phone}: ${code}`);
  } else throw new BadRequestException('SMS provider must be configured for production');
 }
 async resend(phoneRaw:string){const phone=normalizePhone(phoneRaw);const user=await this.users.findOneBy({phone});
  // Avoid revealing whether an account exists to an unauthenticated caller.
  if(!user || user.phoneVerified) return {message:'If verification is needed, a code was sent.'};
  const latest=await this.otps.findOne({where:{userId:user.id},order:{createdAt:'DESC'}});
  if(latest && Date.now()-latest.createdAt.getTime()<60_000) throw new BadRequestException('Wait one minute before retrying.');
  await this.issueCode(user);return {message:'If verification is needed, a code was sent.'};
 }
 async verify(dto:CodeDto){const phone=normalizePhone(dto.phone);const user=await this.users.findOneBy({phone});if(!user) throw new BadRequestException('Invalid code');
  const otp=await this.otps.findOne({where:{userId:user.id,consumed:false,expiresAt:MoreThan(new Date())},order:{createdAt:'DESC'}});
  if(!otp || otp.attempts>=5) throw new BadRequestException('Code expired or invalid');
  otp.attempts+=1;await this.otps.save(otp);
  if(!await bcrypt.compare(dto.code,otp.codeHash)) throw new BadRequestException('Invalid code');
  otp.consumed=true;await this.otps.save(otp);user.phoneVerified=true;await this.users.save(user);
  return this.tokens(user);
 }
 async login(dto:LoginDto){const phone=normalizePhone(dto.phone);const user=await this.users.createQueryBuilder('u').addSelect('u.passwordHash').where('u.phone = :phone',{phone}).getOne();
  if(!user || !await bcrypt.compare(dto.password,user.passwordHash) || !user.active) throw new UnauthorizedException('Invalid login credentials');
  if(!user.phoneVerified) throw new UnauthorizedException('Verify your mobile number first');
  return this.tokens(user);
 }
 tokens(user:User){return {accessToken:this.jwt.sign({sub:user.id,role:user.role},{expiresIn:'8h'}),user:{id:user.id,name:user.name,phone:user.phone,role:user.role,photoUrl:user.photoUrl}};}
 async me(id:string){const user=await this.users.findOneBy({id,active:true});if(!user) throw new NotFoundException();return {id:user.id,name:user.name,phone:user.phone,role:user.role,photoUrl:user.photoUrl};}
}

export const Roles=(...roles:Role[])=>SetMetadata('roles',roles);
@Injectable()
export class AuthGuard implements CanActivate {
 constructor(private jwt:JwtService,private reflector:Reflector,@InjectRepository(User) private users:Repository<User>){}
 async canActivate(ctx:ExecutionContext){const req=ctx.switchToHttp().getRequest();const raw=req.headers.authorization||'';
  if(!raw.startsWith('Bearer '))throw new UnauthorizedException();
  try{const claims=await this.jwt.verifyAsync(raw.substring(7));const user=await this.users.findOneBy({id:claims.sub,active:true});
   if(!user || user.role!==claims.role || !user.phoneVerified) throw new Error('revoked');
   const allowed=this.reflector.getAllAndOverride<Role[]>('roles',[ctx.getHandler(),ctx.getClass()]);
   if(allowed && !allowed.includes(user.role)) throw new Error('role');
   req.user={id:user.id,role:user.role,phone:user.phone};return true;
  }catch{throw new UnauthorizedException('Invalid or expired session or insufficient permissions');}
 }
}
@Controller('auth')
export class AuthController {
 constructor(private auth:AuthService){}
 @Throttle({default:{limit:5,ttl:60000}}) @Post('register') register(@Body() body:RegisterDto){return this.auth.register(body)}
 @Throttle({default:{limit:8,ttl:60000}}) @Post('login') login(@Body() body:LoginDto){return this.auth.login(body)}
 @Throttle({default:{limit:3,ttl:60000}}) @Post('resend-otp') resend(@Body('phone') phone:string){return this.auth.resend(phone)}
 @Throttle({default:{limit:8,ttl:60000}}) @Post('verify-otp') verify(@Body() body:CodeDto){return this.auth.verify(body)}
 @Get('me') @UseGuards(AuthGuard) me(@Req() req:any){return this.auth.me(req.user.id)}
}
