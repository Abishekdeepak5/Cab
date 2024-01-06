import 'dart:convert';

class Cab {
  String cabNumber;
  Cab({required this.cabNumber});

  factory Cab.fromJson(Map<String, dynamic> map) {
    return Cab(cabNumber: map["carNumber"]);
  }

  Map<String, dynamic> toJson() {
    return {"cabNumber": cabNumber};
  }


  @override
  String toString() {
    return 'Cab{cabNumber: $cabNumber}';
  }
}
Cab CabFromJson(String jsonData) {
  final data = json.decode(jsonData);
   return Cab.fromJson(data);
}

String CabToJson(Cab data) {
  final jsonData = data.toJson();
  // print(json.encode(jsonData));
  return json.encode(jsonData);
}
