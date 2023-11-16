import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/api/api.dart';
import 'package:chitchat/models/chat_user.dart';
import 'package:chitchat/screen/login/loginscreen.dart';
import 'package:chitchat/widget/chat_user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chitchat/main.dart';
import 'package:chitchat/helper/dialog.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile Screen'),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.redAccent,
            onPressed: () async {
              dialog.showProgressBar(context);
              await apis.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  Navigator.pop(context);

                  Navigator.pop(context);

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => loginScreen()));
                });
              });
            },
            icon: const Icon(Icons.add_comment_rounded),
            label: const Text("Logout"),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: Column(
            children: [
              SizedBox(
                width: mq.width,
                height: mq.height * .03,
              ),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * 1),
                    child: CachedNetworkImage(
                        width: mq.height * .2,
                        height: mq.height * .2,
                        fit: BoxFit.fill,
                        imageUrl: widget.user.Image,
                        // placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                                child: Icon(CupertinoIcons.person))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: MaterialButton(
                      elevation: 1,
                      onPressed: () {},
                      shape: const CircleBorder(),
                      color: Colors.white,
                      child: Icon(Icons.edit, color: Colors.blue),
                    ),
                  )
                ],
              ),
              SizedBox(height: mq.height * .03),
              Text(widget.user.Email,
                  style: const TextStyle(color: Colors.black, fontSize: 16)),
              SizedBox(height: mq.height * .05),
              TextFormField(
                initialValue: widget.user.Name,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person, color: Colors.blue),
                    border: OutlineInputBorder(),
                    hintText: "eg. ",
                    label: const Text("Name")),
              ),
              SizedBox(height: mq.height * .02),
              TextFormField(
                initialValue: widget.user.About,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.info_outline, color: Colors.blue),
                    border: OutlineInputBorder(),
                    hintText: "eg. Feeling Happy",
                    label: const Text("About")),
              ),
              SizedBox(height: mq.height * .05),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    minimumSize: Size(mq.width * .5, mq.height * .06)),
                onPressed: () {},
                icon: Icon(Icons.edit),
                label: const Text("UPDATE"),
              )
            ],
          ),
        ));
  }
}
