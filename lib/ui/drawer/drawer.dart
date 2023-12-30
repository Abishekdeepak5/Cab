import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mao/provider/drawerprovider.dart';
import 'package:provider/provider.dart';



class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  int _selectedIndex=-1;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: ListView(
        padding: const  EdgeInsets.all(0),
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 32.0),
              color: Colors.white,
              child: Column(children: [
                CircleAvatar(
                  minRadius: 40,
                  backgroundColor: Colors.pink.shade300,
                  child: const Text(
                    "A",
                    style: TextStyle(fontSize: 30.0, color: Colors.blue),
                  ),
                ),
                const Text( "Avecsage"),
                const Text("Avecsage@gmail.com"),
              ]),
            ),
          buildListTile(0,context,Icons.home, 'Home'),
          buildListTile(1,context,FontAwesomeIcons.squarePollVertical, 'Trip History'),
          buildListTile(2,context,Icons.person, 'Profile'),
          buildListTile(3,context,Icons.favorite, 'Reports'),
          buildListTile(4,context,FontAwesomeIcons.briefcase, 'Status'),
          buildListTile(5,context,Icons.settings, 'Settings'),
        ],
      ),
    );

  }

  ListTile buildListTile(int index,BuildContext context,IconData icon, String title) {
    _selectedIndex=Provider.of<PageChange>(context).pageIndex;
    return ListTile(
      tileColor: _selectedIndex == index ? Colors.pink.withOpacity(0.2) : null,
      leading: Icon(icon
      ,color: _selectedIndex == index ?Colors.pink:null),
      title: Text(title),
      trailing:  Icon(_selectedIndex == index ? FontAwesomeIcons.angleLeft : FontAwesomeIcons.angleRight
      ,size: 18
      ,color: _selectedIndex == index ?Colors.pink:null,),
      onTap: () {
         Provider.of<PageChange>(context,listen:false).changePage(index);
        Navigator.pop(context);
       },
    );
  }
}

//  Future<void> getCurrentLocation() async {
//     _locationData = await location.getLocation();
// print(_locationData?.latitude);
//     if(_locationData!=null){
//       setState(() {
//         print("State");
//         _currentP=LatLng(_locationData!.latitude!, _locationData!.longitude!);
//       });
//     }

//  }


  // void _simulateLocationChange() async {
    // if(_currentP==null){
    //   print("click");
    //   getLocationUpdate();
    // }
    // Simulate location changes
    // for (double lat = 9.9252007, lon =78.1197754; lat <= 37.8049; lat += 0.001, lon += 0.001) {
    //   await Future.delayed(Duration(milliseconds: 1500));
    //   setState(() {
    //     _currentP = LatLng(lat,lon);
    //     _pGooglePlex=_currentP!;
    //   });
    // }
//     }
// }



//permission Get
      // serviceEnabled = await location.serviceEnabled();
        // if (!serviceEnabled!) {
        //   serviceEnabled = await location.requestService();
        //   if (!serviceEnabled!) {
        //     return;
        //   }
        // }

        // permissionGranted = await location.hasPermission();
        // if (permissionGranted == PermissionStatus.denied) {
        //   permissionGranted = await location.requestPermission();
        //   if (permissionGranted != PermissionStatus.granted) {
        //     return;
        //   }
        // }
        

//
    // location.onLocationChanged.listen((LocationData currentLoc) {
       // if (currentLoc.latitude != null &&
       //         currentLoc.longitude != null) {
       //       setState(() {
       //         currentLocation =LatLng(currentLoc.latitude!, currentLoc.longitude!);
       //         _pGooglePlex=currentLocation!;
       //       });
       //     }
       // });

//print

     // for (var element in polylineCoordinates) {
      // ignore: avoid_print
      // print("Hello ${element.latitude} and ${element.longitude}");
      // }
