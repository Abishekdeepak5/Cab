import 'dart:convert';

class Categorys {
  int id;
  String name;

  Categorys({required this.id, required this.name});

  factory Categorys.fromJson(Map<String, dynamic> map) {
    return Categorys(id: map["id"], name: map["user_name"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "title": name};
  }


  @override
  String toString() {
    return 'Categorys{id: $id, name: $name}';
  }
}

List<Categorys> CategoryFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Categorys>.from(data.map((item) => Categorys.fromJson(item)));
}

String CategoryToJson(Categorys data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
