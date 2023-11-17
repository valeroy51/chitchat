import 'dart:developer';
import 'dart:io';

import 'package:chitchat/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class apis {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  static FirebaseStorage storage = FirebaseStorage.instance;

  static late ChatUser me;

  static User get user => auth.currentUser!;

  static Future<bool> userExists() async {
    return (await firestore.collection('Users').doc(user.uid).get()).exists;
  }

  static Future<void> getSelfinfo() async {
    await firestore.collection('Users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        await createUser().then((value) => getSelfinfo());
      }
    });
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

    return await firestore
        .collection('Users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return firestore
        .collection('Users')
        .where('Id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> updateUserInfo() async {
    await firestore.collection('Users').doc(user.uid).update({
      'Name': me.Name,
      'About': me.About,
    });
  }

  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    log('Extension: $ext');
    final ref = storage.ref().child('Profile_Pictures/${user.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'Image/$ext'))
        .then((p0) {
      log('Data Transferred ${p0.bytesTransferred / 1000} kb');
    });

    me.Image = await ref.getDownloadURL();
    await firestore
        .collection('Users')
        .doc(user.uid)
        .update({'Image': me.Image});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages() {
    return firestore
        .collection('Messages')
        .snapshots();
  }
}
