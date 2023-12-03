import 'package:flutter/material.dart';

class AppStyle {
  static Color bgColor = const Color(0xFFe2e2ff);
  static Color mainColor = const Color.fromARGB(255, 13, 20, 79);
  static Color accentColor = const Color(0xFF0065FF);

  static List<Color> cardsColor = [
    Colors.white,
    Colors.red.shade100,
    Colors.pink.shade100,
    Colors.orange.shade100,
    Colors.yellow.shade100,
    Colors.green.shade100,
    Colors.blue.shade100,
    Colors.blueGrey.shade100,
  ];

  // Static text styles
  static TextStyle mainTitle = const TextStyle(
      fontSize: 18.0, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold);
  static TextStyle mainContent = const TextStyle(
      fontSize: 16.0,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.normal);
  static TextStyle dateTitle = const TextStyle(
      fontSize: 13.0, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500);
}
