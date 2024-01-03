import 'package:flutter/material.dart';
import 'package:google_mao/models/login.dart';
class StateProvider with ChangeNotifier{
  int _pageIndex=0;
  double lat=0;
  double lng=0;
  String firstname="";
  String lastname="";
  String token="";
  double get latitude=>lat;
  double get longitude=>lng;
  String get firstName=>firstname;
  String get lastName=>lastname;
  int get pageIndex =>_pageIndex;
  void changePage(int indexval){
    _pageIndex=indexval;
    notifyListeners();
  }

  
  updateLocation(Object latitude,Object longitude){
    try{
    lat=double.parse(latitude.toString());
    lng=double.parse(longitude.toString());
    }catch(err){
      print("$err");
    }
    notifyListeners();
  }

  setToken(UserDetail user){
    token=user.token;
    firstname=user.firstname;
    lastname=user.lastname;
    notifyListeners();
  }

}