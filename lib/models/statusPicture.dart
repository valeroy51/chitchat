import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/api/api.dart';
import 'package:chitchat/helper/style.dart';
import 'package:chitchat/models/chatuser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatusPicture extends StatefulWidget {
  final ChatUser user;
  final String imageUrl;

  const StatusPicture({super.key, required this.user, required this.imageUrl});

  @override
  State<StatusPicture> createState() => _StatusPictureState();
}

class _StatusPictureState extends State<StatusPicture> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(CupertinoIcons.arrow_left),
        ),
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: widget.imageUrl,
          placeholder: (context, url) => const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(strokeWidth: 5),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyle.bgColor,
          onPressed: () async {
          {
            await apis.sendingStatusImage(
                apis.me, widget.imageUrl, context);
          }
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}
