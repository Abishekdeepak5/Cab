import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_mao/models/login.dart';
import 'package:google_mao/provider/stateprovider.dart';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';

class UserApiService {
  // final String baseUrl = "https://localhost:7048";
  final String baseUrl = "https://meterproservice.azurewebsites.net";

  Client client = Client();

   Future<UserDetail> LoginUser(Login data) async {
    try{
    final response = await client.post(
      Uri.parse("$baseUrl/login"),
      headers: {"content-type": "application/json"},
      body: UserToJson(data),
    );
    if (response.statusCode == 200){
      final data = json.decode(response.body);
       return UserDetail.fromJson(data);
    }
     else {
      print(response.statusCode);
      return UserDetail(firstname: "Hello", lastname: "Hello", token:"");
    }}catch(err){
      print("error");
      return UserDetail(firstname: "No internet", lastname: "Hello", token:"");
    }
  }

  Future<int> checkToken(String token,StateProvider provider) async{
    print('Hello');
    try{
      Map<String, dynamic> data = {
        'token':token 
      };
      String jsonString = json.encode(data);
      print('send $jsonString');
    final response = await client.put(Uri.parse("$baseUrl/api/UserLogin/validate"), headers: {
      "content-type": "application/json",
      'Authorization': 'Bearer $token'
    },
    body: jsonString,);
    print(response.statusCode);
    if (response.statusCode == 400){
       return response.statusCode;
    }
    else if(response.statusCode==204){
      return response.statusCode;
    }
    else if(response.statusCode==200){
      print('rec ${response.body}'); 
      String newToken=response.body ;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList('token', <String>[provider.firstName, provider.lastName, newToken]);
      provider.setToken(UserDetail(firstname: provider.firstName, lastname:provider.lastName, token: newToken));
      return response.statusCode;
    }
    else {
      return response.statusCode;
     }}catch(err){
      print('err $err');
      return 0;
     }
  }
}
