import 'package:flutter/material.dart';
import 'package:google_mao/Hubs/client_listen.dart';
import 'package:google_mao/api/user_api.dart';
import 'package:google_mao/components/map/location_traking.dart';
import 'package:google_mao/components/map/trip_map.dart';
import 'package:google_mao/components/user_crud/webapi.dart';
import 'package:google_mao/provider/stateprovider.dart';
import 'package:google_mao/ui/drawer/drawer.dart';
import 'package:google_mao/ui/passengerDetailPage/cabconstriant.dart';
import 'package:google_mao/ui/signin.dart';
import 'package:google_mao/ui/trip_history.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

 UserApiService user=UserApiService();
  @override
  void initState(){
    super.initState();
  }
   Future<void> checkToken(BuildContext context)async {
          String token=Provider.of<StateProvider>(context).Token;
          if(token!=""){
            bool isValid=await user.checkToken(token);
            if(!isValid){
               Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => SignInPage()),
            );
            }
            print(token);
            
          }
          else{
             Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignInPage()),
            );
          }
   }
  final List<Widget> _pages = [
    
    // const LocationTracking(),
    // MyStream(),
    // ClientListen()
    // const LocationTrack(),
    // MyHomePagenew(),
    CabContriant(),
    // const TripHistoryPage(),
  ];
  @override
  Widget build(BuildContext context) {
    int pageindex=Provider.of<StateProvider>(context).pageIndex;
    return Scaffold(
      appBar: AppBar(
        // leading icon for seeing the user profile
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              size: 36,
            ),
          );
        }),

        title: const Text(
          "Associated Cabs",
          style: TextStyle(
            color: Colors.orange,
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInPage()),
            );
            },
            icon: const Icon(
              Icons.login,
              // Icons.output_outlined
              size: 28,
            ),
          ),
        ],

      ),
      // drawer
      drawer: const MyDrawer(),


      body:_pages[pageindex >= _pages.length?0:pageindex],
      // body:,
    );
  }
}
