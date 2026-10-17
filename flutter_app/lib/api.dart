import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const apiBase = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:4000/api');
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override String toString() => message;
}
class Api {
  static const storage = FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));
  static String? accessToken;
  static Map<String,dynamic>? user;
  static String absoluteImage(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.startsWith('http://localhost:4000') || url.startsWith('http://127.0.0.1:4000')) {
      final root = Uri.parse(apiBase);
      return url.replaceFirst(RegExp(r'https?://(localhost|127\.0\.0\.1):4000'), '${root.scheme}://${root.host}:${root.port}');
    }
    return url;
  }
  static Future<void> restore() async {
    accessToken=await storage.read(key:'accessToken');
    if(accessToken!=null) {
      try { user=Map<String,dynamic>.from(await get('auth/me')); }
      catch (_) { accessToken=null; user=null; await storage.delete(key:'accessToken'); }
    }
  }
  static Future<void> saveSession(dynamic json) async {
    accessToken=json['accessToken'] as String;
    user=Map<String,dynamic>.from(json['user'] as Map);
    await storage.write(key:'accessToken',value:accessToken);
  }
  static Future<void> logout() async {accessToken=null; user=null;await storage.delete(key:'accessToken');}
  static Future<dynamic> get(String path,{Map<String,String>? query}) => request('GET',path,query:query);
  static Future<dynamic> post(String path,Map<String,dynamic> body)=>request('POST',path,body:body);
  static Future<dynamic> put(String path,Map<String,dynamic> body)=>request('PUT',path,body:body);
  static Future<dynamic> patch(String path,Map<String,dynamic> body)=>request('PATCH',path,body:body);
  static Future<dynamic> request(String method,String path,{Map<String,String>? query,Map<String,dynamic>? body}) async {
    final base=Uri.parse('$apiBase/$path');
    final uri=query==null?base:base.replace(queryParameters:query);
    final headers=<String,String>{'Accept':'application/json','Content-Type':'application/json'};
    if(accessToken!=null)headers['Authorization']='Bearer $accessToken';
    try {
      final res=http.Request(method,uri);
      res.headers.addAll(headers);
      if(body!=null)res.body=jsonEncode(body);
      final client=http.Client();
      late http.Response response;
      try{
        final streamed=await client.send(res).timeout(const Duration(seconds:20));
        response=await http.Response.fromStream(streamed);
      }finally{client.close();}
      dynamic data;
      try { data=jsonDecode(response.body); }catch (_) { data=response.body; }
      if(response.statusCode>=400){ final m=data is Map?data['message']:null;throw ApiException(m is List?m.join(', '):m?.toString()??'Request failed (${response.statusCode})'); }
      return data;
    }on ApiException { rethrow; }
    catch(e){throw ApiException('Cannot connect to server. Check your internet/API address. $e');}
  }
  static Future<dynamic> upload(String path,String filePath) async {
    final req=http.MultipartRequest('POST',Uri.parse('$apiBase/$path'));
    if(accessToken!=null)req.headers['Authorization']='Bearer $accessToken';
    req.files.add(await http.MultipartFile.fromPath('file',filePath));
    final response=await http.Response.fromStream(await req.send().timeout(const Duration(seconds:50)));
    final data=jsonDecode(response.body);
    if(response.statusCode>=400) throw ApiException(data['message']?.toString()??'Upload failed');
    return data;
  }
}

class AppData extends ChangeNotifier {
  Map<String,dynamic> config={};
  List<dynamic> services=[];
  List<dynamic> locations=[];
  String lang='en';
  String? selectedCity, selectedArea;
  double? userLat,userLng;
  bool loading=false;
  bool get signedIn=>Api.user!=null;
  String get role=>Api.user?['role']?.toString()??'';
  String get name=>Api.user?['name']?.toString()??'';
  String label(String id,String fallback) => (((config['labels'] as Map?)?[lang] as Map?)?[id])?.toString()??fallback;
  String image(String id) => Api.absoluteImage((config['images'] as Map?)?[id]?.toString());
  Future<void> initialize() async {
    loading=true;notifyListeners();
    await Api.restore();
    try{config=Map<String,dynamic>.from(await Api.get('public/config'));}catch(_){config={'appName':'Hunar Near Me','appNameUrdu':'ہنر آپ کے قریب','images':{},'labels':{}};}
    try{services=List<dynamic>.from(await Api.get('public/services'));}catch(_){services=[];}
    try{locations=List<dynamic>.from(await Api.get('public/locations'));}catch(_){locations=[];}
    loading=false;notifyListeners();
  }
  Future<void> loadLocations()async{locations=List<dynamic>.from(await Api.get('public/locations'));notifyListeners();}
  void setLocale(String v){lang=v;notifyListeners();}
  void updateLocation(String? city,String? area,{double? lat,double? lng}){selectedCity=city;selectedArea=area;userLat=lat??userLat;userLng=lng??userLng;notifyListeners();}
  void changed(){notifyListeners();}
  String locName(String? id) => locations.cast<dynamic>().where((x)=>x['id']==id).map((x)=>x['name']?.toString()??'').firstOrNull??'';
}
