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
  final String? uid;
  apis({this.uid});

  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
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
  static User get user => auth.currentUser!;
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;
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

  static Future<void> sendPushNotification(ChatUser user, String msg) async {
    try {
      final body = {
        "to": user.PushToken,
        "notification": {
          "title": me.Name,
          "body": msg,
          "android_channel_id": "Chats"
        },
        "data": {
          "Data": "User ID : ${me.Id}",
        },
      };
      var response =
          await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    'key = AAAAwoCwmFo:APA91bHanLhFFsNpOJMi78whHdQJus7MGF_-7SIn1uTG9AvnQcuSYbWT4r77Bjhup8Kc69pap3yif4N_PdEg4zghGKA9IwoT7Noo4c__ZQQ65RHa6d3P-bTa5mcebKKrJ39Q0RKIJnCD'
              },
              body: jsonEncode(body));
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
    } catch (e) {
      log('\nsendPushNotificationE : $e');
    }
  }

  static Future<ChatUser?> getUserByEmail(String email) async {
    try {
      final QuerySnapshot result = await firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (result.docs.isNotEmpty) {
        return ChatUser.fromJson(result.docs.first.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      log('Error fetching user by email: $e');
      return null;
    }
  }


  static Future<bool> userExists() async {
    return (await firestore.collection('Users').doc(user.uid).get()).exists;
  }

  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('Users')
        .where('Email', isEqualTo: email)
        .get();

    log('Data: ${data.docs}');

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      log('user exists: ${data.docs.first.data()}');

      firestore
          .collection('Users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      return false;
    }
  }

  static Future<void> getSelfInfo() async {
    await firestore.collection('Users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        await getFirebaseMessagingToken();

        apis.updateActiveStatus(true);
        log('My Data: ${user.data()}');
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

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
        .collection('Users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore
        .collection('Users')
        .doc(user.uid)
        .collection('my_users')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    log('\nUserIds: $userIds');

    return firestore
        .collection('Users')
        .where('Id', whereIn: userIds.isEmpty ? [''] : userIds)
        .snapshots();
  }

  static Future<void> sendFirstMessage(
      ChatUser chatUser, String msg, Type type) async {
    await firestore
        .collection('Users')
        .doc(chatUser.Id)
        .collection('my_users')
        .doc(user.uid)
        .set({}).then((value) => sendMessage(chatUser, msg, type));
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
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
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
      'Push_token': me.PushToken,
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
    final time = DateTime.now().millisecondsSinceEpoch.toString();

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

  static Future<void> updateMessageReadStatus(Messages messages) async {
    firestore
        .collection('Chats/${getConversationID(messages.fromId)}/Messages/')
        .doc(messages.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
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
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }

  static Future<void> deleteMessage(Messages messages) async {
    await firestore
        .collection('Chats/${getConversationID(messages.told)}/Messages/')
        .doc(messages.sent)
        .delete();

    if (messages.type == Type.image) {
      await storage.refFromURL(messages.msg).delete();
    }
  }

  static Future<void> updateMessage(Messages messages, String updateMsg) async {
    await firestore
        .collection('Chats/${getConversationID(messages.told)}/Messages/')
        .doc(messages.sent)
        .update({'msg': updateMsg});
  }
}
