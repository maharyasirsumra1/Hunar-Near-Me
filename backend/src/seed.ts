import {DataSource,Repository} from 'typeorm';
import {AppSetting,Location,Role,ServiceType,User} from './entities';
import {DEFAULT_CONTENT} from './market';
import {normalizePhone} from './auth';
import * as bcrypt from 'bcryptjs';

const serviceSeed:[string,string,string,string][]=[
 ['electrician','Electrician','الیکٹریشن','zap'],['plumber','Plumber','پلمبر','droplets'],['ac-repair','AC Repair','اے سی مرمت','snowflake'],['mechanic','Mechanic','مکینک','wrench'],['painter','Painter','پینٹر','paint-roller'],['carpenter','Carpenter','بڑھئی','hammer'],['cleaning','Cleaning','صفائی','sparkles'],['tutor','Tutor','ٹیوٹر','graduation-cap'],['tailor','Tailor','درزی','scissors'],['cook','Cook','باورچی','chef-hat'],['gardener','Gardener','مالی','sprout'],['more','More','مزید','ellipsis']
];
// Sample seed only; admin may create all remaining cities, areas, phases and blocks.
const geography:{province:string;cities:{name:string;lat:number;lng:number;areas:string[]}[]}[]=[
 {province:'Punjab',cities:[{name:'Lahore',lat:31.5204,lng:74.3587,areas:['DHA','Johar Town','Gulberg','Model Town','Bahria Town','Wapda Town','Township','Iqbal Town']},{name:'Rawalpindi',lat:33.5651,lng:73.0169,areas:['Saddar','Chaklala','Satellite Town','Bahria Town']},{name:'Faisalabad',lat:31.4504,lng:73.1350,areas:['D Ground','Madina Town']},{name:'Multan',lat:30.1575,lng:71.5249,areas:['Cantt','Gulgasht']}]},
 {province:'Sindh',cities:[{name:'Karachi',lat:24.8607,lng:67.0011,areas:['Gulshan-e-Iqbal','DHA','Clifton','North Nazimabad','Malir']},{name:'Hyderabad',lat:25.3960,lng:68.3578,areas:['Latifabad','Qasimabad']}]},
 {province:'Khyber Pakhtunkhwa',cities:[{name:'Peshawar',lat:34.0151,lng:71.5249,areas:['Hayatabad','University Town','Saddar']},{name:'Abbottabad',lat:34.1688,lng:73.2215,areas:['Mandian','Jinnahabad']}]},
 {province:'Balochistan',cities:[{name:'Quetta',lat:30.1798,lng:66.9750,areas:['Jinnah Town','Satellite Town']}]},
 {province:'Islamabad Capital Territory',cities:[{name:'Islamabad',lat:33.6844,lng:73.0479,areas:['F-10','G-11','I-8','DHA','Bahria Enclave']}]},
 {province:'Azad Jammu and Kashmir',cities:[{name:'Muzaffarabad',lat:34.3700,lng:73.4711,areas:['City Centre','Upper Chattar']}]},
 {province:'Gilgit-Baltistan',cities:[{name:'Gilgit',lat:35.9208,lng:74.3140,areas:['Jutial','Kashrote']}]}
];
export async function seed(ds:DataSource){
 await ds.query('CREATE EXTENSION IF NOT EXISTS postgis');
 const services=ds.getRepository(ServiceType),locations=ds.getRepository(Location),settings=ds.getRepository(AppSetting),users=ds.getRepository(User);
 if(await services.count()===0)for(let i=0;i<serviceSeed.length;i++){const [slug,name,nameUrdu,icon]=serviceSeed[i];await services.save({slug,name,nameUrdu,icon,sortOrder:i,active:true});}
 if(await locations.count()===0){for(const item of geography){const province=await locations.save({name:item.province,kind:'province',parentId:null,active:true});for(const city of item.cities){const c=await locations.save({name:city.name,kind:'city',parentId:province.id,latitude:city.lat,longitude:city.lng,active:true});for(const name of city.areas)await locations.save({name,kind:'area',parentId:c.id,latitude:city.lat,longitude:city.lng,active:true});}}}
 if(!await settings.exist({where:{key:'appContent'}}))await settings.save({key:'appContent',value:{...DEFAULT_CONTENT,easypaisaNumber:process.env.WORKER_EASYPaisa_NUMBER||'',jazzcashNumber:process.env.WORKER_JAZZCASH_NUMBER||''}});
 const phoneRaw=process.env.ADMIN_PHONE,password=process.env.ADMIN_PASSWORD;
 if(phoneRaw && password && password.length>=12){const phone=normalizePhone(phoneRaw);const existing=await users.findOneBy({phone});if(!existing){await users.save({phone,name:'Hunar Administrator',passwordHash:await bcrypt.hash(password,12),role:Role.ADMIN,phoneVerified:true});console.log('Admin created from ADMIN_PHONE / ADMIN_PASSWORD environment variables');}}
 else if(process.env.NODE_ENV!=='production')console.warn('No admin seeded. Set ADMIN_PHONE and a strong ADMIN_PASSWORD in backend/.env');
}
