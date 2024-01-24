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

class LocationTrack extends StatefulWidget {
  const LocationTrack({super.key});

  @override
  State<LocationTrack> createState() => _LocationTrackState();
}

class _LocationTrackState extends State<LocationTrack> {
  Location location = Location();
  Completer<GoogleMapController> _mapController =Completer<GoogleMapController>();
  late GoogleMapController? googleMapController;
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
  double latitude1 = 37.7749; // Replace with the actual latitude
  double longitude1 = -122.4194; // Replace with the actual longitude
  StateProvider? myProvider;
  String fullAddress = "";
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  double markerAngle=0;

  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  bool showRefreshButton = false;
  bool isStart=false;
   List<LatLng> coordinates = []; // List to store latitude and longitude coordinates
  
  final TripApiService tripService = TripApiService();
  final CabApiService cabService=CabApiService();
   bool isLoading=false;
  ScreenshotController screenshotController = ScreenshotController();
   Marker _sourceMarker=Marker(markerId: MarkerId("source"));
  Marker _destinationMarker = Marker(markerId: MarkerId("destination"));
  late BuildContext context1;

  @override
  void initState() {
    loadContent();
    getInitialLocation();
     setCustomMarkerIcon();
     setLoad(false);
    super.initState();
  }

  @override
  void dispose() {
    totalDistance = 0;
    currentAddress = '';
    polylineCoordinates = [];
    locationSubscription?.cancel();
    _mapController = Completer<GoogleMapController>();
    // setLoad(false);
    // stopListening();
    // endTrip();
    super.dispose();
  }
  void setLoad(bool val){
    if(mounted){
    setState((){
        isLoading=val;
    });}
    }
 Future<void> loadContent() async {
    getInitialLocation();
    await Future.delayed(Duration(seconds: 3));
    if(mounted){
    setState(() {
      showRefreshButton = true;
    });}
  }
  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/car.jpg")
        .then(
      (icon) {
        currentLocationIcon = icon;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    context1=context;
    myProvider=Provider.of<StateProvider>(context,listen: false);
    return WillPopScope(
      onWillPop: () async{ 
        if(!isStart){
          Navigator.of(context).pop();
          return true;
        }
        else{
          return false;
        }
       },
      child: Scaffold(
        body: _locationData == null
            ? SafeArea(  
              child: Center(
                child:showRefreshButton
              ? ElevatedButton(
                  onPressed: () {
                    // Add your refresh logic here
                    if(mounted){
                    setState(() {
                      showRefreshButton = false;
                    });}
                    // Optionally, you can trigger content loading again
                    loadContent();
                  },
                  child: Text("Refresh"),
                ):CircularProgressIndicator(),
              ),
            )
            : Stack(
              children: [Screenshot(
                 controller: screenshotController,
                child: SafeArea(
                  child: Center(
                    child: Container(
                      color:Colors.white,
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
                                  isStart?
                                  ElevatedButton(
                                  style:ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                  onPressed: () async{
                                    try{
                                       setLoad(true);
                                       changeCameraAction(false);
                                      bool isCameraBound=await updateCameraBounds(context);
                                      bool val=await getAddress();
                                      await Future.delayed(const Duration(seconds: 1));
                                      if(val && isCameraBound){
                                       screenshotController
                                      .capture(delay: Duration(milliseconds: 10))
                                      .then((capturedImage) async {
                                          //  bool isImageUpload= await sendUpdatedImage(capturedImage!,context,Provider.of<StateProvider>(context,listen: false).Token);
                                           bool value=await cabService.endCab(Provider.of<StateProvider>(context,listen: false).Token,Provider.of<StateProvider>(context,listen: false).carId,fullAddress,totalDistance * 2.66);
                                            // if(isImageUpload && value){
                                            if(value){
                                              locationSubscription?.cancel();
                                              bool val1=await endTrip();
                                              if(val1){
                                                // googleMapController.dispose();
                                                 googleMapController=null;
                                                _mapController = Completer<GoogleMapController>();
                                              setLoad(false);
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                          }}
                                          else{
                                          setLoad(false);
                                          PopUpMessage.displayMessage(context, 'Try Again',3);
                                          }
                                      }).catchError((onError) {
                                        setLoad(false);
                                        PopUpMessage.displayMessage(context, 'Try Again',3);
                                        print(onError);
                                      });
                                      // bool value=await cabService.endCab(Provider.of<StateProvider>(context,listen: false).Token,Provider.of<StateProvider>(context,listen: false).carId,fullAddress,totalDistance * 2.66);
                                      // if(val && value){
                                      //   locationSubscription?.cancel();
                                      //   bool val1=await endTrip();
                                      //   if(val1){
                                      //     // googleMapController.dispose();
                                      //      googleMapController=null;
                                      //     _mapController = Completer<GoogleMapController>();
                                      //   setLoad(false);
                                      //   Navigator.of(context).pop();
                                      //   Navigator.of(context).pop();
                                      //   }
                                      // }
                                      }
                                      else{
                                        setLoad(false);
                                        PopUpMessage.displayMessage(context, 'Try Again',3);
                                      }}
                                      catch(err){
                                      setLoad(false);
                                      PopUpMessage.displayMessage(context, 'Try Again $err',3);
                                    }
                                     },
                                  child: const Text("End",
                                      style: TextStyle(color: Colors.white)),
                                                    )
                                   :
                                  ElevatedButton(
                                  style:ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                  onPressed: () async{
                                    setLoad(true);
                                    await updateAddress(context).then((value) {
                                      if(value){
                                        if(mounted){
                                      setState((){
                                        isStart=true;
                                      });}
                                      currentLocation == null ?getInitialLocation(): getLiveLocation();
                                      setLoad(false);
                                      }
                                      else{
                                        setLoad(false);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("Press Again"),
                                            duration: Duration(seconds: 3),
                                          ),
                                        );
                                      }
                                    }
                                    );
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
                            
                              Column(
                                children:[
                                   SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        ElevatedButton(
                                        style:ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                        onPressed: () {
                                            getAddress();
                                           },
                                        child: const Text("Address",
                                            style: TextStyle(color: Colors.white)),
                                                          ),
                                  RichText(
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                  style: const TextStyle(color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                  // TextSpan(text: 'Address: ', style: TextStyle(
                                  //     fontWeight: FontWeight.bold,
                                  //     color: pinkColor,
                                  //   ),
                                  //   ),
                                    TextSpan(
                                    text: fullAddress,
                                    
                                    ),
                                  ],
                              ),),
                                      ],
                                    ),
                                  ),
                                ]
                        
                              ),
                            Column(
                              children: [
                            SizedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                        
                                RichText(
                              text: TextSpan(
                                style:  const TextStyle(color: Colors.black,
                                  ),
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
                                style: const TextStyle(color: Colors.black,
                                  ),
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
                              ],
                            ),
                        
                        
                            // Text("$fullAddress"),
                           Expanded(
                             child: GoogleMap(
                              onTap: (LatLng location) {
                                //  _destinationMarker = _destinationMarker.copyWith(
                                //         positionParam: LatLng(location.latitude, location.longitude), // Default destination location
                                //      );
                                   },
                                      onMapCreated: ((GoogleMapController controller) => _mapController.complete(controller)),
                                        initialCameraPosition:CameraPosition(
                                          target:LatLng(currentLocation!.latitude,currentLocation!.longitude),
                                          zoom:13) ,
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
                                  icon: currentLocationIcon,
                                  position: currentLocation!,
                                  rotation: markerAngle,
                                ),
                                _sourceMarker,
                                  _destinationMarker,
                                },
                                 
                                // onCameraMove: _cameraMove,
                                             ),
                           ),]
                      ),
                    ),
                  ),
                ),
              ),
               if(isLoading)
                LoadingOverlay(),
              ]
            ),
          
          floatingActionButton: FloatingActionButton(
          onPressed: () {
             setLoad(false);
            // focusLiveLocation();
            changeCameraAction(false);
            updateCameraBounds(context);
          //    _sourceMarker = _sourceMarker.copyWith(
          //   positionParam: LatLng(currentLocation!.latitude, currentLocation!.longitude), // Default source location
          // );
          },
          child: const Icon(Icons.location_searching),
        ),
            ),
    );
  }
  
  Future<void> getInitialLocation() async {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled!) {
    _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
           return;
      }
      } 
      _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
       return;
      }
    }
    _locationData = await location.getLocation();
    location.enableBackgroundMode(enable: true);
        if(mounted){
        setState(() {
            currentLocation =LatLng(_locationData!.latitude!, _locationData!.longitude!);
            _pGooglePlex=currentLocation!;
            focusLocation();
           
          });}
    getAddress();
    getLiveLocation();

  }

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



   void drawPolyLine(latitude, longitude) {
    polylineCoordinates.add(LatLng(latitude, longitude),);
    totalDistance=0;
    for (var i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance+= calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude);
    }
    if(mounted){
      setState(() {});}
  }
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 0.62137119;
  }
  Future<void> getLiveLocation() async {
    polylineCoordinates = [];
//     const double MIN_DISTANCE_THRESHOLD = 5.0; // Adjust as needed
// const int MIN_POLYLINE_POINTS = 2;
// LocationData? previousLocation;
// LatLng? previousLatLng;
    GoogleMapController googleMapController = await _mapController.future;
    locationSubscription = location.onLocationChanged.handleError((onError) {
     locationSubscription?.cancel();
     if(mounted){
      setState(() {
        locationSubscription = null;
      });}
    }).listen((LocationData updatedLocation) {
      if(isCameraFollow && mounted){
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
      //  LatLng currentLatLng = LatLng(updatedLocation.latitude!, updatedLocation.longitude!);

       
      // updateLatLng(LatLng(updatedLocation.latitude!,updatedLocation.longitude!));
      // if (previousLocation != null &&
      //   Geolocator.distanceBetween(
      //     previousLatLng!.latitude,
      //     previousLatLng!.longitude,
      //     currentLatLng.latitude,
      //     currentLatLng.longitude) < MIN_DISTANCE_THRESHOLD) {
      //     return;
      //  }
          // PopUpMessage.displayMessage(context1, 'Hello', 1);

      var isLatitudeExist = polylineCoordinates
          .where((element) => element.latitude == updatedLocation.latitude);
      var isLongitudeExist = polylineCoordinates
          .where((element) => element.longitude == updatedLocation.longitude);
      if (updatedLocation.latitude != currentLocation!.latitude &&
          updatedLocation.longitude != currentLocation!.longitude &&
          isLatitudeExist.isEmpty &&
          isLongitudeExist.isEmpty) {
            
      currentLocation=LatLng(updatedLocation.latitude!,updatedLocation.longitude!);
      if(polylineCoordinates.length>=2){
        int len=polylineCoordinates.length;
        if(mounted){
        setState((){
        markerAngle=calculateBearing(polylineCoordinates[len-2],polylineCoordinates[len-1]);
        });
        }
      }
      if(isStart){
        drawPolyLine(updatedLocation.latitude!, updatedLocation.longitude!);
      }
      else{
        getAddress();
      }
          }
      });

  }

  Future<void> focusLocation() async {
    googleMapController = await _mapController.future;
    googleMapController?.animateCamera(
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
    if(mounted){
    setState((){});}
  }
  
  Future<bool> getAddress() async {
    try {
      List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(currentLocation!.latitude, currentLocation!.longitude);
      //  List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(11.082428307352208, 79.42625295720761);

      if (placemarks != null && placemarks.isNotEmpty) {
        geocoding.Placemark firstPlacemark = placemarks.first;
        if(mounted){
        setState((){
        fullAddress = "${firstPlacemark.subThoroughfare} ${firstPlacemark.thoroughfare}, "
            "${firstPlacemark.locality}, ${firstPlacemark.administrativeArea} "
            "${firstPlacemark.postalCode}, ${firstPlacemark.country}";
        });}
        return true;
      } else {
        getInitialLocation();
        // fullAddress = "No address found";
        return false;
      }
    } catch (e) {
      print("Error getting address: $e");
      // fullAddress = "Error getting address";
        return false;
    }
  }

  Future<bool> updateAddress(BuildContext context) async{
    bool val=await getAddress();
    bool isUpdate=await cabService.startAddress(myProvider!.Token, myProvider!.carId, fullAddress);
    _sourceMarker = _sourceMarker.copyWith(
            positionParam: LatLng(currentLocation!.latitude, currentLocation!.longitude), 
          );
    _destinationMarker = _destinationMarker.copyWith(
            positionParam: LatLng(currentLocation!.latitude, currentLocation!.longitude), 
          );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? tripId=prefs.getInt('tripId');
    myProvider!.testing('$tripId');
    myProvider!.setTripId(tripId!);
    return val && isUpdate;
  }

 
  void focusLiveLocation() {
    focusLocation();
    isCameraFollow=true;
   
  }

 
  
  stopListening() {
    locationSubscription?.cancel();
    if(mounted){
    setState(() {
      locationSubscription = null;
    });}
  }

 Future<bool> endTrip() async{
    stopListening();
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }


  void changeCameraAction(bool val) {
   if(mounted){ setState(() {
      isCameraFollow=val;
    });}
  }  

  Future<bool> updateCameraBounds(BuildContext context) async {
    try{
      _destinationMarker = _destinationMarker.copyWith(
                                        positionParam: LatLng(currentLocation!.latitude, currentLocation!.longitude), // Default destination location
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
    googleMapController = await _mapController.future;
    googleMapController?.animateCamera(cameraUpdate);
    }catch(err){
      PopUpMessage.displayMessage(context, '$err', 3);
        return false;
    }

    return true;
  }
}

