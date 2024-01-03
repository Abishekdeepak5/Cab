import 'package:flutter/material.dart';
class getLatitudeLongitude with ChangeNotifier{
  // int _pageIndex=0;
  double lat=0;
  double lng=0;
  double get latitude=>lat;
  double get longitude=>lng;
  updateLocation(Object latitude,Object longitude){
    try{
    lat=double.parse(latitude.toString());
    lng=double.parse(longitude.toString());
    }catch(err){
      print("$err");
    }
    notifyListeners();
  }
}