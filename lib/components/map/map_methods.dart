import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mao/api/cab_service.dart';
import 'package:google_mao/api/image_api.dart';
import 'package:google_mao/api/trip_api_service.dart';
import 'package:google_mao/components/constants.dart';
import 'package:google_mao/components/user_crud/update_location.dart';
// import 'package:geocoder/geocoder.dart';
import 'package:google_mao/models/LocationModel.dart';
import 'package:google_mao/provider/stateprovider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:google_mao/provider/locationprovider.dart';
import 'package:location/location.dart';
import 'dart:math' show asin, atan2, cos, pi, sin, sqrt;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:geolocator/geolocator.dart';

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

  Future<CameraUpdate?> updateCamera(Marker _sourceMarker,Marker _destinationMarker,LatLng currentLocation) async {
    try{
      _destinationMarker = _destinationMarker.copyWith(
                                        positionParam: LatLng(currentLocation.latitude, currentLocation.longitude), 
      );
      LatLngBounds bounds = LatLngBounds(
    southwest: LatLng(
      _sourceMarker.position.latitude < _destinationMarker.position.latitude
          ? _sourceMarker.position.latitude
          : _destinationMarker.position.latitude,
      _sourceMarker.position.longitude < _destinationMarker.position.longitude
          ? _sourceMarker.position.longitude
          : _destinationMarker.position.longitude,
    ),
    northeast: LatLng(
      _sourceMarker.position.latitude > _destinationMarker.position.latitude
          ? _sourceMarker.position.latitude
          : _destinationMarker.position.latitude,
      _sourceMarker.position.longitude > _destinationMarker.position.longitude
          ? _sourceMarker.position.longitude
          : _destinationMarker.position.longitude,
    ),
  );
    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(
      bounds,
      100.0, );
      return cameraUpdate;
    }catch(err){
        return null;
    }
  }

