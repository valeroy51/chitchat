import 'package:chitchat/screen/homescreen.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  bool _isAnimated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimated = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome'),
      ),
      body: Stack(children: [
        AnimatedPositioned(
            top: mq.height * .15,
            // top: _isAnimated ? mq.height * .15 : -mq.height,
            width: mq.width,
            left: _isAnimated ? mq.width * .005 : -mq.width,
            // right: _isAnimated ? mq.width * .005 : -mq.width,
            // right: mq.width * .005,
            duration: const Duration(seconds: 1),
            child: Image.asset('img/logo.png')),
        Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.height * .07,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: const StadiumBorder(),
                    elevation: 1),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const homeScreen()));
                },
                icon: Image.asset(
                  'img/google.png',
                  height: mq.height * .05,
                ),
                label: RichText(
                    text: const TextSpan(
                        style: TextStyle(color: Colors.white, fontSize: 19),
                        children: [
                      TextSpan(text: 'Sign in with '),
                      TextSpan(
                          text: 'Google',
                          style: TextStyle(fontWeight: FontWeight.w500))
                    ]))))
      ]),
    );
  }
}
