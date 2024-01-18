import 'package:flutter/material.dart';
import 'package:google_mao/api/cab_service.dart';
import 'package:google_mao/components/map/trip_map.dart';
import 'package:google_mao/provider/stateprovider.dart';
import 'package:provider/provider.dart';

class AssociatedCabs extends StatefulWidget {
  AssociatedCabs({super.key});
  @override
  State<AssociatedCabs> createState() => _AssociatedCabsState();
}

class _AssociatedCabsState extends State<AssociatedCabs> {
  final CabApiService cabService=CabApiService();
 bool isLoading=false;
  void setLoad(bool val){
    setState((){
        isLoading=val;
    });
    }
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return  Scaffold(
      body: Stack(
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.topCenter,
                  child: ElevatedButton(
                    onPressed: () async{
                      cabService.StartCab(Provider.of<StateProvider>(context,listen: false).Token,Provider.of<StateProvider>(context,listen: false).carNumber,Provider.of<StateProvider>(context,listen: false).carId).then((value) {
                        if(value){
                          // Provider.of<StateProvider>(context,listen: false).setCabStart(true);
                          Navigator.push(
                                context,MaterialPageRoute(builder: (context) =>LocationTrack()),
                            );
                        }
                      });
                    },
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
                Text(Provider.of<StateProvider>(context).carNumber!=""?Provider.of<StateProvider>(context).carNumber:'6666', style: TextStyle(fontSize: 30)),
              ],
            ),
            if(isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

