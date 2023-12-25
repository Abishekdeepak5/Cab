import 'package:flutter/material.dart';
import 'package:google_mao/ui/signin.dart';

class AssociatedCabs extends StatefulWidget {
  @override
  AssociatedCabsState createState() => AssociatedCabsState();
}

class AssociatedCabsState extends State<AssociatedCabs> {
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
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.topCenter,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(
                    255, 44, 105, 46), // Set button color to green
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                        0), // Set border radius to 0 for rectangular shape
                  ),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  'Start Trip',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('cab', style: TextStyle(fontSize: 20)),
          const Text('6666', style: TextStyle(fontSize: 30)),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        color: Colors.blue,
        child: const Text(
          'MeterPro',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
