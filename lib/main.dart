import 'package:chitchat/screen/login/loginscreen.dart';
import 'package:flutter/material.dart';

late Size mq;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChitChat',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.normal, fontSize: 20),
        backgroundColor: Colors.indigo,
      )),
      home: const loginScreen(),
    );
  }
}
