import 'package:flutter/material.dart';
import 'package:google_mao/ui/associated_cabs.dart';
import 'package:google_mao/ui/passengerDetailPage/inputWidget.dart';

class CabContriant extends StatelessWidget {
  const CabContriant({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
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
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AssociatedCabs()),
                  );
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
      );
  }
}