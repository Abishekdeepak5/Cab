import 'dart:convert';

import 'package:http/http.dart' as http;

Map<String, String> headers = {'Content-Type': 'application/json'};

class Brands {
  int id;
  String brand_name;

  Brands({required this.id, required this.brand_name});

  factory Brands.createPostBrands(Map<String, dynamic> object) {
    return Brands(id: object['id'], brand_name: object['title']);
  }

  static Future<Brands> connectToAPI(int id, String brand_name) async {
    String apiURL = "https://fakestoreapi.com/products";
    final msg = jsonEncode({"id": id, "title": brand_name});

    var apiResult = await http.post(apiURL as Uri, body: msg, headers: headers);
    var jsonObject = json.decode(apiResult.body);

    return Brands.createPostBrands(jsonObject);
  }
}
