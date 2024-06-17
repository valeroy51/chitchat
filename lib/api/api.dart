import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chitchat/models/statusPicture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:chitchat/models/Message.dart';
import 'package:chitchat/models/chatuser.dart';

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
    PushToken: '',
  );

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
        return ChatUser.fromJson(
            result.docs.first.data() as Map<String, dynamic>);
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
    try {
      // Mendapatkan data pengguna berdasarkan email
      final data = await firestore
          .collection('Users')
          .where('Email', isEqualTo: email)
          .get();

      log('Data: ${data.docs}');

      // Memeriksa apakah pengguna ditemukan dan bukan pengguna saat ini
      if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
        log('User exists: ${data.docs.first.data()}');

        // Mendapatkan userId dari hasil query
        String userId = data.docs.first.id;

        // Mengatur nilai isArchived ke false saat menambahkan pengguna ke daftar kontak
        firestore
            .collection('Users')
            .doc(user.uid)
            .collection('my_users')
            .doc(userId)
            .set({
          'isArchived': false, // Atur nilai isArchived ke false
        });

        // Update status 'chatsDeleted' menjadi false untuk pengguna yang ditambahkan kembali
        final userAdd =
            FirebaseFirestore.instance.collection('Users').doc(userId);

        await userAdd.update({
          'chatsDeleted': false,
        });

        // Menambahkan pengguna saat ini ke kontak pengguna yang ditambahkan
        firestore
            .collection('Users')
            .doc(userId)
            .collection('my_users')
            .doc(user.uid)
            .set({
          'isArchived': false, // Atur nilai isArchived ke false
        });

        log('User with email $email has been added and chatsDeleted set to false.');

        return true;
      } else {
        log('User with email $email does not exist or is the current user.');
        return false;
      }
    } catch (e) {
      log('Error adding user: $e');
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

  static Future<List<ChatUser>> getContactInfo() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> userSnapshot = await firestore
          .collection('Users')
          .doc(user.uid)
          .collection('my_users')
          .get();

      List<String> userIds = userSnapshot.docs.map((doc) => doc.id).toList();
      log('User IDs: $userIds');

      List<ChatUser> contactUsers = [];
      for (String userId in userIds) {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await firestore.collection('Users').doc(userId).get();
        if (userDoc.exists) {
          contactUsers.add(ChatUser.fromJson(userDoc.data()!));
        }
      }
      return contactUsers;
    } catch (e) {
      log('Error getting contact info: $e');
      return [];
    }
  }

//  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
//       List<String> userIds) {
//     log('\nUserIds: $userIds');

//     return firestore
//         .collection('Users')
//         .where('Id', whereIn: userIds.isEmpty ? [''] : userIds)
//         .snapshots();
//   }

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
        .where('isArchived', isEqualTo: false)
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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserArchive() {
    return firestore
        .collection('Users')
        .doc(user.uid)
        .collection('my_users')
        .where('isArchived', isEqualTo: true)
        .snapshots();
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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllChats(
      String userId) {
    return firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
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

  static Future<void> sendStatusImage(
      ChatUser chatUser, File file, BuildContext context) async {
    String date = DateTime.now().toString();

    final ext = file.path.split('.').last;

    final ref = storage.ref().child(
        'Images/${getConversationID(chatUser.Id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    await ref
        .putFile(file, SettableMetadata(contentType: 'Image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 100000} kb');
    });

    final imageUrl = await ref.getDownloadURL();
    log(imageUrl);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StatusPicture(
          user: apis.me,
          imageUrl: imageUrl,
        ),
      ),
    );
  }

  // static Future<void> sendingStatusImage(
  //     ChatUser user, String path, BuildContext context) async {
  //   String date = DateTime.now().toString();

  //   await FirebaseFirestore.instance
  //       .collection("Status")
  //       .doc(user.Id)
  //       .collection('my_status')
  //       .add({
  //     "user": user.Id,
  //     "create_date": date,
  //     "status_text": "",
  //     "image_path": path,
  //     "color_id": "",
  //     "family_id": ""
  //   }).then((value) {
  //     log(value.id);
  //     Navigator.pop(context);
  //   }).catchError((error) => log("Failed to add new note due to $error"));
  // }

  // static Future<void> sendingStatusNote(ChatUser user, String text, int color,
  //     int family, BuildContext context) async {
  //   String date = DateTime.now().toString();

  //   await FirebaseFirestore.instance
  //       .collection("Status")
  //       .doc(user.Id)
  //       .collection('my_status')
  //       .add({
  //     "user": user.Id,
  //     "create_date": date,
  //     "status_text": text,
  //     "image_path": "",
  //     "color_id": color,
  //     "family_id": family,
  //   }).then((value) {
  //     log(value.id);
  //     Navigator.pop(context);
  //   }).catchError((error) => log("Failed to add new note due to $error"));
  // }
  static Future<List<Map<String, dynamic>>> getStatus(ChatUser user) async {
  List<Map<String, dynamic>> statusList = [];
  try {
    log('Fetching status for user: ${user.Id}');
    
    final QuerySnapshot<Map<String, dynamic>> statusSnapshot = await firestore
        .collection('Status')
        .doc(user.Id)
        .collection('my_status')
        .get();

    log('Fetched ${statusSnapshot.docs.length} status documents');

    statusList = statusSnapshot.docs.map((doc) => doc.data()).toList();

    log('Status List from getStatus: $statusList'); // Tambahkan log ini untuk debugging
  } catch (e) {
    log('Error getting status: $e');
  }
  return statusList;
}


  static Future<void> sendingStatusImage(
      ChatUser user, String path, BuildContext context) async {
    String date = DateTime.now().toString();

    try {
      // Menambahkan story ke koleksi my_status pengguna
      final storyRef = await firestore
          .collection("Status")
          .doc(user.Id)
          .collection('my_status')
          .add({
        "user": user.Id,
        "create_date": date,
        "status_text": "",
        "image_path": path,
        "color_id": "",
        "family_id": ""
      });

      // Mendapatkan semua pengguna yang memiliki user di daftar kontak mereka
      final contactUsersSnapshot = await firestore
          .collection('Users')
          .doc(user.Id)
          .collection('my_users')
          .where('isArchived', isEqualTo: false)
          .get();

      // Menambahkan referensi story ke kontak pengguna
      for (var contactUser in contactUsersSnapshot.docs) {
        await firestore
            .collection('Users')
            .doc(contactUser.id)
            .collection('contact_status')
            .doc(storyRef.id)
            .set({
          'storyId': storyRef.id,
          'userId': user.Id,
          'create_date': date,
          'image_path': path,
          'status_text': "",
        });
      }

      log("Story added successfully");
      Navigator.pop(context);
    } catch (error) {
      log("Failed to add story due to $error");
    }
  }

  static Future<void> sendingStatusNote(ChatUser user, String text, int color,
      int family, BuildContext context) async {
    String date = DateTime.now().toString();

    try {
      // Menambahkan story ke koleksi my_status pengguna
      final storyRef = await firestore
          .collection("Status")
          .doc(user.Id)
          .collection('my_status')
          .add({
        "user": user.Id,
        "create_date": date,
        "status_text": text,
        "image_path": "",
        "color_id": color,
        "family_id": family,
      });

      // Mendapatkan semua pengguna yang memiliki user di daftar kontak mereka
      final contactUsersSnapshot = await firestore
          .collection('Users')
          .doc(user.Id)
          .collection('my_users')
          .where('isArchived', isEqualTo: false)
          .get();

      // Menambahkan referensi story ke kontak pengguna
      for (var contactUser in contactUsersSnapshot.docs) {
        await firestore
            .collection('Users')
            .doc(contactUser.id)
            .collection('contact_status')
            .doc(storyRef.id)
            .set({
          'storyId': storyRef.id,
          'userId': user.Id,
          'create_date': date,
          'status_text': text,
          'image_path': "",
        });
      }

      log("Story added successfully");
      Navigator.pop(context);
    } catch (error) {
      log("Failed to add story due to $error");
    }
  }

  static Stream<QuerySnapshot> getStatusUpdates() {
    return firestore
        .collection('Status')
        .doc(user.uid)
        .collection('my_status')
        .orderBy('create_date', descending: true)
        .snapshots();
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

  static Future<void> archiveChat(String userId, String contactUserId) async {
    try {
      final userDoc = firestore
          .collection('Users')
          .doc(userId)
          .collection('my_users')
          .doc(contactUserId);

      final docSnapshot = await userDoc.get();
      if (docSnapshot.exists) {
        await userDoc.update({
          'isArchived': true,
        });
        log('Chat archived successfully for contact user ID: $contactUserId');
      } else {
        log('Error archiving chat: Document not found for contact user ID: $contactUserId');
      }
    } catch (e) {
      log('Error archiving chat: $e');
    }
  }

  static Future<void> unarchiveChat(String userId, String contactUserId) async {
    try {
      final userDoc = firestore
          .collection('Users')
          .doc(userId)
          .collection('my_users')
          .doc(contactUserId);

      final docSnapshot = await userDoc.get();
      if (docSnapshot.exists) {
        await userDoc.update({
          'isArchived': false,
        });
        log('Chat unarchived successfully for contact user ID: $contactUserId');
      } else {
        log('Error unarchiving chat: Document not found for contact user ID: $contactUserId');
      }
    } catch (e) {
      log('Error unarchiving chat: $e');
    }
  }

  static Future<void> blockUser(String userId, String blockedUserId) async {
    try {
      await firestore
          .collection('Users')
          .doc(userId)
          .collection('my_users')
          .doc(blockedUserId)
          .update({'isBlocked': true});
      log('User $blockedUserId has been blocked by $userId.');
    } catch (e) {
      log('Error blocking user: $e');
      // Tambahkan kode untuk menangani error, misalnya dengan menampilkan pesan kepada pengguna
    }
  }

  // Method untuk membuka blokir pengguna
  static Future<void> unblockUser(String userId, String blockedUserId) async {
    try {
      await firestore
          .collection('Users')
          .doc(userId)
          .collection('my_users')
          .doc(blockedUserId)
          .update({'isBlocked': false});
      log('User $blockedUserId has been unblocked by $userId.');
    } catch (e) {
      log('Error unblocking user: $e');
      // Tambahkan kode untuk menangani error, misalnya dengan menampilkan pesan kepada pengguna
    }
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream(
      String userId) {
    return firestore.collection('Users').doc(userId).snapshots();
  }

  static Future<void> deleteConversation(String otherUserId) async {
    try {
      // Get the conversation ID
      String conversationId = getConversationID(otherUserId);

      // Reference to the messages subcollection
      final messagesRef =
          firestore.collection('Chats/$conversationId/Messages');

      // Get all messages in the conversation
      final messagesSnapshot = await messagesRef.get();

      // Iterate through each message and delete it
      for (var doc in messagesSnapshot.docs) {
        Messages message = Messages.fromJson(doc.data());
        await firestore
            .collection('Chats/$conversationId/Messages')
            .doc(message.sent)
            .delete();

        // If the message is an image, delete it from Firebase Storage
        if (message.type == Type.image) {
          await storage.refFromURL(message.msg).delete();
        }
      }

      log('Successfully deleted all messages in the conversation with ID: $conversationId.');
    } catch (e) {
      log('Error deleting conversation: $e');
    }
  }
}
