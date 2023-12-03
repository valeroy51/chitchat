import 'dart:developer';
import 'dart:io';
import 'package:chitchat/api/api.dart';
import 'package:chitchat/helper/dialog.dart';
import 'package:chitchat/screen/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../main.dart';
import 'package:video_player/video_player.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});
  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  bool _isAnimated = false;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('img/LogoMasuk.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await apis.auth.signInWithCredential(credential);
    } catch (e) {
      log('\nsignInWithGoogle: $e');
      dialog.showSnackBar(
          context, 'Terjadi kesalahan, tolong periksa internet anda!');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    _googleButton() {
      dialog.showProgressBar(context);
      _signInWithGoogle().then((user) async {
        Navigator.pop(context);
        if (user != null) {
          log('User: ${user.user}');
          log('UserAdditionalInfo: ${user.additionalUserInfo}');
          if (await apis.userExists()) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const homeScreen()));
          } else {
            await apis.createUser().then((value) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const homeScreen()));
            });
          }
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome'),
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.indigo),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            top: _isAnimated ? mq.height * 0.23 : mq.height * 0.5,
            left: _isAnimated ? mq.width * 0.1 : mq.width * 0.5,
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              width: _isAnimated ? mq.width * 0.8 : 0,
              height: _isAnimated ? mq.height * 0.3 : 0,
              child: VideoPlayer(_controller),
            ),
          ),
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
                  _googleButton();
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
