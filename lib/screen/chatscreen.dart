import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/api/api.dart';
import 'package:chitchat/main.dart';
import 'package:chitchat/models/Message.dart';
import 'package:chitchat/models/chat_user.dart';
import 'package:chitchat/widget/message_card.dart';
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
  List<Messages> _list = [];

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),

        backgroundColor: const Color.fromARGB(255, 234, 248, 255),

        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
              stream: apis.getAllMessages(widget.user),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const SizedBox();
            
                  case ConnectionState.active:
                  case ConnectionState.done:
                  final data = snapshot.data?.docs;
                    _list =
                        data?.map((e) => Messages.fromJson(e.data())).toList() ??
                            [];
                    

                    if (_list.isNotEmpty) {
                      return ListView.builder(
                          itemCount:
                              _list.length,
                          padding: EdgeInsets.only(top: mq.height * .01),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) { 
                            return MessageCard(message: _list[index]);
                          });
                    } else {
                      return const Center(
                          child: Text(
                        'Say Hi !!!',
                        style: TextStyle(fontSize: 20),
                      ));
                    }
                }
              },
                      ),
            ),
            
            _chatInput()],
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
          
                  Expanded(
                      child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
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
    
          MaterialButton(onPressed: (){
            if(_textController.text.isNotEmpty) {
              apis.sendMessage(widget.user, _textController.text);
              _textController.text = '';
            }
          },
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
