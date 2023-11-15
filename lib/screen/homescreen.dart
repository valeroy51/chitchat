import 'dart:convert';
import 'dart:developer';

import 'package:chitchat/api/api.dart';
import 'package:chitchat/main.dart';
import 'package:chitchat/widget/chat_user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.home),
        title: const Text('ChitChat'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () async {
            await apis.auth.signOut();
            await GoogleSignIn().signOut();
          },
          child: const Icon(Icons.add_comment_rounded),
        ),
      ),
      body: StreamBuilder(
        stream: apis.firestore.collection('Users').snapshots(),
        builder: (context, snapshot) {
          final list = [];

          if (snapshot.hasData) {
            final data = snapshot.data?.docs;
            for (var i in data!) {
              log('Data: ${jsonEncode(i.data())}');
              list.add(i.data()['Name']);
            }
          }
          return ListView.builder(
              itemCount: list.length,
              // padding: EdgeInsets.only(top: mq.height * .005),
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                // return const chatUserCard();
                return Text('Name : ${list[index]}');
              });
        },
      ),
    );
  }
}
