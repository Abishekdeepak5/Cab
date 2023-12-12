import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'dart:async';

class LocationService {
  UserLocation? _currentLocation;
  var location = Location();
  final StreamController<UserLocation> _locationController =
      StreamController<UserLocation>();

  Stream<UserLocation> get locationStream => _locationController.stream;

  LocationService() {
    // Request permission to use location
    location.requestPermission().then((permissionStatus) {
      if (permissionStatus == PermissionStatus.granted) {
        // If granted listen to the onLocationChanged stream and emit over our controller
        location.onLocationChanged.listen((LocationData locationData) {
          if (locationData.latitude != null && locationData.longitude != null) {
            _locationController.add(UserLocation(
              latitude: locationData.latitude!,
              longitude: locationData.longitude!,
            ));
          }
        });
      }
    });
  }

  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude!,
        longitude: userLocation.longitude!,
      );
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }

    return _currentLocation!;
  }
}

void main() {
  runApp(const MyApp());
}

class UserLocation {
  final double? latitude;
  final double? longitude;

  UserLocation({this.latitude, this.longitude});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserLocation>(
      create: (context) => LocationService().locationStream,
      initialData: UserLocation(latitude: null, longitude: null),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const Scaffold(
            body: HomeView(),
          )),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);
    return Center(
      child: Text(
          'Location: Lat${userLocation.latitude}, Long: ${userLocation.longitude}'),
    );
  }
}
