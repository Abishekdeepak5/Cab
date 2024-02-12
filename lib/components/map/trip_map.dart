import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mao/api/cab_service.dart';
import 'package:google_mao/api/image_api.dart';
import 'package:google_mao/api/trip_api_service.dart';
import 'package:google_mao/components/constants.dart';
import 'package:google_mao/components/map/map_methods.dart';
import 'package:google_mao/provider/stateprovider.dart';
import 'package:location/location.dart';
import 'dart:math' show asin, atan2, cos, pi, sin, sqrt;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:floating/floating.dart';
// import 'package:geolocator/geolocator.dart';

class LocationTrack extends StatefulWidget {
  const LocationTrack({super.key});

  @override
  State<LocationTrack> createState() => _LocationTrackState();
}

class _LocationTrackState extends State<LocationTrack>  with WidgetsBindingObserver {
  Location location = Location();
  Completer<GoogleMapController> _mapController =Completer<GoogleMapController>();
  late GoogleMapController? googleMapController;
  bool? serviceEnabled;
  PermissionStatus? permissionGranted;
  LocationData? _locationData;
  LatLng? currentLocation;
  StreamSubscription<LocationData>? locationSubscription;
  bool isCameraFollow=true;
  List<LatLng> polylineCoordinates = [];
  String currentAddress = '';
  double totalDistance = 0;
  StateProvider? myProvider;
  String fullAddress = "";
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  double markerAngle=0;
  final floating = Floating();

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
  double speed=0;
  BuildContext? context1;
  bool isDisplaySpeed=true;

  @override
  void initState() {
    loadContent();
    getInitialLocation();
     setCustomMarkerIcon();
     setLoad(false);   
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    //  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.white,
    //   statusBarIconBrightness: Brightness.light, // Set this based on your content color
    // ));
    super.initState();
  }

  @override
  void dispose() {
    totalDistance = 0;
    currentAddress = '';
    polylineCoordinates = [];
    locationSubscription?.cancel();
    _mapController = Completer<GoogleMapController>();
    WidgetsBinding.instance.removeObserver(this);
    floating.dispose();
     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);

    // setLoad(false);
    // stopListening();
    // endTrip();
    super.dispose();
  }
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState lifecycleState) async {
    if (lifecycleState == AppLifecycleState.inactive) {
      floating.enable(aspectRatio: Rational.square());
      isDisplaySpeed=false;
      if(mounted){setState((){});};
    }
    else if(lifecycleState== AppLifecycleState.resumed){
      isDisplaySpeed=true;
      if(mounted){setState((){});};
    }
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
    return Scaffold(
      body: WillPopScope(
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
              ): Stack(
                  children: [
                    SafeArea(
                      child: Center(
                        child: Container(
                          child: Column(
                            children:[ 
                               Expanded(
                                 child: Screenshot(
                                    controller: screenshotController,
                                    child:PiPSwitcher(
                                      childWhenEnabled: googleMapWidget(),
                                      childWhenDisabled :GoogleMap(
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
                                    ),
                                 ),
                               ),]
                          ),
                        ),
                      ),
                    ),
                    
                    
                    if(isDisplaySpeed)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Container(
                              //   height: 50,
                              //   width:50,
                              //   color: Colors.red,
                              //   child:Text('Hello'),
                              // ),
                      
                      
                             Container(
                        width:50,
                        height: 60,
                        decoration:  const BoxDecoration(
                          shape: BoxShape.circle,
                          // shape:BoxShape.rectangle.
                          color: Color(0xFFF5667A), // Change the color as needed
                        ),
                        child:Center(child: 
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${(speed).toStringAsFixed(0)}',
                            style: const TextStyle( fontWeight: FontWeight.bold,
                                             color: Colors.white,
                                             fontSize: 20)),
                            const Text('Km/h',
                            style: TextStyle(
                                             color: Colors.white,
                                             fontSize: 13),), 
                          ],
                        )),
                                      ),
                      
                            ],
                          ),
                        const SizedBox(height: 100,),
                        ],
                      ),
                    ),
                    if(isDisplaySpeed)
                    bottomDetailsSheet(),
                   if(isLoading)
                    LoadingOverlay(),
                  ]
                ), 
              ),
              ),
      );
  }
  
  Widget googleMapWidget(){
    return GoogleMap(
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
  },);            
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
            focusLocation();
           
          });}
    getAddress();
    getLiveLocation();

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
      setState((){});
    }
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
    double dist=0;
    double timeInSeconds=0;
     const double MIN_DISTANCE_THRESHOLD = 0.05; 
// const int MIN_POLYLINE_POINTS = 2;
LocationData? previousLocation;
  //  LatLng? previousLatLng;
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
      dist=previousLocation!=null ?calculateLocationDistance(LatLng(previousLocation!.latitude!,previousLocation!.longitude!),currentLocation!):0;
      timeInSeconds = previousLocation!=null ?(updatedLocation.time! - previousLocation!.time!):0;
      speed =double.parse((dist*1000 / (timeInSeconds/3600)).toStringAsFixed(0));
      var isLatitudeExist = polylineCoordinates
          .where((element) => element.latitude == updatedLocation.latitude);
      var isLongitudeExist = polylineCoordinates
          .where((element) => element.longitude == updatedLocation.longitude);

  if (updatedLocation.latitude != currentLocation!.latitude &&
  updatedLocation.longitude != currentLocation!.longitude &&
  isLatitudeExist.isEmpty &&
  isLongitudeExist.isEmpty) {
    currentLocation=LatLng(updatedLocation.latitude!,updatedLocation.longitude!);
    int len=polylineCoordinates.length;
    if(polylineCoordinates.length>=2){
      if(mounted){
        setState((){
          markerAngle=calculateBearing(polylineCoordinates[len-2],polylineCoordinates[len-1]);
        });
      }
    }
    if(isStart){
      if(polylineCoordinates.isNotEmpty){
          dist=calculateLocationDistance(polylineCoordinates[len-1],currentLocation!);
          if(dist>MIN_DISTANCE_THRESHOLD){
            // if(speed<10 && polylineCoordinates.length>=3){
            //   if(calculateLocationDistance(polylineCoordinates[len-3],currentLocation!)>(MIN_DISTANCE_THRESHOLD+0.05)){
            //     drawPolyLine(updatedLocation.latitude!, updatedLocation.longitude!);
            //   }
            //   else{
            //     polylineCoordinates.removeAt(len-1);
            //     polylineCoordinates.removeAt(len-2);
            //   }
            // }
                drawPolyLine(updatedLocation.latitude!, updatedLocation.longitude!);
            // else{
            // }
          }
      }
      else{
        drawPolyLine(updatedLocation.latitude!, updatedLocation.longitude!);
      }
    }
    else{
      getAddress();
      }
  }
  else{
      getAddress();
  }
          previousLocation=updatedLocation;
          if(mounted){setState(() {});}
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
          positionParam: LatLng(currentLocation!.latitude, currentLocation!.longitude), 
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

  Widget bottomDetailsSheet() { 
    return DraggableScrollableSheet( 
      initialChildSize: .13, 
      minChildSize: .13, 
      maxChildSize: .6, 
      
      builder: (BuildContext context, ScrollController scrollController) { 
        
        return Container( 
           decoration: BoxDecoration(
              color: Colors.brown[100],
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            // child:const Center(child: Text('Abishek'))
            // isStart?
            // ElevatedButton(onPressed: onPressed, child: child):ElevatedButton(onPressed: onPressed, child: child),
          // color: lightPink, 
          child:ListView( 
            controller: scrollController, 
            children: [ 
              isStart?
              ListTile( 
                 leading: IconButton(
              icon: Icon(Icons.cancel,size: 50),
              onPressed: ()async{
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
                         bool value=await cabService.endCab(Provider.of<StateProvider>(context,listen: false).Token,Provider.of<StateProvider>(context,listen: false).carId,fullAddress,totalDistance * 2.66,totalDistance);
                         bool isImageUpload= await sendUpdatedImage(capturedImage!,context,Provider.of<StateProvider>(context,listen: false).Token);
                          if(!isImageUpload){
                            isImageUpload= await sendUpdatedImage(capturedImage!,context,Provider.of<StateProvider>(context,listen: false).Token);
                          }
                          if(isImageUpload && value){
                          // if(value){
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
                        PopUpMessage.displayMessage(context, 'Try Again  $isImageUpload && $value',3);
                        }
                    }).catchError((onError) {
                      setLoad(false);
                      PopUpMessage.displayMessage(context, 'Try Again $onError',3);
                    });
                    }
                    else{
                      setLoad(false);
                      PopUpMessage.displayMessage(context, 'Try Again 2',3);
                    }}
                    catch(err){
                    setLoad(false);
                    PopUpMessage.displayMessage(context, 'Try Again $err',3);
                  }                
              },
                ),
                title: Center(
                  child: Text( 
                    "${totalDistance.toStringAsFixed(1)} miles", 
                  ),
                ), 
                subtitle: Center(
                  child: Text( 
                    "\$${(totalDistance * 2.66).toStringAsFixed(1)}", 
                  ),
                ),  
                  trailing: IconButton(
              icon: Icon(FontAwesomeIcons.mapLocation,size:30),
            onPressed: (){
              changeCameraAction(false);
              updateCameraBounds(context);
    
            },
      ),
              ):
              ListTile( 
                title: Center(
                  child:ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.green[800],
                      ),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 40,
                        ),
                      ),
                      shape: MaterialStateProperty.all(CircleBorder()
    
                        // RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(5),
                        // ),
                      ),
                    ),
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
                    child: const Text(
                      "Start",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ), 
                // subtitle: Text( "Abishek"), 
              ),
              // Center(child: Text('Abishek'))
              // isStart?SizedBox(height: 20,):SizedBox(height: 25,),
              isStart?SizedBox(height: 38,):SizedBox(height: 25,),
               const Divider(
                height: 1.0,
                color: Colors.grey,
              ),
              ListTile(
                title: Text('Auto Focus'),
                trailing:   Switch(
                                   value: isCameraFollow,  
                                   activeColor: Colors.blue,  
                                   activeTrackColor: lightPink,  
                                   inactiveThumbColor: Colors.redAccent,  
                                   inactiveTrackColor: lightPink, 
                                   onChanged: (bool value) { 
                                    changeCameraAction(value);
                                    },  
                                   ) ,
              ),
              const Divider(
                height: 1.0,
                color: Colors.grey,
              ),
              // const ListTile(
              //   title: Text('Address'),
              //   subtitle: Text('bbiisxwjnxwjnjwnjwnjwnjnnwjwxwww'),
              // ) ,
              ListTile(
                title:Text('Address:'),
            subtitle: Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(fullAddress.replaceAll(',', ',\n')
                   ,softWrap: true,style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            trailing: IconButton(icon: Icon(Icons.refresh),onPressed: (){
              getAddress();
            },),
          ),
          
               
            ], 
          ), 
        ); 
      }, 
    ); 
  }
  Future<void> enablePip(BuildContext context) async {
    final rational = Rational.landscape();
    final screenSize =
        MediaQuery.of(context).size * MediaQuery.of(context).devicePixelRatio;
    final height = screenSize.width ~/ rational.aspectRatio;

    final status = await floating.enable(
      aspectRatio: rational,
      sourceRectHint: Rectangle<int>(
        0,
        (screenSize.height ~/ 2) - (height ~/ 2),
        screenSize.width.toInt(),
        height,
      ),
    );
    debugPrint('PiP enabled? $status');
  }
}

// floatingActionButton: Padding(
//                     padding: EdgeInsets.only(left: 20.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                     width:50,
//                     height: 60,
//                     decoration:  BoxDecoration(
//                       //  borderRadius: BorderRadius.all(
//                       //   Radius.circular(50.0)),
//                       shape: BoxShape.circle,
//                       // shape:BoxShape.rectangle.
//                       color: Color(0xFFF5667A), // Change the color as needed
//                     ),
//                     child:Center(child: 
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text('${(speed).toStringAsFixed(0)}',
//                         style: TextStyle( fontWeight: FontWeight.bold,
//                                          color: Colors.white,
//                                          fontSize: 20)),
//                         Text('Km/h',
//                         style: TextStyle(
//                                          color: Colors.white,
//                                          fontSize: 13),), 
//                       ],
//                     )),
//                 ),
//                 // RichText(
//                 //                 text: TextSpan(
//                 //                   style: const TextStyle(color: Colors.black,
//                 //                     ),
//                 //                   children: <TextSpan>[
//                 //                     TextSpan(
//                 //                       text: '${(speed).toStringAsFixed(0)}',
//                 //                       style: TextStyle( fontWeight: FontWeight.bold,
//                 //                         color: pinkColor,)
//                 //                     ),
//                 //                    const TextSpan(text: 'Km/h',),
                                    
//                 //                     ],
//                 //                 ),),
//                 FloatingActionButton(
//               onPressed: () {
//                  setLoad(false);
//                 // focusLiveLocation();
//                 changeCameraAction(false);
//                 updateCameraBounds(context);
//                 // var dist=calculateLocationDistance(LatLng(_sourceMarker.position.latitude, _sourceMarker.position.longitude),LatLng(_destinationMarker.position.latitude,_destinationMarker.position.longitude));
//                 // PopUpMessage.displayMessage(context, '$dist', 5);
//               },
//               child: const Icon(Icons.location_searching),
//                 ),],),)