import 'package:google_mao/models/brands.dart';
import 'package:http/http.dart' show Client;

class ApiSampleService {
  final String baseUrl = "https://fakestoreapi.com";
  Client client = Client();

  Future<List<Brands>> getBrandss() async {
    final response = await client.get(Uri.parse("$baseUrl/products"));
    if (response.statusCode == 200) {
      return BrandsFromJson(response.body);
    } else {
      return [];
    }
  }

  Future<bool> createBrands(Brands data) async {
    final response = await client.post(
      Uri.parse("$baseUrl/products"),
      headers: {"content-type": "application/json"},
      body: BrandsToJson(data),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateBrands(Brands data) async {
    final response = await client.put(
      Uri.parse("$baseUrl/products/${data.id}"),
      headers: {"content-type": "application/json"},
      body: BrandsToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteBrands(int id) async {
    final response = await client.delete(
      Uri.parse("$baseUrl/products/$id"),
      headers: {"content-type": "application/json"},
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
}
