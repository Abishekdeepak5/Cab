import 'dart:ui';
import 'package:flutter/material.dart';

Color greenColor = const Color(0xFF355723);
Color orangeColor = const Color(0xFFFF814B);
Color pinkColor = const Color(0xFFF85F6A);
Color lightPink = const Color(0xFFFEEEEF);
Color violetColor= const Color(0xFF1C0C4F);


class LoadingOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
class PopUpMessage{
  static void displayMessage(BuildContext context, String message, int sec) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: sec),
      ),
    );
  }
}

