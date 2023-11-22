import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chitchat/models/Message.dart';
import 'package:chitchat/models/chatuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';

class apis {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseStorage storage = FirebaseStorage.instance;

  static late ChatUser me;

  static User get user => auth.currentUser!;

  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.PushToken = t;
        log('Push Token:$t');
      }
    });
  }

  static Future<void> sendPushNotification(ChatUser chatUser, String msg) async {
    try {
      final body = 
      {
    "to":chatUser.PushToken,
    "notification": {
        "title": chatUser.Name,
        "body": msg
    }

    };

    var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'), 
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader:
      'key=AAAAwoCwmFo:APA91bHanLhFFsNpOJMi78whHdQJus7MGF_-7SIn1uTG9AvnQcuSYbWT4r77Bjhup8Kc69pap3yif4N_PdEg4zghGKA9IwoT7Noo4c__ZQQ65RHa6d3P-bTa5mcebKKrJ39Q0RKIJnCD'
    },
      body: jsonEncode(body));
    log('Response status: ${res.statusCode}');
    log('Response body: ${res.body}');
    }
    catch(e){
      log('\sendPushNotificationE: $e');
    }
  }

  static Future<bool> userExists() async {
    return (await firestore.collection('Users').doc(user.uid).get()).exists;
  }

  static Future<void> getSelfinfo() async {
    await firestore.collection('Users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        await getFirebaseMessagingToken();
        apis.updateActiveStatus(true);
        log('My Data: ${user.data()}');
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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('Users')
        .where('Id', isEqualTo: chatUser.Id)
        .snapshots();
  }

  static Future<void> updateActiveStatus(bool IsOnline) async {
    firestore.collection('Users').doc(user.uid).update({
      'Is_online': IsOnline,
      'Last_seen': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.PushToken,
    });
  }

  static String getConversationID(String Id) => user.uid.hashCode <= Id.hashCode
      ? '${user.uid}_$Id'
      : '${Id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('Chats/${getConversationID(user.Id)}/Messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    final Messages messages = Messages(
        msg: msg,
        read: '',
        told: chatUser.Id,
        type: type,
        sent: time,
        fromId: user.uid);

    final ref = firestore
        .collection('Chats/${getConversationID(chatUser.Id)}/Messages/');
    await ref.doc(time).set(messages.toJson()).then((value) =>
        sendPushNotification(chatUser, type == Type.text ? msg : 'image'));
  }

  static Future<void> updateMessageReadStatus(Messages messages) async {
    firestore
        .collection('Chats/${getConversationID(messages.fromId)}/Messages/')
        .doc(messages.sent)
        .update({'read': DateTime.now().microsecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('Chats/${getConversationID(user.Id)}/Messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    final ext = file.path.split('.').last;

    final ref = storage.ref().child(
        'Images/${getConversationID(chatUser.Id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'Image/$ext'))
        .then((p0) {
      log('Data Transferred ${p0.bytesTransferred / 1000} kb');
    });

    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }
}
