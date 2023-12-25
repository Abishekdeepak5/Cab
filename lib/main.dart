import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_mao/ui/home.dart';
import 'package:google_mao/ui/associated_cabs.dart';
import 'package:google_mao/components/crud/list_page.dart';
import 'package:google_mao/components/map/location_traking.dart';
import 'package:google_mao/ui/passengerDetailPage/home_screen.dart';
import 'package:google_mao/ui/signIn.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
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
      // home: const LocationTracking(),
      // home: const APIHomeScreen(),
      home: AssociatedCabs(),
    );
  }
}
