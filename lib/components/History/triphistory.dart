import 'package:flutter/material.dart';
import 'package:google_mao/api/trip_api_service.dart';
import 'package:google_mao/components/constants.dart'; 
import 'package:google_mao/models/HistoryModel.dart';
import 'package:google_mao/provider/stateprovider.dart';
import 'package:provider/provider.dart';

class TripHistory extends StatefulWidget {
  const TripHistory({super.key});

  @override
  // ignore: library_private_types_in_public_api
  APIScreen createState() => APIScreen();
}

class APIScreen extends State<TripHistory> {
  TripApiService? apiService;

  @override
  void initState() {
    super.initState();
    apiService = TripApiService();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SafeArea(
        child: FutureBuilder(
          future: apiService?.getHistory(Provider.of<StateProvider>(context,listen: false).Token),
          builder: (BuildContext context, AsyncSnapshot<List<TripsHistory>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                    "Something wrong with message: ${snapshot.error.toString()}"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<TripsHistory>? trips = snapshot.data;
              return _buildListView(trips!);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildListView(List<TripsHistory> tripss) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          TripsHistory trip = tripss[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                          text: TextSpan(
                           style: Theme.of(context).textTheme.titleLarge,
                          children: <TextSpan>[
                          TextSpan(text: 'Cab id: ', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: pinkColor,
                            ),),
                            TextSpan(
                            text: '${trip.cabId}',
                            ),],),
                      ),
                      RichText(
                          text: TextSpan(
                           style: Theme.of(context).textTheme.titleLarge,
                          children: <TextSpan>[
                          TextSpan(text: 'From: ', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: orangeColor,
                            ),),
                            TextSpan(
                            text: '${trip.startLocation}',
                            ),],),
                      ),
                      RichText(
                          text: TextSpan(
                           style: Theme.of(context).textTheme.titleLarge,
                          children: <TextSpan>[
                          TextSpan(text: 'To: ', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: orangeColor,
                            ),),
                            TextSpan(
                            text: '${trip.endLocation}',
                            ),],),
                      ),
                      RichText(
                          text: TextSpan(
                           style: Theme.of(context).textTheme.titleLarge,
                          children: <TextSpan>[
                          TextSpan(text: 'Price: ', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: orangeColor,
                            ),),
                            TextSpan(
                            text: '${trip.price}',
                            ),],),
                      ),
                    // Text(
                    //   'From ${trip.startLocation}',
                    //   style: Theme.of(context).textTheme.titleLarge,
                    // ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: tripss.length,
      ),
    );
  }
}
