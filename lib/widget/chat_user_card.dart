import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/api/api.dart';
import 'package:chitchat/helper/mydateutil.dart';
import 'package:chitchat/main.dart';
import 'package:chitchat/models/Message.dart';
import 'package:chitchat/models/chatuser.dart';
import 'package:chitchat/screen/chatscreen.dart';
import 'package:chitchat/widget/dialog/profiledialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class chatUserCard extends StatefulWidget {
  final ChatUser user;
  const chatUserCard({super.key, required this.user});
  @override
  State<chatUserCard> createState() => _chatUserCardState();
}

class _chatUserCardState extends State<chatUserCard> {
  Messages? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .001, vertical: 0.1),
      color: Colors.lightBlue.shade50,
      elevation: 0.5,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => chatScreen(user: widget.user)));
          },
          child: StreamBuilder(
              stream: apis.getLastMessage(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => Messages.fromJson(e.data())).toList() ??
                        [];
                if (list.isNotEmpty) {
                  _message = list[0];
                }
                return ListTile(
                  // leading: const CircleAvatar child: Icon(CupertinoIcons.person),
// ),
                  leading: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => ProfileDialog(user: widget.user));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * .3),
                      child: CachedNetworkImage(
                          width: mq.height * .055,
                          height: mq.height * .055,
                          imageUrl: widget.user.Image,
                          // placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                                  child: Icon(CupertinoIcons.person))),
                    ),
                  ),
                  title: Text(widget.user.Name),
                  subtitle: Text(
                    _message != null
                        ? _message!.type == Type.image
                            ? 'image'
                            : _message!.msg
                        : widget.user.About,
                    maxLines: 1,
                  ),
                  trailing: _message == null
                      ? null
                      : _message!.read.isEmpty &&
                              _message!.fromId != apis.user.uid
                          ? Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                  color: Colors.lightGreenAccent.shade400,
                                  borderRadius: BorderRadius.circular(10)),
                            )
                          : Text(
                              MyDateUtil.getLastMessageTime(
                                  context: context, time: _message!.sent),
                              style: const TextStyle(color: Colors.black54)),
                );
              })),
    );
  }
}
