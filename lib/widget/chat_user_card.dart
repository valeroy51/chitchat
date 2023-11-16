import 'package:chitchat/main.dart';
import 'package:chitchat/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class chatUserCard extends StatefulWidget {
  final ChatUser user;

  const chatUserCard({super.key, required this.user});

  @override
  State<chatUserCard> createState() => _chatUserCardState();
}

class _chatUserCardState extends State<chatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .001, vertical: 0.1),
      color: Colors.blue.shade50,
      elevation: 0.5,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: InkWell(
        onTap: () {},
        child:  ListTile(
          leading: const CircleAvatar(
            child: Icon(CupertinoIcons.person),
          ),
          title: Text(widget.user.Name),
          subtitle: Text(widget.user.About,
            maxLines: 1,
          ),
          trailing: const Text(
            '13:00',
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
