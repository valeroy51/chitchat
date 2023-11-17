import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/main.dart';
import 'package:chitchat/models/chat_user.dart';
import 'package:chitchat/screen/chatscreen.dart';
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
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => chatScreen(user: widget.user)));
        },
        child: ListTile(
            // leading: const CircleAvatar child: Icon(CupertinoIcons.person),
// ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .3),
              child: CachedNetworkImage(
                  width: mq.height * .055,
                  height: mq.height * .055,
                  imageUrl: widget.user.Image,
                  // placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      const CircleAvatar(child: Icon(CupertinoIcons.person))),
            ),
            title: Text(widget.user.Name),
            subtitle: Text(
              widget.user.About,
              maxLines: 1,
            ),
            trailing: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                  color: Colors.lightGreenAccent.shade400,
                  borderRadius: BorderRadius.circular(10)),
            )
            //  trailing: const Text(
            //  '13:00',
            //  style: TextStyle(color: Colors.black54),
//  ),
            ),
      ),
    );
  }
}
