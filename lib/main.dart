import 'package:flutter/material.dart';
import 'package:google_mao/provider/drawerprovider.dart';
import 'package:google_mao/ui/home_screen.dart';
import 'dart:io';
import 'package:provider/provider.dart';

void main() {
  // HttpOverrides.global = MyHttpOverrides();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PageChange()),
        // Provider(create: (context) => SomeOtherClass()),
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return 
    MaterialApp(
      title: 'Avecsage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      home: const HomeScreen(), 
    );
  }
}
