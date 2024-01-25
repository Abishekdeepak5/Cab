import 'package:flutter/material.dart';
import 'package:google_mao/api/user_api.dart';
import 'package:google_mao/components/History/trip_image.dart';
import 'package:google_mao/components/History/triphistory.dart';
import 'package:google_mao/components/map/screenshot_map.dart';
import 'package:google_mao/provider/stateprovider.dart';
import 'package:google_mao/ui/drawer/drawer.dart';
import 'package:google_mao/ui/passengerDetailPage/cabconstriant.dart';
import 'package:google_mao/ui/signin.dart';
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
    // checkToken(context);
  }
  final List<Widget> _pages = [
    CabContriant(),
    TripHistory(),
    MyHomePage(title: 'Screenshot Demo Home Page'),
    // ImageDisplay(imageId: 177),
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


      body:WillPopScope(
         onWillPop: () => _onWillPop(context),
      child: _pages[pageindex >= _pages.length?0:pageindex]
      ),
      // body:,
    );
    
  }
// Future<void> checkToken(BuildContext context)async {
//           String token=Provider.of<StateProvider>(context).Token;
//           if(token!=""){
//             bool isValid=await user.checkToken(token);
            
//             if(!isValid){
//                Navigator.pushReplacement(context,
//               MaterialPageRoute(builder: (context) => SignInPage()),
//             );
//             }
//             print(token);
            
//           }
//           else{
//              Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const SignInPage()),
//             );
//           }
//    }
 
  Future<bool> _onWillPop(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to exit?'),
          content: Text('Pressing back again will close the app.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false to cancel the pop.
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true to allow the pop.
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
