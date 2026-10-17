import 'dotenv/config';
import 'reflect-metadata';
import {NestFactory} from '@nestjs/core';
import {ValidationPipe} from '@nestjs/common';
import helmet from 'helmet';
import compression from 'compression';
import {AppModule} from './module';
import {resolve} from 'node:path';
import {mkdir} from 'node:fs/promises';
import express from 'express';
import {seed} from './seed';
import {DataSource} from 'typeorm';

async function bootstrap(){
 if(process.env.NODE_ENV==='production' && (!process.env.JWT_SECRET || process.env.JWT_SECRET.length<32 || (process.env.DATABASE_URL||'').includes('hunar_dev_password')))throw new Error('Production secrets/database not configured');
 if(!process.env.JWT_SECRET || process.env.JWT_SECRET.length<32)throw new Error('Set JWT_SECRET to at least 32 characters');
 const app=await NestFactory.create(AppModule,{bodyParser:true});
 app.use(helmet({crossOriginResourcePolicy:{policy:'cross-origin'}}));app.use(compression());
 app.enableCors({origin:(process.env.CORS_ORIGINS||'http://localhost:3000').split(','),methods:['GET','POST','PUT','PATCH','DELETE'],allowedHeaders:['Authorization','Content-Type'],maxAge:600});
 app.useGlobalPipes(new ValidationPipe({whitelist:true,forbidNonWhitelisted:true,transform:true,transformOptions:{enableImplicitConversion:true}}));
 app.setGlobalPrefix('api');
 const publicDir=resolve(process.env.UPLOAD_DIR||'uploads','public');await mkdir(publicDir,{recursive:true});
 app.use('/media',express.static(publicDir,{dotfiles:'deny',immutable:true,maxAge:'7d'}));
 await seed(app.get(DataSource));
 const port=Number(process.env.PORT||4000);await app.listen(port,'0.0.0.0');console.log(`API ready on http://localhost:${port}/api/public/services`);
}
bootstrap().catch(e=>{console.error(e);process.exit(1)});
