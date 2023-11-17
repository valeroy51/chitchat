import 'dart:developer';
import 'package:chitchat/api/api.dart';
import 'package:chitchat/screen/homescreen.dart';
import 'package:chitchat/screen/login/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(systemNavigationBarColor: Colors.white));

      if (apis.auth.currentUser != null) {
        log("User: ${apis.auth.currentUser}");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const homeScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const loginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(children: [
        AnimatedPositioned(
            top: mq.height * .15,
            width: mq.width,
            left: mq.width * .005,
            duration: const Duration(seconds: 1),
            child: Image.asset('img/logo12.png')),
        Positioned(
          bottom: mq.height * .15,
          width: mq.width,
          child: const Text(
            'From Us to You 🤩',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 17,
                color: Colors.indigo,
                fontWeight: FontWeight.bold),
          ),
        )
      ]),
    );
  }
}
