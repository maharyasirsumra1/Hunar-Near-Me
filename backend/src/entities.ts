import { Column, CreateDateColumn, Entity, Index, PrimaryGeneratedColumn, UpdateDateColumn } from 'typeorm';

export enum Role { CUSTOMER='CUSTOMER', WORKER='WORKER', ADMIN='ADMIN' }
export enum WorkerStatus { PENDING='PENDING', APPROVED='APPROVED', REJECTED='REJECTED', SUSPENDED='SUSPENDED' }
export enum BookingStatus { REQUESTED='REQUESTED', QUOTED='QUOTED', ACCEPTED='ACCEPTED', IN_PROGRESS='IN_PROGRESS', COMPLETED='COMPLETED', CANCELLED='CANCELLED', DISPUTED='DISPUTED' }

@Entity('users')
@Index(['phone'], {unique:true})
export class User {
 @PrimaryGeneratedColumn('uuid') id!:string;
 @Column({length:24}) phone!:string;
 @Column({select:false}) passwordHash!:string;
 @Column({length:120}) name!:string;
 @Column({type:'enum', enum:Role}) role!:Role;
 @Column({default:false}) phoneVerified!:boolean;
 @Column({default:true}) active!:boolean;
 @Column({nullable:true,type:'text'}) photoUrl!:string|null;
 @CreateDateColumn() createdAt!:Date;
}

@Entity('service_types')
export class ServiceType {
 @PrimaryGeneratedColumn('uuid') id!:string;
 @Column({unique:true,length:90}) slug!:string;
 @Column({length:100}) name!:string;
 @Column({nullable:true,length:120}) nameUrdu!:string|null;
 @Column({default:'wrench',length:50}) icon!:string;
 @Column({nullable:true,type:'text'}) imageUrl!:string|null;
 @Column({default:true}) active!:boolean;
 @Column({default:0}) sortOrder!:number;
 @CreateDateColumn() createdAt!:Date;
}

@Entity('locations')
@Index(['kind','parentId'])
export class Location {
 @PrimaryGeneratedColumn('uuid') id!:string;
 @Column({length:100}) name!:string;
 @Column({length:25}) kind!:'province'|'city'|'area'|'subarea';
 @Column({nullable:true,type:'uuid'}) parentId!:string|null;
 @Column({type:'double precision',nullable:true}) latitude!:number|null;
 @Column({type:'double precision',nullable:true}) longitude!:number|null;
 @Column({default:true}) active!:boolean;
}

@Entity('worker_profiles')
@Index(['cityId','areaId','status'])
export class WorkerProfile {
 @PrimaryGeneratedColumn('uuid') id!:string;
 @Column({unique:true,type:'uuid'}) userId!:string;
 @Column({type:'enum',enum:WorkerStatus,default:WorkerStatus.PENDING}) status!:WorkerStatus;
 @Column({type:'simple-array',default:''}) serviceIds!:string[];
 @Column({type:'uuid',nullable:true}) cityId!:string|null;
 @Column({type:'uuid',nullable:true}) areaId!:string|null;
 @Column({type:'double precision',nullable:true}) latitude!:number|null;
 @Column({type:'double precision',nullable:true}) longitude!:number|null;
 @Column({type:'double precision',default:15}) serviceRadiusKm!:number;
 @Column({type:'int',default:0}) experienceYears!:number;
 @Column({type:'text',default:''}) bio!:string;
 @Column({type:'simple-array',default:''}) photoUrls!:string[];
 @Column({default:false}) publicContact!:boolean;
 @Column({default:true}) homeVisits!:boolean;
 @Column({default:false}) shopVisits!:boolean;
 @Column({default:false}) emergencyAvailable!:boolean;
 @Column({type:'double precision',default:0}) ratingAverage!:number;
 @Column({type:'int',default:0}) ratingCount!:number;
 @Column({type:'int',default:0}) completedJobs!:number;
 @Column({default:false}) verifiedBadge!:boolean;
 @Column({type:'text',nullable:true}) verificationNotes!:string|null;
 @CreateDateColumn() createdAt!:Date;
 @UpdateDateColumn() updatedAt!:Date;
}

@Entity('worker_payments')
@Index(['method','transactionReference'],{unique:true})
export class WorkerPayment {
 @PrimaryGeneratedColumn('uuid') id!:string;
 @Column({type:'uuid'}) workerId!:string;
 @Column({type:'varchar',length:20}) method!:'EASYPAISA'|'JAZZCASH';
 @Column({type:'varchar',length:100}) transactionReference!:string;
 @Column({type:'int'}) amountPkr!:number;
 @Column({type:'text',nullable:true}) screenshotPath!:string|null;
 @Column({default:'PENDING',length:20}) status!:'PENDING'|'VERIFIED'|'REJECTED';
 @Column({nullable:true,type:'uuid'}) reviewedBy!:string|null;
 @Column({nullable:true,type:'text'}) adminNote!:string|null;
 @CreateDateColumn() createdAt!:Date;
}

@Entity('bookings')
export class Booking {
 @PrimaryGeneratedColumn('uuid') id!:string;
 @Column({type:'uuid'}) customerId!:string;
 @Column({type:'uuid'}) workerId!:string;
 @Column({type:'uuid'}) serviceId!:string;
 @Column({type:'text'}) description!:string;
 @Column({type:'enum',enum:BookingStatus,default:BookingStatus.REQUESTED}) status!:BookingStatus;
 @Column({type:'int',nullable:true}) proposedPricePkr!:number|null;
 @Column({type:'int',nullable:true}) quotedPricePkr!:number|null;
 @Column({type:'uuid',nullable:true}) cityId!:string|null;
 @Column({type:'uuid',nullable:true}) areaId!:string|null;
 @Column({type:'double precision',nullable:true}) latitude!:number|null;
 @Column({type:'double precision',nullable:true}) longitude!:number|null;
 @Column({type:'text',default:''}) address!:string;
 @CreateDateColumn() createdAt!:Date;
 @UpdateDateColumn() updatedAt!:Date;
}

@Entity('reviews')
@Index(['bookingId'], {unique:true})
export class Review {
 @PrimaryGeneratedColumn('uuid') id!:string;
 @Column({type:'uuid'}) bookingId!:string;
 @Column({type:'uuid'}) customerId!:string;
 @Column({type:'uuid'}) workerId!:string;
 @Column({type:'int'}) stars!:number;
 @Column({type:'varchar',length:800,default:''}) comment!:string;
 @Column({default:true}) visible!:boolean;
 @Column({default:false}) reported!:boolean;
 @Column({type:'varchar',length:600,default:''}) workerReply!:string;
 @CreateDateColumn() createdAt!:Date;
}

@Entity('messages')
export class Message {
 @PrimaryGeneratedColumn('uuid') id!:string;
 @Column({type:'uuid'}) bookingId!:string;
 @Column({type:'uuid'}) senderId!:string;
 @Column({type:'varchar',length:1500}) body!:string;
 @CreateDateColumn() createdAt!:Date;
}

@Entity('app_settings')
export class AppSetting {
 @PrimaryGeneratedColumn('uuid') id!:string;
 @Column({unique:true,length:120}) key!:string;
 @Column({type:'jsonb'}) value!:unknown;
 @UpdateDateColumn() updatedAt!:Date;
}

@Entity('notifications')
export class Notification {
 @PrimaryGeneratedColumn('uuid') id!:string;
 @Column({type:'uuid'}) recipientId!:string;
 @Column({type:'varchar',length:140}) title!:string;
 @Column({type:'varchar',length:700}) body!:string;
 @Column({default:false}) read!:boolean;
 @CreateDateColumn() createdAt!:Date;
}

@Entity('admin_audit_events')
export class AdminAuditEvent {
 @PrimaryGeneratedColumn('uuid') id!:string;
 @Column({type:'uuid'}) adminId!:string;
 @Column({length:100}) action!:string;
 @Column({length:100}) targetId!:string;
 @Column({type:'jsonb',nullable:true}) detail!:unknown;
 @CreateDateColumn() createdAt!:Date;
}

@Entity('phone_otps')
export class PhoneOtp {
 @PrimaryGeneratedColumn('uuid') id!:string;
 @Column({type:'uuid'}) userId!:string;
 @Column({type:'varchar',length:100}) codeHash!:string;
 @Column({type:'timestamp with time zone'}) expiresAt!:Date;
 @Column({default:0}) attempts!:number;
 @Column({default:false}) consumed!:boolean;
 @CreateDateColumn() createdAt!:Date;
}
