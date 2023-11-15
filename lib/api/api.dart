import 'package:chitchat/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class apis {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User get user => auth.currentUser!;

  static Future<bool> userExists() async {
    return (await firestore.collection('Users').doc(user.uid).get()).exists;
  }

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
      Id: user.uid,
      Name: user.displayName.toString(),
      Email: user.email.toString(),
      About: "Hey There I am using ChitChat",
      Image: user.photoURL.toString(),
      CreateAt: time,
      IsOnline: false,
      LastSeen: time,
      PushToken: '');

    return await firestore.collection('Users').doc(user.uid).set(chatUser.toJson());
  }
}
