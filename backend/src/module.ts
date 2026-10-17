import {Module} from '@nestjs/common';
import {TypeOrmModule} from '@nestjs/typeorm';
import {JwtModule} from '@nestjs/jwt';
import {ThrottlerGuard,ThrottlerModule} from '@nestjs/throttler';
import {APP_GUARD} from '@nestjs/core';
import {AdminAuditEvent,AppSetting,Booking,Location,Message,Notification,PhoneOtp,Review,ServiceType,User,WorkerPayment,WorkerProfile} from './entities';
import {AuthController,AuthGuard,AuthService} from './auth';
import {AdminController} from './admin';
import {PublicController,WorkerController,BookingController,NotificationController} from './market';
const entities=[AdminAuditEvent,AppSetting,Booking,Location,Message,Notification,PhoneOtp,Review,ServiceType,User,WorkerPayment,WorkerProfile];
@Module({
 imports:[TypeOrmModule.forRoot({type:'postgres',url:process.env.DATABASE_URL||'postgres://hunar:hunar_dev_password@localhost:5432/hunar',entities,synchronize:process.env.NODE_ENV!=='production',logging:false,ssl:process.env.DATABASE_SSL==='true'?{rejectUnauthorized:true}:false}),TypeOrmModule.forFeature(entities),JwtModule.register({secret:process.env.JWT_SECRET||'',signOptions:{issuer:'hunar-near-me'}}),ThrottlerModule.forRoot([{ttl:60000,limit:45}])],
 controllers:[AuthController,PublicController,WorkerController,BookingController,NotificationController,AdminController],
 providers:[AuthService,AuthGuard,{provide:APP_GUARD,useClass:ThrottlerGuard}]
})export class AppModule{}
