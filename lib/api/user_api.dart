import 'dart:convert';
import 'package:google_mao/models/login.dart';
import 'package:http/http.dart' show Client;

class UserApiService {
  final String baseUrl = "https://localhost:7048";
  Client client = Client();

   Future<UserDetail> LoginUser(Login data) async {
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
    }
  }
  }
