import 'dart:convert';

class Cab {
  int cabId;
  String carNumber;
  Cab({required this.carNumber,required this.cabId});

  factory Cab.fromJson(Map<String, dynamic> map) {
    return Cab(carNumber: map["carNumber"],cabId:map["id"]);
  }

  Map<String, dynamic> toJson() {
    return {"cabId":cabId,"carNumber": carNumber};
  }


  @override
  String toString() {
    return 'Cab{"cabId":$cabId,carNumber: $carNumber}';
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
