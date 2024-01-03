import 'package:flutter/material.dart';
import 'package:google_mao/provider/stateprovider.dart';
import 'package:provider/provider.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';


class ClientListen extends StatefulWidget {
  @override
  _ClientListenState createState() => _ClientListenState();
}

class _ClientListenState extends State<ClientListen> {
  late HubConnection hubConnection;
  double lat=0,lng=0;
  late TextEditingController latText;
  late TextEditingController lngText;
  late TextEditingController userid;
  String oldGroupId="";
  Future<void> startConnection(String userId) async{
    hubConnection = HubConnectionBuilder().withUrl("https://localhost:7048/LocationHub").build();
    _startHub();
    // setUserId();
    hubConnection.on("ResponseServer",_handleNewLocation);
    hubConnection.on("LocationUpdated",_handleGroup);

  }

  @override
  initState(){
    super.initState();
    latText=TextEditingController();
    lngText=TextEditingController();
    userid=TextEditingController();
    }

  @override
  void dispose(){
    hubConnection.stop();
  }

  @override
  Widget build(BuildContext context) {
   double curlat= Provider.of<StateProvider>(context).latitude;
   double curlng= Provider.of<StateProvider>(context).longitude;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stateful'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Row(
              children: [
                Text("Lat: ${curlat}"),
                Text("Lng: ${curlng}"),
                const Text(
                  'UserId:',
                  style: TextStyle(fontSize: 20),
                ), 
                 ElevatedButton(onPressed: (){
                   startConnection(userid.text);
                 }, child: const Text("Id")),
                 ElevatedButton(onPressed: (){
                  setUserId();
                 }, child: const Text("send")),
                 ElevatedButton(onPressed: (){
                  removeGroup();
                 }, child: const Text("Remove")),
                   ],
                 ),
              TextField(
                controller: userid,
                 ), 
            TextField(
              controller: latText,
            ),
             TextField(
              controller: lngText,
            ),
            ElevatedButton(onPressed: _setLocation, child: const Text("Click")),
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

Future<void> setUserId() async{
  oldGroupId=userid.text;
   if(hubConnection.state==HubConnectionState.Connected){
    print("super");
      await hubConnection.invoke("AddToGroup",args:<Object>[
        userid.text
      ]);
    }
    else{
      print("Soo...");
    }
}

  Future<void> removeGroup() async{
    if(hubConnection.state==HubConnectionState.Connected && oldGroupId!=""){
    print("super Remove");
      await hubConnection.invoke("removeFromGroup",args:<Object>[
        oldGroupId
      ]);
    }
    else{
      print("No Group...");
    }
  }

  void _handleGroup(List<Object?>? arguments){
    //   print(arguments?[0]);
     print(arguments?[1]);
    //  print(arguments?[2]);
     Object? lat=arguments?[1];
     Object? lng = arguments?[2];
    //  double.parse(arguments![1]),double.parse(arguments[2])
     Provider.of<StateProvider>(context,listen:false).updateLocation(lat!,lng!);
  }

 Future<void> _setLocation() async{
  // lat=(double.parse(latText.text));
  // lng=(double.parse(lngText.text));
  lat=lat+1;
  lng=lng+1;
    if(hubConnection.state==HubConnectionState.Connected){
      await hubConnection.invoke("updateLatitudeLongitude",args:<Object>[
        userid.text,lat,lng
      ]);
    }
  }

  void _handleNewLocation(List<Object?>? arguments) {

     print("Response ${arguments?[0]}");
    //  print(arguments?[1]);
    //  print(arguments?[2]);
  }
}
