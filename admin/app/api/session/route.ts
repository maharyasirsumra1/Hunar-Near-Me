import {NextRequest,NextResponse} from 'next/server';
const backend=process.env.BACKEND_INTERNAL_URL||'http://localhost:4000';
export async function POST(req:NextRequest){
 try{const data=await req.json();const response=await fetch(`${backend}/api/auth/login`,{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({phone:data.phone,password:data.password}),cache:'no-store'});const payload=await response.json();
  if(!response.ok)return NextResponse.json({message:payload.message||'Login failed'},{status:response.status});
  if(payload.user?.role!=='ADMIN')return NextResponse.json({message:'Admin access only'},{status:403});
  const out=NextResponse.json({user:payload.user});out.cookies.set('hunar_admin_session',payload.accessToken,{httpOnly:true,secure:process.env.NODE_ENV==='production',sameSite:'strict',path:'/',maxAge:8*3600});return out;
 }catch{return NextResponse.json({message:'Backend unavailable'},{status:502});}
}
export async function DELETE(){const out=NextResponse.json({ok:true});out.cookies.delete('hunar_admin_session');return out;}
