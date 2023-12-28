import 'package:flutter/material.dart';
import 'package:google_mao/ui/drawer/drawer.dart';
import 'package:google_mao/ui/passengerDetailPage/inputWidget.dart';
import 'package:google_mao/ui/signin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//    int _currentIndex = 0;

//   final List<Widget> _pages = [
//     TripHistoryPage(),
//     (),
//     Page3(),
//   ];
  @override
  Widget build(BuildContext context) {
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
              size: 28,
            ),
          ),
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(
          //     Icons.output_outlined,
          //     size: 28,
          //   ),
          // ),

        ],

      ),
      // drawer
      drawer: const MyDrawer(),


      // parent column for this page
      body: Padding(
        padding: const EdgeInsets.only(right: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 50, right: 40),
              child: Column(
                children: [
                  SizedBox(height: 100.0),
                  InputWidget(
                    prefixText: "Passenger :",
                    limit: 4,
                  ),
                  InputWidget(
                    prefixText: "Grocery Bags :",
                    limit: 10,
                  ),
                  InputWidget(
                    prefixText: "Laundry Bags :",
                    limit: 10,
                  ),
                ],
              ),
            ),

            // start trip button

            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.green[800],
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(
                      vertical: 25,
                      horizontal: 50,
                    ),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                onPressed: () {
                  print("start Trip");
                },
                child: const Text(
                  "Start Trip",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
