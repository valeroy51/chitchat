import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/main.dart';
import 'package:chitchat/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

        body: Column(
          children: [_chatInput()],
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

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child :Row(
                children: [
                  IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.emoji_emotions,
                            color: Colors.blueAccent,
                            size: 25
                          )),
          
                   const Expanded(child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      hintStyle: TextStyle(color: Colors.blueAccent),
                      border: InputBorder.none
                    ),
                  )),
          
                  IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.image,
                            color: Colors.blueAccent,
                            size: 26
                          )),
                    IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.blueAccent,
                          )),
                    SizedBox(width: mq.width * .02,)
              ],),),
          ),
    
          MaterialButton(onPressed: (){},
            color: Colors.green,
            minWidth: 0,
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: CircleBorder(),
            child: Icon(Icons.send, color: Colors.white, size: 28),)
        ],
      ),
    );
  }
}
