import 'package:flutter/material.dart';
import 'package:google_mao/api/stream_api.dart';

class MyStream extends StatelessWidget {
  final StreamApiClient streamApiClient = StreamApiClient();

  @override
  Widget build(BuildContext context) {
    streamApiClient.startStreaming();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Streaming Example'),
        ),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: streamApiClient.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Display the data however you need
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data![index];
                  return ListTile(
                    title: Text('ID: ${item['id']}, Lat: ${item['latitude']}, Lon: ${item['longitude']}'),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
