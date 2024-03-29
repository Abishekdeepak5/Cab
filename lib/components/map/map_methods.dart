import 'dart:math' show asin, atan2, cos, pi, sin, sqrt;
import 'package:google_maps_flutter/google_maps_flutter.dart';

double calculateBearing(LatLng startPoint, LatLng endPoint) {
  final double startLat = toRadians(startPoint.latitude);
  final double startLng = toRadians(startPoint.longitude);
  final double endLat = toRadians(endPoint.latitude);
  final double endLng = toRadians(endPoint.longitude);

  final double deltaLng = endLng - startLng;

  final double y = sin(deltaLng) * cos(endLat);
  final double x = cos(startLat) * sin(endLat) -
      sin(startLat) * cos(endLat) * cos(deltaLng);

  final double bearing = atan2(y, x);
  return (toDegrees(bearing) + 360) % 360;
}

double toRadians(double degrees) {
  return degrees * (pi / 180.0);
}

double toDegrees(double radians) {
  return radians * (180.0 / pi);
}

//   Future<CameraUpdate?> updateCamera(Marker _sourceMarker,Marker _destinationMarker,LatLng currentLocation) async {
//     try{
//       _destinationMarker = _destinationMarker.copyWith(
//                                         positionParam: LatLng(currentLocation.latitude, currentLocation.longitude), 
//       );
//       LatLngBounds bounds = LatLngBounds(
//     southwest: LatLng(
//       _sourceMarker.position.latitude < _destinationMarker.position.latitude
//           ? _sourceMarker.position.latitude
//           : _destinationMarker.position.latitude,
//       _sourceMarker.position.longitude < _destinationMarker.position.longitude
//           ? _sourceMarker.position.longitude
//           : _destinationMarker.position.longitude,
//     ),
//     northeast: LatLng(
//       _sourceMarker.position.latitude > _destinationMarker.position.latitude
//           ? _sourceMarker.position.latitude
//           : _destinationMarker.position.latitude,
//       _sourceMarker.position.longitude > _destinationMarker.position.longitude
//           ? _sourceMarker.position.longitude
//           : _destinationMarker.position.longitude,
//     ),
//   );
//     CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(
//       bounds,
//       100.0, );
//       return cameraUpdate;
//     }catch(err){
//         return null;
//     }
//   }

// class LatLng {
//   final double latitude;
//   final double longitude;

//   LatLng(this.latitude, this.longitude);
// }

double calculateLocationDistance(LatLng point1, LatLng point2) {
  const double earthRadius = 6371; // Earth radius in kilometers

  double lat1Rad = degreesToRadians(point1.latitude);
  double lon1Rad = degreesToRadians(point1.longitude);
  double lat2Rad = degreesToRadians(point2.latitude);
  double lon2Rad = degreesToRadians(point2.longitude);

  double dLat = lat2Rad - lat1Rad;
  double dLon = lon2Rad - lon1Rad;

  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  double distance = earthRadius * c;

  return distance;
}

double degreesToRadians(double degrees) {
  return degrees * pi / 180.0;
}

