import {NextRequest,NextResponse} from 'next/server';
const backend=process.env.BACKEND_INTERNAL_URL||'http://localhost:4000';
async function gateway(req:NextRequest,{params}:{params:Promise<{path:string[]}>}){
 const token=req.cookies.get('hunar_admin_session')?.value;
 if(!token)return NextResponse.json({message:'Not authenticated'},{status:401});
 const method=req.method;
 if(!['GET','HEAD'].includes(method)){
  const origin=req.headers.get('origin');if(origin && new URL(origin).host!==req.headers.get('host'))return NextResponse.json({message:'Origin mismatch'},{status:403});
 }
 const parts=(await params).path;if(parts.some(p=>p==='..'))return NextResponse.json({message:'Bad path'},{status:400});
 const url=new URL(`${backend}/api/admin/${parts.map(encodeURIComponent).join('/')}`);req.nextUrl.searchParams.forEach((v,k)=>url.searchParams.append(k,v));
 const headers:Record<string,string>={Authorization:`Bearer ${token}`};const type=req.headers.get('content-type');if(type)headers['Content-Type']=type;
 try{const remote=await fetch(url,{method,headers,body:['GET','HEAD'].includes(method)?undefined:await req.arrayBuffer(),cache:'no-store',redirect:'manual'});
  if(!remote.ok&&remote.status===401)return NextResponse.json({message:'Session expired. Log in again.'},{status:401});
  const buf=await remote.arrayBuffer();const response=new NextResponse(buf,{status:remote.status,headers:{'Content-Type':remote.headers.get('content-type')||'application/json','Cache-Control':'no-store'}});return response;
 }catch{return NextResponse.json({message:'Cannot reach API server'},{status:502});}
}
export const GET=gateway;export const POST=gateway;export const PUT=gateway;export const PATCH=gateway;export const DELETE=gateway;
