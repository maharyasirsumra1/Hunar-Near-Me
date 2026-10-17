import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'api.dart';
import 'main.dart';

Widget appLogo({bool compact=false})=>Builder(builder:(context){
 final a=AppScope.of(context);final logo=a.image('logo');
 return Column(mainAxisSize:MainAxisSize.min,children:[
  if(logo.isNotEmpty)Image.network(logo,width:compact?30:42,height:compact?30:42,errorBuilder:(_,__,___)=>const Icon(Icons.handyman_outlined,color:forest))
  else Icon(Icons.handyman_outlined,color:forest,size:compact?27:38),
  const SizedBox(height:4),AppText(a.config['appName']?.toString()??'Hunar Near Me',style:TextStyle(fontWeight:FontWeight.w800,fontSize:compact?20:25,color:ink))
 ]);
});
Widget actionButton(String title,VoidCallback onTap,{IconData? icon,bool outline=false})=>Padding(padding:const EdgeInsets.only(bottom:12),child:outline?OutlinedButton.icon(onPressed:onTap,icon:Icon(icon??Icons.arrow_forward),label:AppText(title)):ElevatedButton.icon(onPressed:onTap,icon:Icon(icon??Icons.arrow_forward),label:AppText(title)));
Widget entry(String label,TextEditingController controller,{String? hint,bool password=false,TextInputType? keyboard,int lines=1})=>Builder(builder:(context)=>Padding(
 padding:const EdgeInsets.only(bottom:14),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
  AppText(label,style:const TextStyle(fontSize:13,fontWeight:FontWeight.w700,color:ink)),
  const SizedBox(height:7),
  TextField(controller:controller,obscureText:password,maxLines:lines,keyboardType:keyboard,
    decoration:InputDecoration(hintText:hint==null?null:AppScope.of(context).label(hint,hint),hintStyle:const TextStyle(color:Color(0xFF97A9A0),fontSize:14)))
 ])));

Widget sectionTitle(String title,String? sub)=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[AppText(title,style:const TextStyle(fontSize:26,fontWeight:FontWeight.w800,color:forest)),if(sub!=null)...[const SizedBox(height:7),AppText(sub,style:const TextStyle(color:muted,fontSize:15))]]);
Widget pill(String text,{IconData icon=Icons.verified_outlined})=>Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:6),decoration:BoxDecoration(color:const Color(0xFFE4F5EB),borderRadius:BorderRadius.circular(20)),child:Row(mainAxisSize:MainAxisSize.min,children:[Icon(icon,color:forest,size:15),const SizedBox(width:5),AppText(text,style:const TextStyle(fontSize:11,fontWeight:FontWeight.w600,color:forest))]));

class WelcomeScreen extends StatelessWidget {const WelcomeScreen({super.key});
 @override Widget build(BuildContext context){final a=AppScope.of(context);return Scaffold(body:SafeArea(child:Padding(padding:const EdgeInsets.fromLTRB(20,16,20,20),child:Column(children:[
  Expanded(child:Align(alignment:Alignment.topCenter,child:SingleChildScrollView(child:Column(children:[const SizedBox(height:20),Container(width:double.infinity,padding:const EdgeInsets.fromLTRB(14,26,14,24),decoration:BoxDecoration(color:forest,borderRadius:BorderRadius.circular(17)),child:Column(children:[const Icon(Icons.handyman_outlined,color:Colors.white,size:40),const SizedBox(height:12),AppText(a.config['appName']?.toString()??'Hunar Near Me',textAlign:TextAlign.center,style:const TextStyle(color:Colors.white,fontWeight:FontWeight.w800,fontSize:27)),const SizedBox(height:10),AppText(a.config['appNameUrdu']?.toString()??'ہنر آپ کے قریب',style:const TextStyle(color:Colors.white,fontSize:22,fontWeight:FontWeight.bold)),const SizedBox(height:13),AppText(a.label('welcomeTitle','Find trusted skilled professionals near you'),textAlign:TextAlign.center,style:const TextStyle(color:Colors.white,fontSize:13))])),const SizedBox(height:20),Wrap(alignment:WrapAlignment.center,spacing:18,runSpacing:9,children:[pill('Local Experts',icon:Icons.location_on_outlined),pill('Trusted Reviews',icon:Icons.verified_outlined)]),const SizedBox(height:42),if(a.image('welcomeHero').isNotEmpty)ClipRRect(borderRadius:BorderRadius.circular(18),child:Image.network(a.image('welcomeHero'),width:double.infinity,height:165,fit:BoxFit.contain,errorBuilder:(_,__,___)=>Icon(Icons.groups_rounded,color:forest.withOpacity(.22),size:110)))else Icon(Icons.groups_rounded,color:forest.withOpacity(.22),size:110),const SizedBox(height:8),AppText('ہنر مند افراد، آپ کے قریب',style:TextStyle(color:forest.withOpacity(.8),fontSize:17,fontWeight:FontWeight.bold))])))),
  Column(children:[const AppText("Let's Get Started",style:TextStyle(fontSize:22,fontWeight:FontWeight.w800,color:ink)),const SizedBox(height:5),labelText('Choose how you want to join'),const SizedBox(height:23),actionButton(a.label('customerSignup','Register as Customer'),()=>go(context,const RegisterScreen(worker:false)),icon:Icons.person_outline),actionButton(a.label('workerSignup','Register as Worker'),()=>go(context,const RegisterScreen(worker:true)),icon:Icons.engineering_outlined,outline:true),TextButton(onPressed:()=>go(context,const LoginScreen()),child:AppText('Already have an account?  ${a.label('login','Login')}',style:const TextStyle(color:forest,fontSize:13))),TextButton(onPressed:()=>a.setLocale(a.lang=='en'?'ur':'en'),child:AppText(a.lang=='en'?'English  |  اردو':'اردو  |  English',style:const TextStyle(fontSize:12))),labelText('By continuing, you agree to Terms & Privacy Policy',size:10)])
 ]))));}
}

class RegisterScreen extends StatefulWidget {final bool worker;const RegisterScreen({super.key,required this.worker});@override State<RegisterScreen> createState()=>_RegisterScreenState();}
class _RegisterScreenState extends State<RegisterScreen>{final name=TextEditingController(),phone=TextEditingController(),pass=TextEditingController();bool loading=false;
 @override void dispose(){name.dispose();phone.dispose();pass.dispose();super.dispose();}
 Future<void> submit()async{if(name.text.trim().length<2||pass.text.length<10){showError(context,'Enter your full name and a password with at least 10 characters.');return;}setState(()=>loading=true);try{await Api.post('auth/register',{'name':name.text.trim(),'phone':phone.text.trim(),'password':pass.text,'role':widget.worker?'WORKER':'CUSTOMER'});if(mounted)go(context,OtpScreen(phone:phone.text.trim(),worker:widget.worker));}catch(e){showError(context,e)}finally{if(mounted)setState(()=>loading=false);}}
 @override Widget build(BuildContext context){return Scaffold(appBar:AppBar(title:appLogo(compact:true),actions:[TextButton(onPressed:()=>AppScope.of(context).setLocale(AppScope.of(context).lang=='en'?'ur':'en'),child:const AppText('English⌄'))]),body:SafeArea(child:SingleChildScrollView(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const SizedBox(height:12),Row(children:[Expanded(flex:3,child:sectionTitle(widget.worker?'Register as Worker':'Register as Customer',widget.worker?'Showcase your skills and get more work':'Find trusted skilled professionals near you')),Container(width:100,height:115,decoration:BoxDecoration(shape:BoxShape.circle,color:const Color(0xFFDFF5EA)),child:(AppScope.of(context).image(widget.worker?'workerSignupHero':'customerSignupHero').isNotEmpty?ClipOval(child:Image.network(AppScope.of(context).image(widget.worker?'workerSignupHero':'customerSignupHero'),width:100,height:115,fit:BoxFit.cover,errorBuilder:(_,__,___)=>Icon(widget.worker?Icons.engineering:Icons.person_pin_circle,color:forest,size:65))):Icon(widget.worker?Icons.engineering:Icons.person_pin_circle,color:forest,size:65)))]),const SizedBox(height:22),stepProgress(widget.worker?['Basic Info','Skills','Location','Documents','Done']:['Basic Info','Location','Done'],0),const SizedBox(height:27),Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(18)),child:Column(children:[entry('Full Name',name,hint:'Enter your full name'),entry('Mobile Number (+92)',phone,hint:'03XXXXXXXXX',keyboard:TextInputType.phone),entry('Password',pass,hint:'Create a strong password (10+ characters)',password:true),if(widget.worker)const Align(alignment:Alignment.centerLeft,child:AppText('Your profession and service areas will be selected next.',style:TextStyle(fontSize:12,color:muted)))])),const SizedBox(height:25),actionButton(loading?'Please wait…':'Continue →',loading?(){}:submit),const SizedBox(height:16),Center(child:labelText('Your mobile number will be verified by OTP.')),const SizedBox(height:20),Center(child:labelText('Terms & Privacy Policy',size:11))]))));}
}
Widget stepProgress(List<String> labels,int current)=>Row(children:List.generate(labels.length,(i)=>Expanded(child:Column(children:[CircleAvatar(radius:14,backgroundColor:i<=current?forest:const Color(0xFFE1E9E5),child:AppText('${i+1}',style:TextStyle(fontSize:12,color:i<=current?Colors.white:ink,fontWeight:FontWeight.bold))),const SizedBox(height:7),AppText(labels[i],textAlign:TextAlign.center,style:TextStyle(fontSize:10,color:i==current?forest:muted,fontWeight:i==current?FontWeight.bold:FontWeight.normal))]))));

class OtpScreen extends StatefulWidget {final String phone;final bool worker;const OtpScreen({super.key,required this.phone,required this.worker});@override State<OtpScreen> createState()=>_OtpScreenState();}
class _OtpScreenState extends State<OtpScreen>{final otp=TextEditingController();bool loading=false;
 Future<void> verify()async{setState(()=>loading=true);try{final data=await Api.post('auth/verify-otp',{'phone':widget.phone,'code':otp.text.trim()});await Api.saveSession(data);if(!mounted)return;AppScope.of(context).changed();go(context,widget.worker?const ServicePicker(workerOnboarding:true):const LocationSelection(onDoneCustomer:true),replace:true);}catch(e){showError(context,e)}finally{if(mounted)setState(()=>loading=false);}}
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:appLogo(compact:true)),body:Padding(padding:const EdgeInsets.all(24),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const SizedBox(height:45),sectionTitle('Verify Mobile Number','Enter the 6-digit SMS verification code sent to ${widget.phone}.'),const SizedBox(height:30),entry('OTP Code',otp,hint:'● ● ● ● ● ●',keyboard:TextInputType.number),const SizedBox(height:15),actionButton(loading?'Verifying…':'Verify & Continue',loading?(){}:verify),TextButton(onPressed:()async{try{await Api.post('auth/resend-otp',{'phone':widget.phone});if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:AppText('Code requested. Please check your SMS.')));}catch(e){showError(context,e)}},child:const AppText('Resend code'))])));
}

class LoginScreen extends StatefulWidget {const LoginScreen({super.key});@override State<LoginScreen> createState()=>_LoginScreenState();}
class _LoginScreenState extends State<LoginScreen>{final phone=TextEditingController(),password=TextEditingController();bool loading=false;
 Future<void> login()async{setState(()=>loading=true);try{final data=await Api.post('auth/login',{'phone':phone.text.trim(),'password':password.text});await Api.saveSession(data);if(mounted){AppScope.of(context).changed();go(context,Api.user?['role']=='WORKER'?const WorkerHome():const CustomerHome(),replace:true);}}catch(e){showError(context,e)}finally{if(mounted)setState(()=>loading=false);}}
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:appLogo(compact:true)),body:SingleChildScrollView(padding:const EdgeInsets.all(24),child:Column(children:[const SizedBox(height:50),const CircleAvatar(radius:45,backgroundColor:Color(0xFFD9F4E5),child:Icon(Icons.lock_outline,color:forest,size:44)),const SizedBox(height:22),sectionTitle('Welcome Back','Log in as Customer or Worker with the same app.'),const SizedBox(height:30),entry('Mobile Number',phone,hint:'03XXXXXXXXX',keyboard:TextInputType.phone),entry('Password',password,password:true),const SizedBox(height:16),actionButton(loading?'Signing in…':'Login',loading?(){}:login,icon:Icons.login),TextButton(onPressed:()=>go(context,const WelcomeScreen(),replace:true),child:const AppText('Create a new account'))])));
}

const serviceIcons=<String,IconData>{'electrician':Icons.lightbulb,'plumber':Icons.plumbing,'ac-repair':Icons.ac_unit,'mechanic':Icons.build,'painter':Icons.format_paint,'carpenter':Icons.handyman,'cleaning':Icons.cleaning_services,'tutor':Icons.school,'tailor':Icons.content_cut,'cook':Icons.restaurant,'gardener':Icons.eco,'more':Icons.more_horiz};
IconData serviceIcon(Map s)=>serviceIcons[s['slug']?.toString()]??Icons.home_repair_service;
class ServicePicker extends StatefulWidget {final bool workerOnboarding;final bool pickMultiple;const ServicePicker({super.key,this.workerOnboarding=false,this.pickMultiple=false});@override State<ServicePicker> createState()=>_ServicePickerState();}
class _ServicePickerState extends State<ServicePicker>{final selected=<String>{};bool busy=false;
 Future<void> done()async{if(selected.isEmpty){showError(context,'Please select at least one service.');return;}if(widget.workerOnboarding){setState(()=>busy=true);try{await Api.put('worker/profile',{'serviceIds':selected.toList()});if(mounted)go(context,const LocationSelection(workerOnboarding:true),replace:true);}catch(e){showError(context,e)}finally{if(mounted)setState(()=>busy=false);}}else{Navigator.of(context).pop(selected.first);}}
 @override Widget build(BuildContext context){final services=AppScope.of(context).services;return Scaffold(appBar:AppBar(title:appLogo(compact:true)),body:SafeArea(child:Padding(padding:const EdgeInsets.all(18),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[sectionTitle('Choose Service Type',widget.workerOnboarding?'Select all the skills you offer':'Select the service you need'),const SizedBox(height:18),Expanded(child:services.isEmpty?const Center(child:AppText('Cannot load services. Start API and try again.')):GridView.builder(itemCount:services.length,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:3,crossAxisSpacing:10,mainAxisSpacing:10,childAspectRatio:.95),itemBuilder:(context,i){final s=Map<String,dynamic>.from(services[i]);final active=selected.contains(s['id']);return InkWell(onTap:(){if(s['slug']=='more'){showError(context,'More service types are managed from Admin > Services.');return;}setState((){if(!widget.workerOnboarding&&!widget.pickMultiple)selected.clear();active?selected.remove(s['id']):selected.add(s['id']);});},child:Container(decoration:BoxDecoration(color:active?const Color(0xFFDDF6E8):Colors.white,borderRadius:BorderRadius.circular(18),border:Border.all(color:active?forest:const Color(0xFFE7EEE9),width:active?2:1)),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[CircleAvatar(radius:24,backgroundColor:const Color(0xFFEBF6EF),child:(s['imageUrl']?.toString().isNotEmpty==true?ClipOval(child:Image.network(Api.absoluteImage(s['imageUrl'].toString()),fit:BoxFit.cover,width:46,height:46,errorBuilder:(_,__,___)=>Icon(serviceIcon(s),color:forest,size:27))):Icon(serviceIcon(s),color:forest,size:27))),const SizedBox(height:9),AppText(s['name'].toString(),style:const TextStyle(fontWeight:FontWeight.w600,fontSize:12),textAlign:TextAlign.center),if(active)const Icon(Icons.check_circle,color:forest,size:16)])));})),const SizedBox(height:15),actionButton(busy?'Saving…':'Continue →',busy?(){}:done),if(!widget.workerOnboarding)Center(child:TextButton(onPressed:()=>Navigator.pop(context),child:const AppText('Skip for now')))]))));}
}

Future<Position> gpsPosition() async {
 final available=await Geolocator.isLocationServiceEnabled();if(!available)throw ApiException('Please turn on phone location services.');
 var p=await Geolocator.checkPermission();if(p==LocationPermission.denied)p=await Geolocator.requestPermission();
 if(p==LocationPermission.denied||p==LocationPermission.deniedForever)throw ApiException('Location permission denied. You can select your city and area manually.');
 return Geolocator.getCurrentPosition(desiredAccuracy:LocationAccuracy.high,timeLimit:const Duration(seconds:15));
}

class LocationSelection extends StatefulWidget {final bool workerOnboarding,onDoneCustomer;const LocationSelection({super.key,this.workerOnboarding=false,this.onDoneCustomer=false});@override State<LocationSelection> createState()=>_LocationSelectionState();}
class _LocationSelectionState extends State<LocationSelection>{String? province,city,area;double? lat,lng;bool busy=false;double radius=15;bool initialized=false;
 @override void didChangeDependencies(){super.didChangeDependencies();if(!initialized){final a=AppScope.of(context);city=a.selectedCity;area=a.selectedArea;lat=a.userLat;lng=a.userLng;final matching=a.locations.where((x)=>x['id']==city).toList();if(matching.isNotEmpty)province=matching.first['parentId']?.toString();initialized=true;}}
 Future<void> gps()async{setState(()=>busy=true);try{final p=await gpsPosition();setState((){lat=p.latitude;lng=p.longitude;});if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:AppText('GPS coordinates detected. Select your city and area too.')));}catch(e){showError(context,e)}finally{if(mounted)setState(()=>busy=false);}}
 Future<void> done()async{final a=AppScope.of(context);if(city==null){showError(context,'Please choose your city.');return;}if(widget.workerOnboarding){if(lat==null||lng==null){showError(context,'Worker must set accurate GPS location so nearby customers can find you.');return;}setState(()=>busy=true);try{await Api.put('worker/profile',{'cityId':city,'areaId':area,'latitude':lat,'longitude':lng,'serviceRadiusKm':radius});if(mounted)go(context,const WorkerRegistrationFee(),replace:true);}catch(e){showError(context,e)}finally{if(mounted)setState(()=>busy=false);}}else{a.updateLocation(city,area,lat:lat,lng:lng);go(context,const CustomerHome(),replace:true);}}
 @override Widget build(BuildContext context){final a=AppScope.of(context);final provinces=a.locations.where((x)=>x['kind']=='province'&&x['active']==true).toList();final cities=a.locations.where((x)=>x['kind']=='city'&&x['active']==true&&(province==null||x['parentId']==province)).toList();final areas=a.locations.where((x)=>x['kind']=='area'&&x['parentId']==city&&x['active']==true).toList();return Scaffold(appBar:AppBar(title:appLogo(compact:true)),body:Padding(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[sectionTitle('Your Location',widget.workerOnboarding?'Set your city, area and work coverage':'Find professionals near your home or office'),const SizedBox(height:22),DropdownButtonFormField<String>(isExpanded:true,value:provinces.any((x)=>x['id']==province)?province:null,decoration:const InputDecoration(labelText:'Province / Region'),items:provinces.map((x)=>DropdownMenuItem<String>(value:x['id'].toString(),child:AppText(x['name'].toString()))).toList(),onChanged:(v)=>setState((){province=v;city=null;area=null;})),const SizedBox(height:16),DropdownButtonFormField<String>(isExpanded:true,value:cities.any((x)=>x['id']==city)?city:null,decoration:const InputDecoration(labelText:'Select City'),items:cities.map((x)=>DropdownMenuItem<String>(value:x['id'].toString(),child:AppText(x['name'].toString()))).toList(),onChanged:(v)=>setState((){city=v;area=null;})),const SizedBox(height:16),DropdownButtonFormField<String>(isExpanded:true,value:areas.any((x)=>x['id']==area)?area:null,decoration:const InputDecoration(labelText:'Select Area / Housing Society'),items:areas.map((x)=>DropdownMenuItem<String>(value:x['id'].toString(),child:AppText(x['name'].toString()))).toList(),onChanged:(v)=>setState(()=>area=v)),const SizedBox(height:18),OutlinedButton.icon(onPressed:busy?null:gps,icon:const Icon(Icons.my_location),label:AppText(lat==null?'Use My GPS Location':'GPS set: ${lat!.toStringAsFixed(4)}, ${lng!.toStringAsFixed(4)}')),if(widget.workerOnboarding)...[const SizedBox(height:25),AppText('Service Radius: ${radius.toInt()} km',style:const TextStyle(fontWeight:FontWeight.w600)),Slider(value:radius,min:1,max:50,divisions:49,onChanged:(v)=>setState(()=>radius=v)),labelText('Show your profile to customers within this distance.')],const Spacer(),actionButton('Continue →',busy?(){}:done)])));}
}

class WorkerRegistrationFee extends StatefulWidget {const WorkerRegistrationFee({super.key});@override State<WorkerRegistrationFee> createState()=>_WorkerRegistrationFeeState();}
class _WorkerRegistrationFeeState extends State<WorkerRegistrationFee>{String method='EASYPAISA';final tx=TextEditingController();String? receipt;bool busy=false;Map<String,dynamic>? details;
 @override void initState(){super.initState();load();}
 Future<void> load()async{try{final d=await Api.get('worker/me');if(mounted)setState(()=>details=Map<String,dynamic>.from(d));}catch(e){showError(context,e)}}
 Future<void> pickReceipt()async{try{final image=await ImagePicker().pickImage(source:ImageSource.gallery,imageQuality:80,maxWidth:1500);if(image!=null)setState(()=>receipt=image.path);}catch(e){showError(context,e)}}
 Future<void> submit()async{final a=AppScope.of(context);final fee=Number.tryParse('${a.config['workerFeePkr']??500}')??500;if(fee==0){go(context,const WorkerHome(),replace:true);return;}if(tx.text.trim().length<3){showError(context,'Enter your EasyPaisa/JazzCash transaction ID to request verification.');return;}setState(()=>busy=true);try{final r=await Api.post('worker/fee',{'method':method,'transactionReference':tx.text.trim()});if(receipt!=null)await Api.upload('worker/fee/${r['id']}/screenshot',receipt!);if(mounted)go(context,const WorkerHome(),replace:true);}catch(e){showError(context,e)}finally{if(mounted)setState(()=>busy=false);}}
 @override Widget build(BuildContext context){final a=AppScope.of(context);final fee=a.config['workerFeePkr']??500;final payments=(details?['payments'] as List?)??[];return Scaffold(appBar:AppBar(title:appLogo(compact:true)),body:SingleChildScrollView(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[sectionTitle('Worker Registration Fee','Submit payment details for admin review and approval.'),const SizedBox(height:20),Container(padding:const EdgeInsets.all(20),decoration:BoxDecoration(color:forest,borderRadius:BorderRadius.circular(18)),child:Row(children:[const Icon(Icons.payments_outlined,color:Colors.white,size:35),const SizedBox(width:15),Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const AppText('Registration fee',style:TextStyle(color:Colors.white70)),AppText('Rs. $fee',style:const TextStyle(fontSize:30,fontWeight:FontWeight.w800,color:Colors.white))])])),const SizedBox(height:18),const AppText('Choose Payment Method',style:TextStyle(fontWeight:FontWeight.bold)),const SizedBox(height:10),RadioListTile<String>(title:const AppText('EasyPaisa'),subtitle:AppText(a.config['easypaisaNumber']?.toString().isNotEmpty==true?a.config['easypaisaNumber']:'Admin has not set an account number'),value:'EASYPAISA',groupValue:method,onChanged:(v)=>setState(()=>method=v!)),RadioListTile<String>(title:const AppText('JazzCash'),subtitle:AppText(a.config['jazzcashNumber']?.toString().isNotEmpty==true?a.config['jazzcashNumber']:'Admin has not set an account number'),value:'JAZZCASH',groupValue:method,onChanged:(v)=>setState(()=>method=v!)),const SizedBox(height:14),entry('Transaction ID / Reference',tx,hint:'Enter reference from payment SMS'),OutlinedButton.icon(onPressed:pickReceipt,icon:const Icon(Icons.add_photo_alternate_outlined),label:AppText(receipt==null?'Attach Screenshot (Optional)':'Screenshot Selected ✓')),const SizedBox(height:12),labelText('Payment is checked manually by an administrator. Submitting a reference does not mean the payment has been approved.'),const SizedBox(height:18),if(payments.isNotEmpty)Container(padding:const EdgeInsets.all(12),decoration:BoxDecoration(borderRadius:BorderRadius.circular(10),color:const Color(0xFFE9F4ED)),child:AppText('Latest submission: ${payments.first['status']}. You can view your approval status in the Worker Dashboard.')),const SizedBox(height:22),actionButton(busy?'Submitting…':fee==0?'Finish Registration':'Submit for Verification',busy?(){}:submit),TextButton(onPressed:()=>go(context,const WorkerHome(),replace:true),child:const AppText('Go to Worker Dashboard (Pending Approval)'))])));
 }
}

class CustomerHome extends StatefulWidget {const CustomerHome({super.key});@override State<CustomerHome> createState()=>_CustomerHomeState();}
class _CustomerHomeState extends State<CustomerHome>{String? serviceId;double radius=15;String sort='best';List<dynamic> workers=[];bool loading=false;String query='';final search=TextEditingController();final speech=SpeechToText();bool listening=false;
 @override void initState(){super.initState();WidgetsBinding.instance.addPostFrameCallback((_){refresh();});}
 Future<void> refresh()async{final a=AppScope.of(context);setState(()=>loading=true);try{final q=<String,String>{'sort':sort,'radiusKm':'${radius.toInt()}'};if(serviceId!=null)q['serviceId']=serviceId!;if(a.selectedCity!=null)q['cityId']=a.selectedCity!;if(a.selectedArea!=null)q['areaId']=a.selectedArea!;if(a.userLat!=null&&a.userLng!=null){q['lat']='${a.userLat}';q['lng']='${a.userLng}';}final results=await Api.get('public/workers',query:q);if(mounted)setState(()=>workers=List<dynamic>.from(results));}catch(e){showError(context,e)}finally{if(mounted)setState(()=>loading=false);}}
 Future<void> gps()async{try{final p=await gpsPosition();if(!mounted)return;final a=AppScope.of(context);a.updateLocation(a.selectedCity,a.selectedArea,lat:p.latitude,lng:p.longitude);await refresh();}catch(e){showError(context,e)}}
 Future<void> voice()async{try{if(listening){await speech.stop();setState(()=>listening=false);return;}final ready=await speech.initialize();if(!ready)throw ApiException('Voice recognition is not available on this phone.');setState(()=>listening=true);await speech.listen(localeId:AppScope.of(context).lang=='ur'?'ur_PK':'en_PK',onResult:(result){search.text=result.recognizedWords;setState(()=>query=result.recognizedWords);if(result.finalResult){setState(()=>listening=false);matchVoice(result.recognizedWords);}});}catch(e){showError(context,e)}}
 void matchVoice(String recognized){final a=AppScope.of(context);final q=recognized.toLowerCase();final found=a.services.where((s)=>q.contains(s['name'].toString().toLowerCase())||(s['nameUrdu']?.toString().isNotEmpty==true&&q.contains(s['nameUrdu'].toString()))).toList();if(found.isNotEmpty){setState(()=>serviceId=found.first['id']);refresh();}else{showError(context,'Voice recognized. Select a service or type its category. AI problem-to-skill matching needs a connected AI provider.');}}
 @override Widget build(BuildContext context){final a=AppScope.of(context);return Scaffold(appBar:AppBar(automaticallyImplyLeading:false,title:appLogo(compact:true),actions:[IconButton(tooltip:'Notifications',onPressed:()=>go(context,const NotificationsScreen()),icon:const Icon(Icons.notifications_none)),PopupMenuButton<String>(onSelected:(v)async{if(v=='logout'){await Api.logout();if(context.mounted)go(context,const WelcomeScreen(),replace:true);}else if(v=='jobs'){go(context,const BookingListScreen());}},itemBuilder:(_)=>[const PopupMenuItem(value:'jobs',child:AppText('My Bookings')),const PopupMenuItem(value:'logout',child:AppText('Logout'))])]),body:RefreshIndicator(onRefresh:refresh,child:ListView(padding:const EdgeInsets.all(16),children:[AppText('Welcome, ${a.name}',style:const TextStyle(fontSize:21,fontWeight:FontWeight.w800,color:ink)),const SizedBox(height:4),labelText('Find a skilled professional near you'),const SizedBox(height:18),InkWell(onTap:()=>go(context,const LocationSelection()),child:Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:const Color(0xFFE1F3E9),borderRadius:BorderRadius.circular(14)),child:Row(children:[const Icon(Icons.location_on_outlined,color:forest),const SizedBox(width:10),Expanded(child:AppText('${a.locName(a.selectedArea).isNotEmpty?a.locName(a.selectedArea)+', ':''}${a.locName(a.selectedCity).isEmpty?'Set your city and area':a.locName(a.selectedCity)}',style:const TextStyle(fontWeight:FontWeight.w700,color:ink))),const Icon(Icons.edit_location_alt_outlined,color:forest)]))),const SizedBox(height:14),Row(children:[Expanded(child:TextField(controller:search,onChanged:(v)=>setState(()=>query=v),decoration:const InputDecoration(prefixIcon:Icon(Icons.search),hintText:'Search services or speak in Urdu'))),const SizedBox(width:7),IconButton.filled(onPressed:voice,icon:Icon(listening?Icons.mic:Icons.mic_none))]),const SizedBox(height:22),const AppText('Service Categories',style:TextStyle(fontSize:18,fontWeight:FontWeight.w800,color:ink)),const SizedBox(height:12),SizedBox(height:194,child:GridView.builder(scrollDirection:Axis.horizontal,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,mainAxisSpacing:8,crossAxisSpacing:8,childAspectRatio:1.02),itemCount:a.services.length,itemBuilder:(c,i){final s=a.services[i];final chosen=serviceId==s['id'];return InkWell(onTap:(){if(s['slug']=='more'){go(context,const ServicePicker());return;}setState(()=>serviceId=chosen?null:s['id'].toString());refresh();},child:Container(decoration:BoxDecoration(borderRadius:BorderRadius.circular(14),color:chosen?const Color(0xFFDAF3E4):Colors.white,border:Border.all(color:chosen?forest:const Color(0xFFE3EEE8))),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[if(s['imageUrl']?.toString().isNotEmpty==true)Image.network(Api.absoluteImage(s['imageUrl'].toString()),width:32,height:32,errorBuilder:(_,__,___)=>Icon(serviceIcon(Map<String,dynamic>.from(s)),color:forest,size:30))else Icon(serviceIcon(Map<String,dynamic>.from(s)),color:forest,size:30),const SizedBox(height:7),AppText(s['name'].toString(),style:const TextStyle(fontSize:12,fontWeight:FontWeight.w700))])));})),const SizedBox(height:18),const AppText('Find Workers',style:TextStyle(fontSize:18,fontWeight:FontWeight.w800,color:ink)),const SizedBox(height:12),DropdownButtonFormField<String>(value:sort,decoration:const InputDecoration(labelText:'Sort workers by'),items:const [DropdownMenuItem(value:'best',child:AppText('Best Reviewed (Recommended)')),DropdownMenuItem(value:'rating',child:AppText('Highest Star Rating')),DropdownMenuItem(value:'reviews',child:AppText('Most Reviews')),DropdownMenuItem(value:'nearest',child:AppText('Nearest Distance'))],onChanged:(v){if(v!=null){setState(()=>sort=v);refresh();}}),const SizedBox(height:11),AppText('Search Radius: ${radius.toInt()} km',style:const TextStyle(fontWeight:FontWeight.w600)),Slider(value:radius,min:1,max:50,divisions:49,onChanged:(v)=>setState(()=>radius=v),onChangeEnd:(_)=>refresh()),Row(children:[TextButton.icon(onPressed:gps,icon:const Icon(Icons.my_location),label:const AppText('Update My GPS')),const Spacer(),TextButton(onPressed:refresh,child:const AppText('Refresh'))]),if(loading)const Center(child:Padding(padding:EdgeInsets.all(14),child:CircularProgressIndicator())),if(!loading&&workers.isEmpty)Container(padding:const EdgeInsets.all(19),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14)),child:AppText('No approved workers found with these filters yet. Try a larger radius or another area.',style:TextStyle(color:Colors.grey.shade700))),...workers.where((w)=>query.trim().isEmpty||w['name'].toString().toLowerCase().contains(query.toLowerCase())||serviceId!=null).map((w)=>WorkerTile(worker:w,onTap:()=>go(context,WorkerDetails(id:w['id'].toString()))))])));
 }
}

class WorkerTile extends StatelessWidget {
  final dynamic worker;
  final VoidCallback onTap;
  const WorkerTile({super.key,required this.worker,required this.onTap});
  @override Widget build(BuildContext context) {
    final a=AppScope.of(context);
    final w=worker;
    final image=Api.absoluteImage(w['photoUrl']?.toString());
    final distance=w['distanceKm']==null?'Distance unavailable':'${w['distanceKm']} km away';
    final address='${a.locName(w['areaId']?.toString())} ${a.locName(w['cityId']?.toString())}';
    return Card(
      color:Colors.white,elevation:0,margin:const EdgeInsets.only(bottom:12),
      shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(14),side:const BorderSide(color:Color(0xFFE6EEE9))),
      child:InkWell(
        onTap:onTap,borderRadius:BorderRadius.circular(14),
        child:Padding(
          padding:const EdgeInsets.all(12),
          child:Row(children:[
            CircleAvatar(radius:36,backgroundColor:const Color(0xFFE2F4E8),backgroundImage:image.isNotEmpty?NetworkImage(image):null,child:image.isEmpty?const Icon(Icons.engineering,color:forest,size:36):null),
            const SizedBox(width:12),
            Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Row(children:[Expanded(child:AppText(w['name'].toString(),style:const TextStyle(fontWeight:FontWeight.w800,fontSize:16))),if(w['verifiedBadge']==true)const Icon(Icons.verified,color:forest,size:16)]),
              const SizedBox(height:3),AppText(address,style:const TextStyle(color:muted,fontSize:12)),
              const SizedBox(height:5),
              Row(children:[const Icon(Icons.star,color:Colors.amber,size:17),AppText(' ${w['ratingAverage']} (${w['ratingCount']} reviews)',style:const TextStyle(fontWeight:FontWeight.w600,fontSize:12))]),
              const SizedBox(height:5),AppText('☎ ${w['phone']??''}  •  $distance',style:const TextStyle(fontSize:11,color:forest)),
              const SizedBox(height:4),const AppText('View profile & customer reviews →',style:TextStyle(color:forest,fontSize:11))
            ]))
          ])
        )
      )
    );
  }
}

class WorkerDetails extends StatefulWidget {
  final String id;
  const WorkerDetails({super.key,required this.id});
  @override State<WorkerDetails> createState()=>_WorkerDetailsState();
}
class _WorkerDetailsState extends State<WorkerDetails>{
  Map<String,dynamic>? worker;
  bool loading=true;
  @override void initState(){super.initState();load();}
  Future<void> load()async{
    try{final x=await Api.get('public/workers/${widget.id}');if(mounted)setState(()=>worker=Map<String,dynamic>.from(x));}
    catch(e){showError(context,e)}
    finally{if(mounted)setState(()=>loading=false);}
  }
  @override Widget build(BuildContext context){
    final w=worker;
    final a=AppScope.of(context);
    if(loading)return Scaffold(appBar:AppBar(title:appLogo(compact:true)),body:const Center(child:CircularProgressIndicator()));
    if(w==null)return Scaffold(appBar:AppBar(title:appLogo(compact:true)),body:const Center(child:AppText('Profile not available')));
    final avatar=Api.absoluteImage(w['photoUrl']?.toString());
    final photos=(w['photoUrls'] as List?)??[];
    final reviews=(w['reviews'] as List?)??[];
    return Scaffold(
      appBar:AppBar(title:appLogo(compact:true)),
      body:ListView(padding:const EdgeInsets.all(18),children:[
        Card(color:Colors.white,elevation:0,child:Padding(
          padding:const EdgeInsets.all(18),
          child:Column(children:[
            CircleAvatar(radius:48,backgroundColor:const Color(0xFFE2F4E8),backgroundImage:avatar.isEmpty?null:NetworkImage(avatar),child:avatar.isEmpty?const Icon(Icons.engineering,color:forest,size:48):null),
            const SizedBox(height:10),
            AppText(w['name']?.toString()??'',style:const TextStyle(fontSize:22,fontWeight:FontWeight.w800,color:ink)),
            const SizedBox(height:6),
            if(w['verifiedBadge']==true)pill('Verified Worker'),
            const SizedBox(height:8),
            AppText('${a.locName(w['areaId']?.toString())}, ${a.locName(w['cityId']?.toString())}'),
            const SizedBox(height:8),
            AppText('☎ ${w['phone']}',style:const TextStyle(color:forest,fontWeight:FontWeight.w700)),
            const SizedBox(height:8),
            AppText('⭐ ${w['ratingAverage']} / 5  •  ${w['ratingCount']} reviews',style:const TextStyle(fontSize:14,fontWeight:FontWeight.bold)),
            AppText('${w['completedJobs']} completed jobs • ${w['experienceYears']} years experience',style:const TextStyle(color:muted,fontSize:12))
          ])
        )),
        const SizedBox(height:17),sectionTitle('About Worker',null),
        const SizedBox(height:7),
        AppText((w['bio']?.toString().isNotEmpty==true)?w['bio'].toString():'This worker has not added a description yet.'),
        const SizedBox(height:15),
        const AppText('Portfolio',style:TextStyle(fontSize:17,fontWeight:FontWeight.bold)),
        const SizedBox(height:9),
        if(photos.isNotEmpty)
          SizedBox(height:115,child:ListView(scrollDirection:Axis.horizontal,children:[
            for(final url in photos)
              Padding(padding:const EdgeInsets.only(right:9),child:ClipRRect(borderRadius:BorderRadius.circular(10),child:Image.network(Api.absoluteImage(url.toString()),width:125,height:110,fit:BoxFit.cover,errorBuilder:(_,__,___)=>const Icon(Icons.broken_image))))
          ]))
        else labelText('No portfolio images yet.'),
        const SizedBox(height:20),
        const AppText('Customer Reviews',style:TextStyle(fontSize:18,fontWeight:FontWeight.w800,color:ink)),
        const SizedBox(height:8),
        if(reviews.isEmpty)labelText('No verified customer reviews yet.'),
        for(final r in reviews)
          Card(color:Colors.white,elevation:0,child:Padding(padding:const EdgeInsets.all(13),child:Column(
            crossAxisAlignment:CrossAxisAlignment.start,children:[
              AppText('⭐ ${r['stars']}/5  •  ${r['createdAt'].toString().split('T').first}',style:const TextStyle(color:forest,fontWeight:FontWeight.bold)),
              const SizedBox(height:5),
              AppText(r['comment']?.toString()??''),
              if((r['workerReply']??'').toString().isNotEmpty)AppText('Worker reply: ${r['workerReply']}',style:const TextStyle(color:muted,fontStyle:FontStyle.italic))
            ]
          ))),
        const SizedBox(height:16),actionButton('Request This Worker',()=>go(context,BookingCreateScreen(worker:w)),icon:Icons.calendar_month)
      ])
    );
  }
}

class BookingCreateScreen extends StatefulWidget {final Map<String,dynamic> worker;const BookingCreateScreen({super.key,required this.worker});@override State<BookingCreateScreen> createState()=>_BookingCreateScreenState();}
class _BookingCreateScreenState extends State<BookingCreateScreen>{final description=TextEditingController(),budget=TextEditingController(),address=TextEditingController();String? serviceId;bool busy=false;
 @override void initState(){super.initState();serviceId=(widget.worker['serviceIds'] as List?)?.firstOrNull?.toString();}
 Future<void> submit()async{if(serviceId==null){showError(context,'Select a service.');return;}setState(()=>busy=true);try{final a=AppScope.of(context);await Api.post('bookings',{'workerId':widget.worker['userId'],'serviceId':serviceId,'description':description.text.trim(),'proposedPricePkr':int.tryParse(budget.text),'address':address.text,'cityId':a.selectedCity,'areaId':a.selectedArea,'latitude':a.userLat,'longitude':a.userLng});if(mounted){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:AppText('Job request sent to worker')));go(context,const BookingListScreen(),replace:true);}}catch(e){showError(context,e)}finally{if(mounted)setState(()=>busy=false);}}
 @override Widget build(BuildContext context){final a=AppScope.of(context);final available=a.services.where((s)=>(widget.worker['serviceIds'] as List? ?? []).contains(s['id'])).toList();return Scaffold(appBar:AppBar(title:const AppText('Request a Service')),body:SingleChildScrollView(padding:const EdgeInsets.all(18),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[sectionTitle('Book ${widget.worker['name']}','Explain your job and propose an optional budget.'),const SizedBox(height:20),DropdownButtonFormField<String>(value:serviceId,decoration:const InputDecoration(labelText:'Service'),items:available.map((s)=>DropdownMenuItem<String>(value:s['id'],child:AppText(s['name'].toString()))).toList(),onChanged:(v)=>setState(()=>serviceId=v)),const SizedBox(height:18),entry('Job Description',description,hint:'What needs fixing? When are you available?',lines:4),entry('Your Proposed Fee (Rs, optional)',budget,hint:'e.g. 2000',keyboard:TextInputType.number),entry('Visit Address (shared with chosen worker)',address,hint:'House, street and landmark',lines:2),const SizedBox(height:15),actionButton('Send Job Request',busy?(){}:submit)])));
}
}

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});
  @override State<BookingListScreen> createState()=>_BookingListScreenState();
}
class _BookingListScreenState extends State<BookingListScreen>{
  List<dynamic> bookings=[];
  bool loading=true;
  @override void initState(){super.initState();load();}
  Future<void> load()async{
    try{final r=await Api.get('bookings');if(mounted)setState(()=>bookings=List<dynamic>.from(r));}
    catch(e){showError(context,e)}
    finally{if(mounted)setState(()=>loading=false);}
  }
  @override Widget build(BuildContext context)=>Scaffold(
    appBar:AppBar(title:const AppText('My Bookings')),
    body:RefreshIndicator(
      onRefresh:load,
      child:loading?const Center(child:CircularProgressIndicator()):ListView(
        padding:const EdgeInsets.all(14),children:[
          if(bookings.isEmpty)const Padding(padding:EdgeInsets.all(30),child:AppText('No bookings yet. Find a worker and send your first request.')),
          for(final b in bookings)
            Card(color:Colors.white,child:ListTile(
              onTap:()=>go(context,BookingDetailsScreen(booking:Map<String,dynamic>.from(b))),
              title:AppText(b['description'].toString(),maxLines:2,overflow:TextOverflow.ellipsis),
              subtitle:AppText('${b['status']} • Budget Rs. ${b['proposedPricePkr']??'Not set'} • Quote Rs. ${b['quotedPricePkr']??'—'}'),
              trailing:const Icon(Icons.chevron_right,color:forest)
            ))
        ]
      )
    )
  );
}

class BookingDetailsScreen extends StatefulWidget {final Map<String,dynamic> booking;const BookingDetailsScreen({super.key,required this.booking});@override State<BookingDetailsScreen> createState()=>_BookingDetailsScreenState();}
class _BookingDetailsScreenState extends State<BookingDetailsScreen>{late Map<String,dynamic> booking;List<dynamic> messages=[];final msg=TextEditingController(),quote=TextEditingController(),review=TextEditingController();int stars=5;bool busy=false;
 @override void initState(){super.initState();booking=widget.booking;load();}
 Future<void> load()async{try{final list=await Api.get('bookings/${booking['id']}/messages');if(mounted)setState(()=>messages=List<dynamic>.from(list));}catch(e){showError(context,e)}}
 Future<void> update(String state)async{setState(()=>busy=true);try{final b=await Api.patch('bookings/${booking['id']}/status',{'status':state});if(mounted)setState(()=>booking=Map<String,dynamic>.from(b));}catch(e){showError(context,e)}finally{if(mounted)setState(()=>busy=false);}}
 Future<void> sendMessage()async{if(msg.text.trim().isEmpty)return;try{await Api.post('bookings/${booking['id']}/messages',{'body':msg.text.trim()});msg.clear();await load();}catch(e){showError(context,e)}}
 Future<void> sendQuote()async{try{final price=int.parse(quote.text);final b=await Api.patch('bookings/${booking['id']}/quote',{'amountPkr':price});if(mounted)setState(()=>booking=Map<String,dynamic>.from(b));}catch(e){showError(context,e)}}
 Future<void> sendReview()async{try{await Api.post('bookings/reviews',{'bookingId':booking['id'],'stars':stars,'comment':review.text.trim()});if(mounted){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:AppText('Your review has been submitted')));review.clear();}}catch(e){showError(context,e)}}
 @override Widget build(BuildContext context){final isWorker=Api.user?['role']=='WORKER';final status=booking['status'];return Scaffold(appBar:AppBar(title:const AppText('Booking Details')),body:SafeArea(child:ListView(padding:const EdgeInsets.all(16),children:[sectionTitle('Job Details','Booking status: $status'),const SizedBox(height:14),Card(color:Colors.white,child:Padding(padding:const EdgeInsets.all(14),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[AppText(booking['description'].toString()),const Divider(),AppText('Customer budget: Rs. ${booking['proposedPricePkr']??'—'}'),AppText('Worker quote: Rs. ${booking['quotedPricePkr']??'—'}'),if(isWorker)AppText('Visit Address: ${booking['address']??'—'}')]))),const SizedBox(height:14),if(isWorker&&['REQUESTED','QUOTED'].contains(status))... [entry('Your Price Quote (PKR)',quote,hint:'Your proposed price',keyboard:TextInputType.number),actionButton('Send Price Quote',sendQuote)],if(!isWorker&&status=='QUOTED')actionButton('Accept Worker Quote',()=>update('ACCEPTED')),if(isWorker&&status=='ACCEPTED')actionButton('Mark Job Started',()=>update('IN_PROGRESS')),if(isWorker&&status=='IN_PROGRESS')actionButton('Mark Completed',()=>update('COMPLETED')),if(!['COMPLETED','CANCELLED','DISPUTED'].contains(status))TextButton(onPressed:busy?null:()=>update('CANCELLED'),child:const AppText('Cancel Booking')),if(status=='COMPLETED'&&!isWorker)...[const SizedBox(height:16),const AppText('Review this Worker',style:TextStyle(fontWeight:FontWeight.w800,fontSize:17)),Wrap(children:List.generate(5,(i)=>IconButton(onPressed:()=>setState(()=>stars=i+1),icon:Icon(i<stars?Icons.star:Icons.star_outline,color:Colors.amber))),alignment:WrapAlignment.start),entry('Your review (optional)',review,lines:3),actionButton('Submit Review',sendReview)],const SizedBox(height:20),const AppText('Booking Chat',style:TextStyle(fontSize:19,fontWeight:FontWeight.w800,color:ink)),const SizedBox(height:10),...messages.map((m)=>Align(alignment:m['senderId']==Api.user?['id']?Alignment.centerRight:Alignment.centerLeft,child:Container(margin:const EdgeInsets.only(bottom:8),padding:const EdgeInsets.symmetric(horizontal:14,vertical:11),constraints:const BoxConstraints(maxWidth:280),decoration:BoxDecoration(color:m['senderId']==Api.user?['id']?const Color(0xFFD9F2E5):Colors.white,borderRadius:BorderRadius.circular(12)),child:AppText(m['body'].toString())))),Row(children:[Expanded(child:TextField(controller:msg,maxLines:2,minLines:1,decoration:const InputDecoration(hintText:'Write a message…'))),IconButton.filled(onPressed:sendMessage,icon:const Icon(Icons.send))]),const SizedBox(height:20),TextButton(onPressed:load,child:const AppText('Refresh Messages'))])));
 }
}

class WorkerHome extends StatefulWidget {
  const WorkerHome({super.key});
  @override State<WorkerHome> createState()=>_WorkerHomeState();
}
class _WorkerHomeState extends State<WorkerHome>{
  Map<String,dynamic>? data;
  List<dynamic> bookings=[];
  bool loading=true;
  @override void initState(){super.initState();load();}
  Future<void> load()async{
    try{
      final rows=await Future.wait([Api.get('worker/me'),Api.get('bookings')]);
      if(mounted)setState((){data=Map<String,dynamic>.from(rows[0]);bookings=List<dynamic>.from(rows[1]);});
    }catch(e){showError(context,e)}
    finally{if(mounted)setState(()=>loading=false);}
  }
  @override Widget build(BuildContext context){
    final a=AppScope.of(context);
    final p=data?['profile'] as Map?;
    final payments=data?['payments'] as List?;
    return Scaffold(
      appBar:AppBar(automaticallyImplyLeading:false,title:appLogo(compact:true),actions:[
        IconButton(onPressed:()=>go(context,const NotificationsScreen()),icon:const Icon(Icons.notifications_none)),
        IconButton(onPressed:()async{await Api.logout();if(context.mounted)go(context,const WelcomeScreen(),replace:true);},icon:const Icon(Icons.logout))
      ]),
      body:RefreshIndicator(
        onRefresh:load,
        child:loading?const Center(child:CircularProgressIndicator()):ListView(
          padding:const EdgeInsets.all(18),children:[
            sectionTitle('Welcome, ${a.name}','Your Hunar Near Me worker dashboard'),
            const SizedBox(height:18),
            Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:forest,borderRadius:BorderRadius.circular(18)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              const AppText('Application Status',style:TextStyle(color:Colors.white70,fontSize:13)),
              const SizedBox(height:5),
              AppText(p?['status']?.toString()??'PENDING',style:const TextStyle(color:Colors.white,fontWeight:FontWeight.w800,fontSize:24)),
              const SizedBox(height:7),
              AppText(p?['status']=='APPROVED'?'Your profile is visible in customer searches.':'Complete your profile and payment verification. An admin must approve your registration.',style:const TextStyle(color:Colors.white,fontSize:12))
            ])),
            const SizedBox(height:16),
            Row(children:[Expanded(child:metric('⭐ ${p?['ratingAverage']??0}','Rating')),const SizedBox(width:10),Expanded(child:metric('${p?['ratingCount']??0}','Reviews')),const SizedBox(width:10),Expanded(child:metric('${p?['completedJobs']??0}','Completed'))]),
            const SizedBox(height:20),
            actionButton('Edit Skills, City, GPS & Profile',()=>go(context,WorkerEditScreen(profile:Map<String,dynamic>.from(p??{}))),icon:Icons.edit_outlined),
            actionButton('Registration Fee & Receipt',()=>go(context,const WorkerRegistrationFee()),icon:Icons.payments_outlined,outline:true),
            if(p?['status']=='APPROVED')OutlinedButton.icon(onPressed:()async{try{final position=await gpsPosition();await Api.patch('worker/location',{'latitude':position.latitude,'longitude':position.longitude});if(context.mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:AppText('Current GPS location updated')));}catch(e){showError(context,e)}},icon:const Icon(Icons.my_location),label:const AppText('Update My Current GPS Position')), 
            if(payments!=null&&payments.isNotEmpty)Padding(padding:const EdgeInsets.only(bottom:12),child:pill('Payment: ${payments.first['status']}',icon:Icons.receipt_long)),
            const SizedBox(height:14),
            const AppText('Incoming Jobs & Bookings',style:TextStyle(fontSize:20,fontWeight:FontWeight.w800,color:ink)),
            const SizedBox(height:10),
            if(bookings.isEmpty)Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(14)),child:const AppText('No job requests yet. Once approved, eligible nearby customers can request your services.')),
            for(final b in bookings)
              Card(color:Colors.white,child:ListTile(
                title:AppText(b['description'].toString(),maxLines:2,overflow:TextOverflow.ellipsis),
                subtitle:AppText('${b['status']} • Budget Rs. ${b['proposedPricePkr']??'—'}'),
                trailing:const Icon(Icons.chevron_right),
                onTap:()=>go(context,BookingDetailsScreen(booking:Map<String,dynamic>.from(b)))
              )),
            const SizedBox(height:10),
            TextButton.icon(onPressed:load,icon:const Icon(Icons.refresh),label:const AppText('Refresh Jobs'))
          ]
        )
      )
    );
  }
}

Widget metric(String value,String label)=>Container(padding:const EdgeInsets.all(13),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(12)),child:Column(children:[AppText(value,style:const TextStyle(fontWeight:FontWeight.bold,fontSize:17,color:forest)),const SizedBox(height:4),AppText(label,style:const TextStyle(color:muted,fontSize:12))]));

class WorkerEditScreen extends StatefulWidget {final Map<String,dynamic> profile;const WorkerEditScreen({super.key,required this.profile});@override State<WorkerEditScreen> createState()=>_WorkerEditScreenState();}
class _WorkerEditScreenState extends State<WorkerEditScreen>{late Set<String> selected;String? city,area;double? lat,lng;double radius=15;bool busy=false,visits=true,shop=false,emergency=false,sharePhone=false;final bio=TextEditingController(),years=TextEditingController();
 @override void initState(){super.initState();final p=widget.profile;selected=(p['serviceIds'] as List? ?? []).map((x)=>x.toString()).toSet();city=p['cityId'];area=p['areaId'];lat=(p['latitude'] as num?)?.toDouble();lng=(p['longitude'] as num?)?.toDouble();radius=(p['serviceRadiusKm'] as num?)?.toDouble()??15;visits=p['homeVisits']??true;sharePhone=p['publicContact']??false;shop=p['shopVisits']??false;emergency=p['emergencyAvailable']??false;bio.text=p['bio']?.toString()??'';years.text='${p['experienceYears']??0}';}
 Future<void> gps()async{try{final position=await gpsPosition();if(mounted)setState((){lat=position.latitude;lng=position.longitude;});}catch(e){showError(context,e)}}
 Future<void> upload()async{try{final file=await ImagePicker().pickImage(source:ImageSource.gallery,maxWidth:1400);if(file!=null){await Api.upload('worker/photos',file.path);if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:AppText('Photo uploaded for profile review')));}}catch(e){showError(context,e)}}
 Future<void> save()async{if(selected.isEmpty||city==null||lat==null||lng==null){showError(context,'Choose skills, a city and GPS location.');return;}setState(()=>busy=true);try{await Api.put('worker/profile',{'serviceIds':selected.toList(),'cityId':city,'areaId':area,'latitude':lat,'longitude':lng,'serviceRadiusKm':radius,'experienceYears':int.tryParse(years.text)??0,'bio':bio.text,'publicContact':sharePhone,'homeVisits':visits,'shopVisits':shop,'emergencyAvailable':emergency});if(mounted){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:AppText('Profile submitted for admin approval')));go(context,const WorkerHome(),replace:true);}}catch(e){showError(context,e)}finally{if(mounted)setState(()=>busy=false);}}
 @override Widget build(BuildContext context){final a=AppScope.of(context);final cities=a.locations.where((x)=>x['kind']=='city').toList(),areas=a.locations.where((x)=>x['kind']=='area'&&x['parentId']==city).toList();return Scaffold(appBar:AppBar(title:const AppText('My Worker Profile')),body:ListView(padding:const EdgeInsets.all(18),children:[sectionTitle('Skills & Profile','All details are reviewed before they are public.'),const SizedBox(height:18),const AppText('Services You Offer',style:TextStyle(fontWeight:FontWeight.bold)),const SizedBox(height:9),Wrap(spacing:6,runSpacing:5,children:a.services.where((s)=>s['slug']!='more').map((s)=>FilterChip(label:AppText(s['name'].toString()),selected:selected.contains(s['id']),onSelected:(v)=>setState((){v?selected.add(s['id'].toString()):selected.remove(s['id'].toString());}))).toList()),const SizedBox(height:20),entry('About You / Skills',bio,hint:'Tell customers about your work',lines:4),entry('Years of Experience',years,keyboard:TextInputType.number),DropdownButtonFormField<String>(value:cities.any((x)=>x['id']==city)?city:null,decoration:const InputDecoration(labelText:'City'),items:cities.map((x)=>DropdownMenuItem<String>(value:x['id'],child:AppText(x['name'].toString()))).toList(),onChanged:(v)=>setState((){city=v;area=null;})),const SizedBox(height:14),DropdownButtonFormField<String>(value:areas.any((x)=>x['id']==area)?area:null,decoration:const InputDecoration(labelText:'Area'),items:areas.map((x)=>DropdownMenuItem<String>(value:x['id'],child:AppText(x['name'].toString()))).toList(),onChanged:(v)=>setState(()=>area=v)),const SizedBox(height:18),OutlinedButton.icon(onPressed:gps,icon:const Icon(Icons.my_location),label:AppText(lat==null?'Set Accurate GPS Location':'GPS: ${lat!.toStringAsFixed(4)}, ${lng!.toStringAsFixed(4)}')),const SizedBox(height:15),AppText('My Coverage: ${radius.toInt()} km'),Slider(value:radius.clamp(1,50),min:1,max:50,divisions:49,onChanged:(v)=>setState(()=>radius=v)),SwitchListTile(value:sharePhone,onChanged:(v)=>setState(()=>sharePhone=v),title:const AppText('Show my phone number publicly to customers')),SwitchListTile(value:visits,onChanged:(v)=>setState(()=>visits=v),title:const AppText('I visit customers at their address')),SwitchListTile(value:shop,onChanged:(v)=>setState(()=>shop=v),title:const AppText('Customers can visit my shop')),SwitchListTile(value:emergency,onChanged:(v)=>setState(()=>emergency=v),title:const AppText('Available for emergency jobs')),const SizedBox(height:14),OutlinedButton.icon(onPressed:upload,icon:const Icon(Icons.add_a_photo),label:const AppText('Upload Profile / Work Portfolio Photo')),labelText('Uploaded photos are compressed to WebP. Limit: 8 photos.'),const SizedBox(height:25),actionButton(busy?'Saving…':'Save & Send for Approval',busy?(){}:save)]));}
}

class NotificationsScreen extends StatefulWidget {const NotificationsScreen({super.key});@override State<NotificationsScreen> createState()=>_NotificationsScreenState();}
class _NotificationsScreenState extends State<NotificationsScreen>{List<dynamic> notifications=[];
 @override void initState(){super.initState();load();}
 Future<void> load()async{try{final res=await Api.get('notifications');if(mounted)setState(()=>notifications=List<dynamic>.from(res));}catch(e){showError(context,e)}}
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const AppText('Notifications')),body:RefreshIndicator(onRefresh:load,child:ListView(padding:const EdgeInsets.all(15),children:[if(notifications.isEmpty)const AppText('No notifications yet.'),...notifications.map((n)=>Card(color:n['read']==true?Colors.white:const Color(0xFFE4F8ED),child:ListTile(title:AppText(n['title'].toString()),subtitle:AppText(n['body'].toString()),trailing:Icon(n['read']==true?Icons.notifications_none:Icons.circle,color:forest,size:13),onTap:()async{try{await Api.patch('notifications/${n['id']}/read',{});await load();}catch(e){showError(context,e)}})))])));
}
