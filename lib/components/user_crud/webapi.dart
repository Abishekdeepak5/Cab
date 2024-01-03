// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_mao/api/trip_api_service.dart';
import 'package:google_mao/components/user_crud/update_location.dart';
import 'package:google_mao/models/LocationModel.dart';




class MyHomePagenew extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePagenew> {
    TripApiService? apiService;
  @override
  void initState() {
    super.initState();
    apiService=TripApiService();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
    //   child:ElevatedButton(
    //     onPressed:(){
    //         apiService?.getBrandss();
    //     } ,
    //     child: const Text("Abi"),

    //   ) ,

    // );}
      child: FutureBuilder(
        future: apiService?.getTrip(),
        builder: (BuildContext context, AsyncSnapshot<List<Trip>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Trip>? trips = snapshot.data;
            return _buildListView(trips!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }, 
      ),
    );
  }

Widget _buildListView(List<Trip> categorys) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          Trip trip = categorys[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Text(
                      trip.latitude.toString() ,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        
                        TextButton(
                          onPressed: () async {
                            var result = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  print(trip);
                              return UpdateLocation(trip: trip);
                            }));
                            if (result != null) {
                              setState(() {});
                            }
                          },
                          child: const Text(
                            "Edit",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: categorys.length,
      ),
    );
  }

}


// Widget _buildListView(List<Trip> categorys) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       child: ListView.builder(
//         itemBuilder: (context, index) {
//           Trip category = categorys[index];
//           return Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       category.latitude,
//                       style: Theme.of(context).textTheme.titleLarge,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: <Widget>[
//                         TextButton(
//                           onPressed: () {
//                             showDialog(
//                                 context: context,
//                                 builder: (context) {
//                                   return AlertDialog(
//                                     title: const Text("Warning"),
//                                     content: Text(
//                                         "Are you sure want to delete data brand ${category.latitude}?"),
//                                     actions: <Widget>[
//                                       TextButton(
//                                         child: const Text("Yes"),
//                                         onPressed: () {
//                                           // Navigator.pop(context);
//                                           // apiService
//                                           //     ?.deleteBrands(brand.id)
//                                           //     .then((isSuccess) {
//                                           //   if (isSuccess) {
//                                           //     setState(() {});
//                                           //     ScaffoldMessenger.of(context)
//                                           //         .showSnackBar(const SnackBar(
//                                           //             content: Text(
//                                           //                 "Delete data success")));
//                                           //   } else {
//                                           //     ScaffoldMessenger.of(context)
//                                           //         .showSnackBar(const SnackBar(
//                                           //             content: Text(
//                                           //                 "Delete data failed")));
//                                           //   }
//                                           // });
//                                         },
//                                       ),
//                                       TextButton(
//                                         child: const Text("No"),
//                                         onPressed: () {
//                                           Navigator.pop(context);
//                                         },
//                                       )
//                                     ],
//                                   );
//                                 });
//                           },
//                           child: const Text(
//                             "Delete",
//                             style: TextStyle(color: Colors.red),
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () async {
//                             // var result = await Navigator.push(context,
//                             //     MaterialPageRoute(builder: (context) {
//                             //   return FormScreen(category: category);
//                             // }));
//                             // if (result != null) {
//                             //   setState(() {});
//                             // }
//                           },
//                           child: const Text(
//                             "Edit",
//                             style: TextStyle(color: Colors.blue),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//         itemCount: categorys.length,
//       ),
//     );
//   }

