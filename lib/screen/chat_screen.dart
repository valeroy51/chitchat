import 'package:chitchat/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/main.dart';
import 'package:flutter/cupertino.dart';

class ChatScreen extends StatefulWidget{
  final ChatUser user;


  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: _appBar(),
        ),
      ),
    );
  }

  Widget _appBar(){
    return Row(
      children: [
        IconButton(
          onPressed: () {}, 
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black54,
        )),

        ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .3),
              child: CachedNetworkImage(
                  width: mq.height * .055,
                  height: mq.height * .055,
                  imageUrl: widget.user.Image,
                  // placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      CircleAvatar(child: Icon(CupertinoIcons.person))),
            )
      ],
    );
  }
}

