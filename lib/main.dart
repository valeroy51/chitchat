import 'dart:developer';
import 'package:chitchat/screen/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'firebase_options.dart';

late Size mq;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    _initializeFirebase();
    runApp(const MainApp());
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChitChat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 1,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 20),
              backgroundColor: Colors.indigo,
              shadowColor: Colors.white)),
      home: const splashScreen(),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'Show message notif',
    id: 'Chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',
  );
  log('\nNotification channel result : $result');
}
