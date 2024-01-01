import 'dart:convert';
import 'package:google_mao/models/LocationModel.dart';
import 'package:http/http.dart' show Client;

class ApiTripService {
  final String baseUrl = "https://localhost:7048/api/Trip";
  Client client = Client();

  void getLocations() async {
    final response = await client.get(Uri.parse("$baseUrl/allTrip"));
    if (response.statusCode == 200) {
      // ignore: avoid_print
      print("Hello");
      final data=json.decode(response.body);
      print(data);
      List<Trip>.from(data.map((item) => Trip.fromJson(item)));
    } else {
      return;
    }
  }

   Future<List<Trip>> getTrip() async {
    final response = await client.get(Uri.parse("$baseUrl/allTrip"));
    
    if (response.statusCode == 200) {
      return LocationFromJson(response.body);
    } else {
      return [];
    }
  }

  Future<bool> updateLocations(Trip data) async {
    final response = await client.put(
      Uri.parse("$baseUrl?id=${data.id}"),
      headers: {"content-type": "application/json"},
      body: LocationToJson(data),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  }
