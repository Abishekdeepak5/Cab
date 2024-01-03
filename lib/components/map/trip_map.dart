import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mao/api/trip_api_service.dart';
import 'package:google_mao/components/constants.dart';
import 'package:google_mao/components/user_crud/update_location.dart';
import 'package:google_mao/models/LocationModel.dart';
import 'package:google_mao/provider/locationprovider.dart';
import 'package:location/location.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:provider/provider.dart';

class LocationTrack extends StatefulWidget {
  const LocationTrack({super.key});

  @override
  State<LocationTrack> createState() => _LocationTrackState();
}

class _LocationTrackState extends State<LocationTrack> {
  Location location = Location();
  final Completer<GoogleMapController> _mapController =Completer<GoogleMapController>();
  bool? serviceEnabled;
  PermissionStatus? permissionGranted;
  LocationData? _locationData;
  LatLng? currentLocation;
  LatLng _pGooglePlex = const LatLng(10.741222, 77.694626);
  StreamSubscription<LocationData>? locationSubscription;
  bool isCameraFollow=true;
  List<LatLng> polylineCoordinates = [];
  String currentAddress = '';
  double totalDistance = 0;

  
  final TripApiService tripService = TripApiService();

  @override
  void initState() {
    
    getInitialLocation();
    super.initState();
  }

  @override
  void dispose() {
    totalDistance = 0;
    currentAddress = '';
    polylineCoordinates = [];
    stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: currentLocation == null
          ? const SafeArea(
            child: Center(
                child: CircularProgressIndicator(),
            ),
          )
          : SafeArea(
            child: Center(
              child: Column(
                children:[
                  Padding(
                      padding: const EdgeInsets.only(top:3,bottom: 3),
                    child: SizedBox(
                      height: 30,
                      child: 
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                          style:ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                          onPressed: () {
                              currentLocation == null ?getInitialLocation(): getLiveLocation();
                            
                             },
                          child: const Text("Start",
                              style: TextStyle(color: Colors.white)),
                                            ),
                        Switch(
                           value: isCameraFollow,  
                           activeColor: Colors.blue,  
                           activeTrackColor: lightPink,  
                           inactiveThumbColor: Colors.redAccent,  
                           inactiveTrackColor: lightPink, 
                           onChanged: (bool value) { 
                            changeCameraAction(value);
                            },  
                           )  ,
                        ],
                      ),
                    ),),
                    // RichText(
                    //   text: TextSpan(
                    //     style: DefaultTextStyle.of(context).style,
                    //     children: <TextSpan>[
                    //      TextSpan(text: 'Address: ', style: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           color: pinkColor,
                    //         ),),
                    //       TextSpan(
                    //         text: currentAddress,
                    //       ),
                    //       ],
                    //   ),),

                    
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                        RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                         TextSpan(text: 'Latitude: ', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: pinkColor,
                            ),),
                          TextSpan(
                            text: '${Provider.of<getLatitudeLongitude>(context).latitude}',
                          ),
                          ],
                      ),),
                      RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                         TextSpan(text: 'Longitude: ', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: pinkColor,
                            ),),
                          TextSpan(
                            text: '${Provider.of<getLatitudeLongitude>(context).longitude}',
                          ),
                          ],
                      ),), 
                        ],
                      ),
                    ),


                      
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                        RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                         TextSpan(text: 'Total Miles: ', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: pinkColor,
                            ),),
                          TextSpan(
                            text: '${totalDistance.toStringAsFixed(1)} mi',
                          ),
                          ],
                      ),),
                      RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                         TextSpan(text: 'Charge: ', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: pinkColor,
                            ),),
                          TextSpan(
                            text: '\$${(totalDistance * 2.66).toStringAsFixed(1)}',
                          ),
                          ],
                      ),),
                          // Text('Total Miles: ${totalDistance.toStringAsFixed(1)} mi'),
                          //  Text('Charge: \$ ${(totalDistance * 2.66).toStringAsFixed(1)}'),
                  

                        ],
                      ),
                    ),

                   Expanded(
                     child: GoogleMap(
                              onMapCreated: ((GoogleMapController controller) => _mapController.complete(controller)),
                                initialCameraPosition:CameraPosition(
                                  target:LatLng(currentLocation!.latitude,currentLocation!.longitude),
                                  zoom:13) ,
                                  // onCameraMove: (pos){
                                    // isCameraFollow=false;
                                    // print("Hello ${pos.target}");
                                  // }, 
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
                          markerId: const MarkerId("_currentLocation"),
                          icon: BitmapDescriptor.defaultMarker,
                          position: currentLocation!,
                        ),},
                                     ),
                   ),]
              ),
            ),
          ),
        
        floatingActionButton: FloatingActionButton(
        onPressed: () {
          focusLiveLocation();
        },
        child: const Icon(Icons.location_searching),
      ),
          );
  }
  
  Future<void> getInitialLocation() async {
    
        _locationData = await location.getLocation();
        setState(() {
            currentLocation =LatLng(_locationData!.latitude!, _locationData!.longitude!);
            _pGooglePlex=currentLocation!;
            focusLocation();
           
          });
         
          //  try{
          //   getAddress();
          //   }catch(err){
          //     print(err);
          //   }

  }


  Future<void> getLiveLocation() async {
    polylineCoordinates = [];
    GoogleMapController googleMapController = await _mapController.future;
    locationSubscription = location.onLocationChanged.handleError((onError) {
     locationSubscription?.cancel();
      setState(() {
        locationSubscription = null;
      });
    }).listen((LocationData updatedLocation) {
      if(isCameraFollow){
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 16.5,
            target: LatLng(
              updatedLocation.latitude!,
              updatedLocation.longitude!,
            ),
          ),
        ),
      );}
      updateLatLng(LatLng(updatedLocation.latitude!,updatedLocation.longitude!));

      var isLatitudeExist = polylineCoordinates
          .where((element) => element.latitude == updatedLocation.latitude);
      var isLongitudeExist = polylineCoordinates
          .where((element) => element.longitude == updatedLocation.longitude);
      if (updatedLocation.latitude != currentLocation!.latitude &&
          updatedLocation.longitude != currentLocation!.longitude &&
          isLatitudeExist.isEmpty &&
          isLongitudeExist.isEmpty) {
            
      currentLocation=LatLng(updatedLocation.latitude!,updatedLocation.longitude!);
          drawPolyLine(updatedLocation.latitude!, updatedLocation.longitude!);
      
          }
      });

  }

  Future<void> updateLatLng(LatLng loc) async {
    Trip trip = Trip(id: 3, latitude:loc.latitude,longitude:loc.longitude);
    tripService.updateLocations(trip);

  }

  Future<void> focusLocation() async {
    GoogleMapController googleMapController = await _mapController.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 13.5,
          target: LatLng(
            currentLocation!.latitude,
            currentLocation!.longitude,
          ),
        ),
      ),
    );
    setState((){});
  }
  
  Future<void> getAddress() async {
    await geocoding
        .placemarkFromCoordinates(
            currentLocation!.latitude, currentLocation!.longitude)
        .then((List<geocoding.Placemark> placemarks) {
      geocoding.Placemark place = placemarks[0];
      setState(() {
        currentAddress ='${place.street}, ${place.subLocality}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }
   double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 0.62137119;
  }
  void focusLiveLocation() {
    focusLocation();
    isCameraFollow=true;
   
  }

  void drawPolyLine(latitude, longitude) {
    polylineCoordinates.add(LatLng(latitude, longitude),);
    for (var i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude);
    }
    setState(() {});
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


  void changeCameraAction(bool val) {
    setState(() {
      isCameraFollow=val;
    });
  }  
}

