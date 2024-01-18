import 'package:flutter/material.dart';
import 'package:google_mao/models/login.dart';
class StateProvider with ChangeNotifier{
  int _pageIndex=0;
  double lat=0;
  double lng=0;
  String firstname="";
  String lastname="";
  String token="";
  String carNum="";
  int carid=0;
  bool iscabstart=false;
  String testString="";
  String get testStr=>testString;
  bool get isCabStart=>iscabstart;
  double get latitude=>lat;
  double get longitude=>lng;
  String get carNumber=>carNum;
  String get firstName=>firstname;
  String get lastName=>lastname;
  String get Token=>token;
  int get carId=>carid;

  int get pageIndex =>_pageIndex;
  void changePage(int indexval){
    _pageIndex=indexval;
    notifyListeners();
  }

  void testing(String s){
    testString=s;
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

  void setCarNumber(String carNumber,int id) {
    carNum=carNumber;
    carid=id;
    notifyListeners();
  }

  void setCabStart(bool val){
    iscabstart=val;
    notifyListeners();
  }

}