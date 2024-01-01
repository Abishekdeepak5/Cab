import 'package:flutter/material.dart';
class getLatitudeLongitude with ChangeNotifier{
  // int _pageIndex=0;
  double lat=0;
  double lng=0;
  double get latitude=>lat;
  double get longitude=>lng;
  void listenLocation(){
    
    notifyListeners();
  }
}