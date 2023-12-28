import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_mao/api/api_service.dart';
import 'package:google_mao/models/category.dart';
// import 'package:http/http.dart' as http;


class MyHomePagenew extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePagenew> {
    ApiService1? apiService;
  @override
  void initState() {
    super.initState();
    apiService=ApiService1();
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
        future: apiService?.getCategory(),
        builder: (BuildContext context, AsyncSnapshot<List<Categorys>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Categorys>? categorys = snapshot.data;
            return _buildListView(categorys!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }, 
      ),
    );
  }

Widget _buildListView(List<Categorys> categorys) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          Categorys category = categorys[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Text(
                      category.name,
                      style: Theme.of(context).textTheme.titleLarge,
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


//Widget _buildListView(List<Categorys> categorys) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
  //     child: ListView.builder(
  //       itemBuilder: (context, index) {
  //         Categorys category = categorys[index];
  //         return Padding(
  //           padding: const EdgeInsets.only(top: 8.0),
  //           child: Card(
  //             child: Padding(
  //               padding: const EdgeInsets.all(16.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: <Widget>[
  //                   Text(
  //                     category.name,
  //                     style: Theme.of(context).textTheme.titleLarge,
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: <Widget>[
  //                       TextButton(
  //                         onPressed: () {
  //                           showDialog(
  //                               context: context,
  //                               builder: (context) {
  //                                 return AlertDialog(
  //                                   title: const Text("Warning"),
  //                                   content: Text(
  //                                       "Are you sure want to delete data brand ${category.name}?"),
  //                                   actions: <Widget>[
  //                                     TextButton(
  //                                       child: const Text("Yes"),
  //                                       onPressed: () {
  //                                         Navigator.pop(context);
  //                                         apiService
  //                                             ?.deleteBrands(brand.id)
  //                                             .then((isSuccess) {
  //                                           if (isSuccess) {
  //                                             setState(() {});
  //                                             ScaffoldMessenger.of(context)
  //                                                 .showSnackBar(const SnackBar(
  //                                                     content: Text(
  //                                                         "Delete data success")));
  //                                           } else {
  //                                             ScaffoldMessenger.of(context)
  //                                                 .showSnackBar(const SnackBar(
  //                                                     content: Text(
  //                                                         "Delete data failed")));
  //                                           }
  //                                         });
  //                                       },
  //                                     ),
  //                                     TextButton(
  //                                       child: const Text("No"),
  //                                       onPressed: () {
  //                                         Navigator.pop(context);
  //                                       },
  //                                     )
  //                                   ],
  //                                 );
  //                               });
  //                         },
  //                         child: const Text(
  //                           "Delete",
  //                           style: TextStyle(color: Colors.red),
  //                         ),
  //                       ),
  //                       TextButton(
  //                         onPressed: () async {
  //                           var result = await Navigator.push(context,
  //                               MaterialPageRoute(builder: (context) {
  //                             return FormScreen(category: category);
  //                           }));
  //                           if (result != null) {
  //                             setState(() {});
  //                           }
  //                         },
  //                         child: const Text(
  //                           "Edit",
  //                           style: TextStyle(color: Colors.blue),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //       itemCount: categorys.length,
  //     ),
  //   );
  // }

