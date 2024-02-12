import 'dart:convert';

class Trip {
  int id;
  double latitude;
  double longitude;
  Trip({required this.id, required this.latitude,required this.longitude});

  factory Trip.fromJson(Map<String, dynamic> map) {
    return Trip(id: map["id"], latitude: map["latitude"],longitude: map["longitude"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "latitude": latitude , "longitude":longitude };
  }


  @override
  String toString() {
    return 'Trips{id: $id, latitude: $latitude , longitude: $longitude}';
  }
}

List<Trip> LocationFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Trip>.from(data.map((item) => Trip.fromJson(item)));
}

String LocationToJson(Trip data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
