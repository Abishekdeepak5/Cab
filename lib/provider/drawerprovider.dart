import 'package:flutter/material.dart';
class PageChange with ChangeNotifier{
  int _pageIndex=0;
  int get pageIndex =>_pageIndex;
  void changePage(int indexval){
    _pageIndex=indexval;
    notifyListeners();
  }
}