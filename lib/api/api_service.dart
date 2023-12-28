import 'dart:convert';
import 'package:google_mao/models/category.dart';
import 'package:http/http.dart' show Client;

class ApiService1 {
  final String baseUrl = "https://localhost:7048/api/UserDetail";
  // https://localhost:7105/api/Category
  Client client = Client();

  void getBrandss() async {
    final response = await client.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      // ignore: avoid_print
      print("Hello");
      final data=json.decode(response.body);
      // print(data);
      List<Categorys>.from(data.map((item) => Categorys.fromJson(item)));
    } else {
      return;
    }
  }

   Future<List<Categorys>> getCategory() async {
    final response = await client.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return CategoryFromJson(response.body);
    } else {
      return [];
    }
  }

  }
