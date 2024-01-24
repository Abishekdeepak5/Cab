// import 'package:flutter/material.dart';

// class ImageDisplay extends StatelessWidget {
//   final int imageId;

//   ImageDisplay({required this.imageId});

//   @override
//   Widget build(BuildContext context) {
//     // Construct the URL based on your API endpoint
//     String imageUrl = "https://localhost:7048/api/Image/GetImage/$imageId";

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Display'),
//       ),
//       body: Center(
//         child: Image.network(
//           imageUrl,
//           loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
//             if (loadingProgress == null) {
//               return child;
//             } else {
//               return Center(
//                 child: CircularProgressIndicator(
//                   value: loadingProgress.expectedTotalBytes != null
//                       ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
//                       : null,
//                 ),
//               );
//             }
//           },
//           errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
//             return Text('Error loading image.');
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_mao/components/constants.dart';

class ImageDisplay extends StatefulWidget {
  final int imageId;

  ImageDisplay({required this.imageId});

  @override
  _ImageDisplayState createState() => _ImageDisplayState();
}

class _ImageDisplayState extends State<ImageDisplay> {
  late String imageUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    imageUrl = _constructImageUrl(widget.imageId);
    _loadImage();
  }
  

  String _constructImageUrl(int imageId) {
    return "https://meterproservice.azurewebsites.net/api/Image/GetImage/$imageId";
  }

  void _loadImage() async {
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  void _refreshImage() {
    setState(() {
      isLoading = true;
    });
    _loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Image Display'),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Image
            Visibility(
              visible: !isLoading,
              child: InkWell(
                onTap: () {
                },
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Image.network(
                    imageUrl,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      }
                    },
                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                      return ElevatedButton(
                        onPressed: (){
                           _refreshImage();
                        },
                        child: const Text('Refresh'));
                    },
                  ),
                ),
              ),
            ),
            // Loading Indicator
            Visibility(
              visible: isLoading,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _refreshImage,
      //   tooltip: 'Refresh Image',
      //   child: Icon(Icons.refresh),
      // ),
    );
  }
}


