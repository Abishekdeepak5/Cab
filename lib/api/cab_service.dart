import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_mao/components/constants.dart';
import 'package:google_mao/models/cab.dart';
import 'package:google_mao/provider/stateprovider.dart';
import 'package:http/http.dart' show Client;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CabApiService {
  // final String baseUrl = "https://localhost:7048";
  final String baseUrl = "https://meterproservice.azurewebsites.net";

  Client client = Client();

  Future<Cab> getAvaiableCar() async {
    try {
      final response = await client.get(Uri.parse("$baseUrl/api/Cab/showCab"));
      if (response.statusCode == 200) {
        // print(response.body);
        return CabFromJson(response.body);
      } else if (response.statusCode == 204) {
        return Cab(carNumber: "Sorry!, Cab Unavailable", cabId: 0);
      } else {
        print(response.statusCode);
        return Cab(carNumber: "", cabId: 0);
      }
    } catch (err) {
      return Cab(carNumber: "", cabId: 0);
    }
  }


  Future<bool> endCab(String token, int id, String address, double price,double miles) async {
    try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
        int? tripId=prefs.getInt('tripId');
    // var uri = Uri.parse('$baseUrl/RecScreenshot/$tripId');
      Map<String, dynamic> data = {
        'cabId': id,
        'endAddress': address,
        'endTime':DateTime.now().toIso8601String(),
        'price': price,
        'miles':miles
      };
      String jsonString = json.encode(data);
      final response = await client.put(
        Uri.parse("$baseUrl/api/Cab/endCab/$tripId"),
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer $token'
        },
        body: jsonString,
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print(response.statusCode);
        return false;
      }
    } catch (err) {
      return false;
    }
  }

  Future<bool> startAddress(String token, int carId, String startAddress) async {
    try {
       final SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> data = {
        'cabId': carId,
        'startAddress': startAddress,
        'startTime':DateTime.now().toIso8601String(),
      };
      String jsonString = json.encode(data);

      final response = await client.put(
        Uri.parse("$baseUrl/api/Cab/startAddress"),
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer $token'
        },
        body: jsonString,
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        int id=int.parse(response.body);
        prefs.setInt('tripId', id);
        return true;
      } else {
        return false;
      }
    } catch (err) {
      return false;
    }
  }
}






  // Future<bool> StartCab(String token, String cabNum, int id) async {
  //   try {
  //     final response = await client.put(
  //       Uri.parse("$baseUrl/api/Cab/startCab"),
  //       headers: {
  //         "content-type": "application/json",
  //         'Authorization': 'Bearer $token'
  //       },
  //       body: CabToJson(Cab(carNumber: cabNum, cabId: id)),
  //     );
  //     if (response.statusCode == 200) {
  //       return true;
  //     } else {
  //       print(response.statusCode);
  //       return false;
  //     }
  //   } catch (err) {
  //     return false;
  //   }
  // }