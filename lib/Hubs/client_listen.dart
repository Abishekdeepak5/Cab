import 'package:flutter/material.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';


class ClientListen extends StatefulWidget {
  @override
  _ClientListenState createState() => _ClientListenState();
}

class _ClientListenState extends State<ClientListen> {
  final serverUrl="https://localhost:7048/LocationHub";
  final hubConnection = HubConnectionBuilder().withUrl("https://localhost:7048/LocationHub").build();
  double lat=0,lng=0;
  late TextEditingController latText;
  late TextEditingController lngText;
  @override
  initState(){
    super.initState();
    latText=TextEditingController();
    lngText=TextEditingController();
    _startHub();
    hubConnection.on("ReceiveNewValue",_handleNewLocation);
    // initSignalR();
  }

  @override
  void dispose(){
    hubConnection.stop();
  }

  //  void _handleNewLocation(List<Object> args){
  //   print(args[0]);
  //   print(args[1]);

  // }

void _incrementCounter() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stateful Widget Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Counter:',
              style: TextStyle(fontSize: 20),
            ),
            const Text(
              'Hello',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: latText,
            ),
             TextField(
              controller: lngText,
            ),
            ElevatedButton(onPressed: _setLocation, child: const Text("Click"))
          ],
        ),
      ),
    );
  }
  
  Future<void> _startHub() async{
    try{
      await hubConnection.start();
      print('awit');
    }
    catch(e){
      print("Hello $e");
    }
  }

  initSignalR() {

     
    //  hubConnection.onclose( (error) => print("Connection Closed") );
    // hubConnection.onclose( (error) => print("Connection Closed"));
     
  }
  
 Future<void> _setLocation() async{
  lat=double.parse(latText.text);
  lng=double.parse(lngText.text);
    if(hubConnection.state==HubConnectionState.Connected){
      await hubConnection.invoke("LocationFromServer",args:<Object>[
        lat,lng
      ]);
    }
    print('Connect no');
  }

 

  void _handleNewLocation(List<Object?>? arguments) {
     print(arguments?[0]);
     print(arguments?[1]);
  }
}
