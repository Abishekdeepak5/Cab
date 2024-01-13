import 'package:flutter/material.dart';
import 'package:google_mao/api/cab_service.dart';
import 'package:google_mao/provider/stateprovider.dart';
import 'package:google_mao/ui/associated_cabs.dart';
import 'package:google_mao/ui/passengerDetailPage/inputWidget.dart';
import 'package:provider/provider.dart';

class CabContriant extends StatefulWidget {
  CabContriant({super.key});

  @override
  State<CabContriant> createState() => _CabContriantState();
}

class _CabContriantState extends State<CabContriant> {
  
  final CabApiService cabService=CabApiService();
  bool isLoading=false;
  void setLoad(bool val){
    setState((){
        isLoading=val;
    });
    }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
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
                      setLoad(true);
                      cabService.getAvaiableCar().then((value) {
                        // print("helo ${value.cabNumber}");
                              print(value);
                            if(value.carNumber!=""){
                            Provider.of<StateProvider>(context,listen:false).setCarNumber(value.carNumber,value.cabId);
                              setLoad(false);
                              Navigator.push(
                                context,MaterialPageRoute(builder: (context) =>AssociatedCabs()),
                            );
                            setLoad(false);
                            }
                            else{
                              setLoad(false);
                              print("Failed");
                            }
                          });
                      // Navigator.push(context,
                      //   MaterialPageRoute(builder: (context) => const AssociatedCabs()),
                      // );
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
          if(isLoading)
          Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        
      ],
    );
  }
}