// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBjlcsXcjPRoaAouxjWiH-sxGFRxlze-mU',
    appId: '1:835382712410:web:8f77738a43dd728a7e2063',
    messagingSenderId: '835382712410',
    projectId: 'chitchat-untar',
    authDomain: 'chitchat-untar.firebaseapp.com',
    storageBucket: 'chitchat-untar.appspot.com',
    measurementId: 'G-2QQYC26QPE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUB-MH9gnidhZyBC9xuReLl5EFPfzK9fQ',
    appId: '1:835382712410:android:7a01587648e72a937e2063',
    messagingSenderId: '835382712410',
    projectId: 'chitchat-untar',
    storageBucket: 'chitchat-untar.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAZ8Cz6SldurxeeixWKivxQ0A2oPFbuf88',
    appId: '1:835382712410:ios:71b0fc0f6765524b7e2063',
    messagingSenderId: '835382712410',
    projectId: 'chitchat-untar',
    storageBucket: 'chitchat-untar.appspot.com',
    androidClientId: '835382712410-5gs7k9fifo26fbid80oo8dmh1ngh3g60.apps.googleusercontent.com',
    iosClientId: '835382712410-s2ft8g16i7l42juvorcmr25kktd82ujs.apps.googleusercontent.com',
    iosBundleId: 'com.example.chitchat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAZ8Cz6SldurxeeixWKivxQ0A2oPFbuf88',
    appId: '1:835382712410:ios:1329ad3b5b864eab7e2063',
    messagingSenderId: '835382712410',
    projectId: 'chitchat-untar',
    storageBucket: 'chitchat-untar.appspot.com',
    androidClientId: '835382712410-5gs7k9fifo26fbid80oo8dmh1ngh3g60.apps.googleusercontent.com',
    iosClientId: '835382712410-lltoh7dqdrj7c5g9377pqppk2g4q4u3n.apps.googleusercontent.com',
    iosBundleId: 'com.example.chitchat.RunnerTests',
  );
}