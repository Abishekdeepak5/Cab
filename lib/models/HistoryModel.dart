import 'dart:convert';


class TripsHistory {
  int id;
  // int cabId;
  String? startLocation;
  String? endLocation;
  double? price;
  
  int cabId;

  TripsHistory({required this.id, required this.cabId,required this.startLocation,required this.endLocation,required this.price});
//  ,required this.price
  factory TripsHistory.fromJson(Map<String, dynamic> map) {
    return TripsHistory(id: map["id"], cabId: map["cabId"],startLocation: map["startLocation"],endLocation: map["endLocation"],price: map["price"] != null ?  double.parse(map["price"].toStringAsFixed(4)) : null);
  }
// ,price: map["price"]
  Map<String, dynamic> toJson() {
    return {"id": id, "title": startLocation};
  }

  @override
  String toString() {
    return 'Brands{id: $id, name: $startLocation}';
  }
}

List<TripsHistory> HistoryFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<TripsHistory>.from(data.map((item) => TripsHistory.fromJson(item)));
}

String HistoryToJson(TripsHistory data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
