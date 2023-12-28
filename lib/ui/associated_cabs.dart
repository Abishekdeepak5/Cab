import 'package:flutter/material.dart';

class AssociatedCabs extends StatelessWidget {
  const AssociatedCabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.topCenter,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 44, 105, 46), 
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
    );
  }
}

