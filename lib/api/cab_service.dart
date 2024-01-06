
import 'dart:convert';

import 'package:google_mao/models/cab.dart';
import 'package:http/http.dart' show Client;
class CabApiService {
    
  final String baseUrl = "https://localhost:7048";
  Client client = Client();

  Future<Cab> getAvaiableCar() async{
    final response = await client.get(Uri.parse("$baseUrl/api/Cab/showCab"));
    if (response.statusCode == 200){
      // print(response.body);
      return CabFromJson(response.body);  
    }
    else if(response.statusCode ==204){
      return Cab(cabNumber: "Sorry!, Cab Unavailable");
    }
    else {
      print(response.statusCode);
      return Cab(cabNumber: "");
     }
  }

      // headers: {'Authorization': 'Bearer $token'},
      // headers: {"content-type": "application/json"},
  Future<bool> StartCab(String token,String cabNum)async{
    final response = await client.put(
      Uri.parse("$baseUrl/api/Cab/startCab"),
      headers: {"content-type": "application/json",'Authorization': 'Bearer $token'},
      body: CabToJson(Cab(cabNumber: cabNum)),
    );
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.statusCode);
      return false;
    }
  }

  Future<bool> endCab(String token, String carNumber) async{
    final response = await client.put(
      Uri.parse("$baseUrl/api/Cab/endCab"),
      headers: {"content-type": "application/json",'Authorization': 'Bearer $token'},
      body: CabToJson(Cab(cabNumber: carNumber)),
    );
    if (response.statusCode == 200) {
      print("Trip end");
      return true;
    } else {
      print(response.statusCode);
      return false;
    }
  }

}