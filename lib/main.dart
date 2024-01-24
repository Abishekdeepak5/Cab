import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mao/provider/stateprovider.dart';
import 'package:google_mao/ui/signIn.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StateProvider()),
      ],
    child:const MyApp()),);
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avecsage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home:AuthenticationWrapper() ,
    );
  }
}


// Future<bool> isAuthenticated(BuildContext context) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String>? items = prefs.getStringList('token');
//     if(items?.length==0 || items==null){
//       return false;
//     }
//     else{
//        UserApiService user=UserApiService();
//        String isValid=await user.checkToken(items![2]);
//        print("num $isValid");
//        if(isValid=='204'){
//         myProvider.setToken(UserDetail(firstname: items![0], lastname:items![1] , token: items![2]));
//         return true;
//        }
//        else if(isValid.length>10){
//         final SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.setStringList('token', <String>[ items![0],  items![1], isValid]);
//         myProvider.setToken(UserDetail(firstname: items![0], lastname:items![1] , token: items![2]));
//         myProvider.testing('new token');
//         return true;
//        }
//        else{
//         return false;
//        }
//     }
//   }


// Future<String> checkToken(String token) async{
//     print('Hello'); 
//     try{
//       Map<String, dynamic> data = {
//         'token':token 
//       };
//       String jsonString = json.encode(data);
//       print('send $jsonString');
//     final response = await client.put(Uri.parse("$baseUrl/api/UserLogin/validate"), headers: {
//       "content-type": "application/json",
//       'Authorization': 'Bearer $token'
//     },
//     body: jsonString,);
//     print(response.statusCode);
//     if (response.statusCode == 400){
//        return '${response.statusCode}';
//     }
//     else if(response.statusCode==204){
//       return '${response.statusCode}';
//     }
//     else if(response.statusCode==200){
//       print('rec ${response.body}');
//       String newToken=response.body ;
//       // final SharedPreferences prefs = await SharedPreferences.getInstance();
//       // prefs.setStringList('token', <String>[provider.firstName, provider.lastName, newToken]);
//       // provider.setToken(UserDetail(firstname: provider.firstName, lastname:provider.lastName, token: newToken));
//       return newToken;
//     }
//     else {
//       return '${response.statusCode}';
//      }}catch(err){
//       print('err $err');
//       return "error";
//      }
//   }