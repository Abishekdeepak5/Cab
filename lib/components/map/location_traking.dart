import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class LocationTracking extends StatefulWidget {
  const LocationTracking({Key? key}) : super(key: key);
  @override
  State<LocationTracking> createState() => LocationTrackingState();
}

class LocationTrackingState extends State<LocationTracking> {
  double totalDistance = 0;
  String? currentAddress = '';
  LocationData? currentLocation = null;
  final Location location = Location();
  List<LatLng> polylineCoordinates = [];
  StreamSubscription<LocationData>? locationSubscription;
  final Completer<GoogleMapController> _controller = Completer();

  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/car.jpg")
        .then(
      (icon) {
        currentLocationIcon = icon;
      },
    );
  }

  void drawPolyLine(latitude, longitude) {
    polylineCoordinates.add(
      LatLng(latitude, longitude),
    );
    for (var i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude);
    }
    setState(() {});
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 0.62137119;
  }

  getLocation() async {
    try {
      currentLocation = null;
      currentLocation = await location.getLocation();
      getAddress();
      focusToCurrentLocation();
    } catch (e) {
      print(e);
    }
  }

  focusToCurrentLocation() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 13.5,
          target: LatLng(
            currentLocation!.latitude!,
            currentLocation!.longitude!,
          ),
        ),
      ),
    );
  }

  Future<void> getAddress() async {
    await geocoding
        .placemarkFromCoordinates(
            currentLocation!.latitude!, currentLocation!.longitude!)
        .then((List<geocoding.Placemark> placemarks) {
      geocoding.Placemark place = placemarks[0];
      setState(() {
        currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> listenLocation() async {
    polylineCoordinates = [];
    GoogleMapController googleMapController = await _controller.future;
    locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      locationSubscription?.cancel();
      setState(() {
        locationSubscription = null;
      });
    }).listen((LocationData updatedLocation) {
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 13.5,
            target: LatLng(
              updatedLocation.latitude!,
              updatedLocation.longitude!,
            ),
          ),
        ),
      );
      var isLatitudeExist = polylineCoordinates
          .where((element) => element.latitude == updatedLocation.latitude);
      var isLongitudeExist = polylineCoordinates
          .where((element) => element.longitude == updatedLocation.longitude);
      if (updatedLocation.latitude != currentLocation!.latitude &&
          updatedLocation.longitude != currentLocation!.longitude &&
          isLatitudeExist.isEmpty &&
          isLongitudeExist.isEmpty) {
        currentLocation = updatedLocation;
        drawPolyLine(updatedLocation.latitude!, updatedLocation.longitude!);
      }
    });
  }

  stopListening() {
    locationSubscription?.cancel();
    setState(() {
      locationSubscription = null;
    });
  }

  endTrip() {
    stopListening();
  }

  reset() {
    totalDistance = 0;
    currentAddress = '';
    polylineCoordinates = [];
  }

  @override
  void initState() {
    getLocation();
    setCustomMarkerIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "MeterPro",
            style: TextStyle(
                color: Colors.yellow,
                fontSize: 20,
                fontStyle: FontStyle.italic),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Total Miles: ${totalDistance.toStringAsFixed(1)} mi'),
                    const SizedBox(width: 30),
                    Text(
                        'Charge: \$ ${(totalDistance * 2.66).toStringAsFixed(1)}'),
                  ],
                ),
                const SizedBox(height: 30),
                Center(child: Text('Address: $currentAddress')),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: getLocation,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text("Refresh",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: listenLocation,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: const Text("Start",
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 30),
                    ElevatedButton(
                      onPressed: stopListening,
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text("Stop",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                currentLocation == null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Expanded(
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                              target: LatLng(currentLocation!.latitude!,
                                  currentLocation!.longitude!),
                              zoom: 12.5),
                          polylines: {
                            Polyline(
                              polylineId: const PolylineId("route"),
                              points: polylineCoordinates,
                              color: const Color.fromARGB(255, 40, 4, 222),
                              width: 6,
                            ),
                          },
                          markers: {
                            Marker(
                              markerId: const MarkerId("currentLocation"),
                              icon: currentLocationIcon,
                              position: LatLng(currentLocation!.latitude!,
                                  currentLocation!.longitude!),
                            ),
                          },
                          onMapCreated: (mapController) {
                            _controller.complete(mapController);
                          },
                        ),
                      ),
              ],
            ),
          ),
        ));
  }
}
