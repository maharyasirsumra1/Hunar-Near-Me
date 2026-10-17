const fs=require('fs'),path=require('path'),assert=require('assert');
const root=path.resolve(__dirname,'../src');
for(const f of ['main.ts','entities.ts','auth.ts','admin.ts','market.ts','module.ts','seed.ts'])assert(fs.existsSync(path.join(root,f)),f+' missing');
const market=fs.readFileSync(path.join(root,'market.ts'),'utf8');
for(const route of ["'workers'","'services'","'locations'","'fee'","'reviews'","':id/messages'"])assert(market.includes(route),route+' missing');
const admin=fs.readFileSync(path.join(root,'admin.ts'),'utf8');
for(const route of ['WORKER_','PAYMENT_','config','services','locations'])assert(admin.includes(route));
console.log('PASS: backend core route and structure contracts. Runtime integration needs PostgreSQL + npm dependencies.');
