import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/main.dart';
import 'package:chitchat/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class chatScreen extends StatefulWidget {
  final ChatUser user;
  const chatScreen({super.key, required this.user});

  @override
  State<chatScreen> createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
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

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .3),
            child: CachedNetworkImage(
                width: mq.height * .05,
                height: mq.height * .05,
                imageUrl: widget.user.Image,
                // placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(CupertinoIcons.person))),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.Name,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 2,
              ),
              const Text(
                'Last seen not available',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              )
            ],
          )
        ],
      ),
    );
  }
}
