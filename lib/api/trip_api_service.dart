import 'dart:convert';
import 'package:google_mao/models/HistoryModel.dart';
import 'package:google_mao/models/LocationModel.dart';
import 'package:http/http.dart' show Client;

class TripApiService {
  // final String baseUrl = "https://localhost:7048/api";

  final String baseUrl = "https://meterproservice.azurewebsites.net/api";
  Client client = Client();

  void getLocations() async {
    final response = await client.get(Uri.parse("$baseUrl/Trip/allTrip"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Trip>.from(data.map((item) => Trip.fromJson(item)));
    } else {
      return;
    }
  }

  Future<List<Trip>> getTrip() async {
    final response = await client.get(Uri.parse("$baseUrl/Trip"));
    if (response.statusCode == 200) {
      return LocationFromJson(response.body);
    } else {
      return [];
    }
  }

  Future<List<TripsHistory>> getHistory(String token) async {
    final response = await client.get(Uri.parse("$baseUrl/Trip"), headers: {
      "content-type": "application/json",
      'Authorization': 'Bearer $token'
    });
    print(response.body);
    if (response.statusCode == 200) {
      return HistoryFromJson(response.body);
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
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
