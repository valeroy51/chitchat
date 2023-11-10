import 'package:chitchat/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class chatUserCard extends StatefulWidget {
  const chatUserCard({super.key});

  @override
  State<chatUserCard> createState() => _chatUserCardState();
}

class _chatUserCardState extends State<chatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .001, vertical: 0.1),
      color: Colors.blue.shade100,
      elevation: 0.5,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: InkWell(
        onTap: () {},
        child: const ListTile(
          leading: CircleAvatar(
            child: Icon(CupertinoIcons.person),
          ),
          title: Text('chitchat'),
          subtitle: Text(
            'Thank you for choosing ChitChat',
            maxLines: 1,
          ),
          trailing: Text(
            '13:00',
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
