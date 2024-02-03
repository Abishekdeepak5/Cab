import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_mao/components/constants.dart';
import 'package:http/http.dart' show Client;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FileUploadDto {
  final Uint8List image;

  FileUploadDto(this.image);

  Map<String, dynamic> toJson() {
    return {
      'image': base64Encode(image), // Assuming you want to encode the image data as base64
    };
  }
}

// class ImageService {
  const String baseUrl = "https://meterproservice.azurewebsites.net/api/Image";
  // const String baseUrl = "https://localhost:7048/api/Image";

Future<bool> sendUpdatedImage(Uint8List updatedImage,BuildContext context,String token) async {
  try{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? tripId=prefs.getInt('tripId');
    var uri = Uri.parse('$baseUrl/RecScreenshot/$tripId');
    var request = http.MultipartRequest('POST', uri);
    // 'tripId': '123',
    request.files.add(http.MultipartFile.fromBytes(
      'emailDto.formFile',
            updatedImage,
            filename: 'screenshot.jpg',
    ),
  );
    request.fields.addAll({
    'emailDto.Subject': 'MeterPro Trip',
    'emailDto.Message': 'MeterPro Trip , Thank you!',
  });
    // request.files.add(http.MultipartFile.fromBytes(
    //   'file',
    //   updatedImage,
    //   filename: 'screenshot.jpg', 
    // ));
    request.headers['Authorization'] = 'Bearer $token';
    var response = await request.send();
    // PopUpMessage.displayMessage(context, await response.stream.bytesToString(), 10);
    // PopUpMessage.displayMessage(context, '${response.statusCode}', 3);
     if (response.statusCode == 200) {
      print('Image uploaded successfully!');
      // print(await response.stream.bytesToString());
      return true;
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
      return false;
    }
  }catch(err){
    PopUpMessage.displayMessage(context, 'errr $err', 1);

    print('error $err') ;
    return false;
  }

}
Future<void> getImage(int id) async {
  try {
    Client client = Client();
    final response = await client.get(Uri.parse("$baseUrl/GetImage/$id"));
    if (response.statusCode == 200) {
        print(response.statusCode);
    } else if (response.statusCode == 204) {
      print(response.statusCode);
    } else {
        print(response.statusCode);
    }
  } catch (err) {
  print("error $err");
  }
}


// class CabApiService {
//   // final String baseUrl = "https://localhost:7048";
//   final String baseUrl = "https://meterproservice.azurewebsites.net";

//   Client client = Client();

//   Future<void> getImage() async {
//     try {
//       final response = await client.get(Uri.parse("$baseUrl/api/Image/GetImage"));
//       if (response.statusCode == 200) {
//           print(response.statusCode);
//       } else if (response.statusCode == 204) {
//         print(response.statusCode);
//       } else {
//           print(response.statusCode);
//       }
//     } catch (err) {
//     print("error $err");
//     }
//   }



//   Future<bool> UploadImage(Uint8List imageUint8List) async {
//     try {
//       Map<String, dynamic> data = {
//         'cabId': carId,
//         'startAddress': startAddress,
//       };
//       String jsonString = json.encode(data);

//       final response = await client.put(
//         Uri.parse("$baseUrl/api/Cab/startAddress"),
//         headers: {
//           "content-type": "application/json",
//           'Authorization': 'Bearer $token'
//         },
//         body: jsonString,
//       );
//       if (response.statusCode == 200) {
//         return true;
//       } else {
//         return false;
//       }
//     } catch (err) {
//       return false;
//     }
//   }
// }




// setLoad(true);
//                                       bool val=await getAddress();
//                                        screenshotController
//                                       .capture(delay: Duration(milliseconds: 10))
//                                       .then((capturedImage) async {
//                                             sendUpdatedImage(capturedImage!);
//                                       }).catchError((onError) {
//                                         print(onError);
//                                       });
//                                       bool value=await cabService.endCab(Provider.of<StateProvider>(context,listen: false).Token,Provider.of<StateProvider>(context,listen: false).carId,fullAddress,totalDistance * 2.66);
//                                       if(val && value){
//                                         locationSubscription?.cancel();
//                                         bool val1=await endTrip();
//                                         if(val1){
//                                           // googleMapController.dispose();
//                                            googleMapController=null;
//                                           _mapController = Completer<GoogleMapController>();
//                                         setLoad(false);
//                                         Navigator.of(context).pop();
//                                         Navigator.of(context).pop();
//                                         }
//                                       }
//                                       else{
//                                         setLoad(false);
//                                         ScaffoldMessenger.of(context).showSnackBar(
//                                           const SnackBar(
//                                             content: Text("Press Again"),
//                                             duration: Duration(seconds: 3),
//                                           ),
//                                         );
//                                       }