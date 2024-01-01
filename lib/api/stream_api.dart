import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:google_mao/main.dart';
import 'package:http/http.dart' as http;

class StreamApiClient {
  // final String baseUrl;

  // StreamApiClient(this.baseUrl);

  StreamController<List<Map<String, dynamic>>> _streamController =StreamController<List<Map<String, dynamic>>>();

  Stream<List<Map<String, dynamic>>> get stream => _streamController.stream;

  Future<void> startStreaming() async {
    print("init");
    HttpOverrides.global = MyHttpOverrides();
    final client = http.Client();

final response = await client.get(Uri.parse('https://localhost:7048/api/Stream'));

    // final response = await http.get(Uri.parse('https://localhost:7048/api/Stream'));
      print(response.statusCode);

    if (response.statusCode == 200) {
      // Parse the JSON data
      final List<Map<String, dynamic>> data =List<Map<String, dynamic>>.from(json.decode(response.body));
      print(json.decode(response.body));

      // Add data to the stream
      _streamController.add(data);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
