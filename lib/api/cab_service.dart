import 'dart:convert';
import 'package:google_mao/models/cab.dart';
import 'package:http/http.dart' show Client;

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

  Future<bool> StartCab(String token, String cabNum, int id) async {
    try {
      final response = await client.put(
        Uri.parse("$baseUrl/api/Cab/startCab"),
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer $token'
        },
        body: CabToJson(Cab(carNumber: cabNum, cabId: id)),
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

  Future<bool> endCab(
      String token, int id, String address, double price) async {
    try {
      Map<String, dynamic> data = {
        'cabId': id,
        'endAddress': address,
        'price': price
      };
      String jsonString = json.encode(data);
      final response = await client.put(
        Uri.parse("$baseUrl/api/Cab/endCab"),
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer $token'
        },
        body: jsonString,
      );
      if (response.statusCode == 200) {
        print("Trip end");
        return true;
      } else {
        print(response.statusCode);
        return false;
      }
    } catch (err) {
      return false;
    }
  }

  Future<bool> StartAddress(
      String token, int carId, String startAddress) async {
    try {
      Map<String, dynamic> data = {
        'cabId': carId,
        'startAddress': startAddress,
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
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      return false;
    }
  }
}
