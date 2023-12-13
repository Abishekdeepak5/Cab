import 'dart:convert';

class Brands {
  int id;
  String brand_name;

  Brands({required this.id, required this.brand_name});

  factory Brands.fromJson(Map<String, dynamic> map) {
    return Brands(id: map["id"], brand_name: map["title"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "title": brand_name};
  }

  @override
  String toString() {
    return 'Brands{id: $id, name: $brand_name}';
  }
}

List<Brands> BrandsFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Brands>.from(data.map((item) => Brands.fromJson(item)));
}

String BrandsToJson(Brands data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
