import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';

import '../models/chatuser.dart';
import '../models/Message.dart';

class apis {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  // for storing self information
  static ChatUser me = ChatUser(
      Id: user.uid,
      Name: user.displayName.toString(),
      Email: user.email.toString(),
      About: "Hey, There I am using ChitChat!",
      Image: user.photoURL.toString(),
      CreateAt: '',
      IsOnline: false,
      LastSeen: '',
      PushToken: '');

  // to return current user
  static User get user => auth.currentUser!;

  // for accessing firebase messaging (Push Notification)
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // for getting firebase messaging token
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((token) {
      if (token != null) {
        me.PushToken = token;
        log('Push Token: $token');
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
      }
    });
  }

  // for sending push notification
  static Future<void> sendPushNotification(
      ChatUser user, String msg) async {
    try {
      final body = {
        "to": user.PushToken,
        "notification": {
          "title": user.Name, //our name should be send
          "body": msg,
          "android_channel_id": "Chats"
        },
        // "data": {
        //   "Data": "User ID: ${me.id}",
        // },
      };

      var response = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAQ0Bf7ZA:APA91bGd5IN5v43yedFDo86WiSuyTERjmlr4tyekbw_YW6JrdLFblZcbHdgjDmogWLJ7VD65KGgVbETS0Px7LnKk8NdAz4Z-AsHRp9WoVfArA5cNpfMKcjh_MQI-z96XQk5oIDUwx8D1'
          },
          body: jsonEncode(body));
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }

  // for checking if user exists or not?
  static Future<bool> userExists() async {
    return (await firestore.collection('Users').doc(user.uid).get()).exists;
  }

  // for adding an chat user for our conversation
  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('Users')
        .where('Email', isEqualTo: email)
        .get();

    log('Data: ${data.docs}');

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      //user exists

      log('user exists: ${data.docs.first.data()}');

      firestore
          .collection('Users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      //user doesn't exists

      return false;
    }
  }

  // for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('Users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        await getFirebaseMessagingToken();

        //for setting user status to active
        apis.updateActiveStatus(true);
        log('My Data: ${user.data()}');
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  // for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        Id: user.uid,
        Name: user.displayName.toString(),
        Email: user.email.toString(),
        About: "Hey, There I am using ChitChat!",
        Image: user.photoURL.toString(),
        CreateAt: time,
        IsOnline: false,
        LastSeen: time,
        PushToken: '');

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  // for getting id's of known users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('Users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

  // for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    log('\nUserIds: $userIds');

    return firestore
        .collection('Users')
        .where('Id',
            whereIn: userIds.isEmpty
                ? ['']
                : userIds) //because empty list throws an error
        // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // for adding an user to my user when first message is send
  static Future<void> sendFirstMessage(
      ChatUser chatUser, String msg, Type type) async {
    await firestore
        .collection('Users')
        .doc(chatUser.Id)
        .collection('my_users')
        .doc(user.uid)
        .set({}).then((value) => sendMessage(chatUser, msg, type));
  }

  // for updating user information
  static Future<void> updateUserInfo() async {
    await firestore.collection('Users').doc(user.uid).update({
      'Name': me.Name,
      'About': me.About,
    });
  }

  // update profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    //storage file ref with path
    final ref = storage.ref().child('Profile_Pictures/${user.uid}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'Image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    me.Image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'Image': me.Image});
  }

  // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('Users')
        .where('Id', isEqualTo: chatUser.Id)
        .snapshots();
  }

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool IsOnline) async {
    firestore.collection('Users').doc(user.uid).update({
      'Is_online': IsOnline,
      'Last_seen': DateTime.now().millisecondsSinceEpoch.toString(),
      'Push_token': me.PushToken,
    });
  }

  // useful for getting conversation id
  static String getConversationID(String Id) => user.uid.hashCode <= Id.hashCode
      ? '${user.uid}_$Id'
      : '${Id}_${user.uid}';

  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('Chats/${getConversationID(user.Id)}/Messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // for sending message
  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Messages messages = Messages(
        told: chatUser.Id,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time);

    final ref = firestore
        .collection('Chats/${getConversationID(chatUser.Id)}/Messages/');
    await ref.doc(time).set(messages.toJson()).then((value) =>
        sendPushNotification(chatUser, type == Type.text ? msg : 'Image'));
  }

  //update read status of message
  static Future<void> updateMessageReadStatus(Messages messages) async {
    firestore
        .collection('Chats/${getConversationID(messages.fromId)}/Messages/')
        .doc(messages.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('Chats/${getConversationID(user.Id)}/Messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  //send chat image
  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
        'Images/${getConversationID(chatUser.Id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'Image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }

  //delete message
  static Future<void> deleteMessage(Messages messages) async {
    await firestore
        .collection('Chats/${getConversationID(messages.told)}/Messages/')
        .doc(messages.sent)
        .delete();

    if (messages.type == Type.image) {
      await storage.refFromURL(messages.msg).delete();
    }
  }

  //update message
  static Future<void> updateMessage(Messages messages, String updateMsg) async {
    await firestore
        .collection('Chats/${getConversationID(messages.told)}/Messages/')
        .doc(messages.sent)
        .update({'msg': updateMsg});
  }
}