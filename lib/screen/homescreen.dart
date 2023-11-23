import 'dart:developer';
import 'package:chitchat/api/api.dart';
import 'package:chitchat/models/chatuser.dart';
import 'package:chitchat/screen/profilescreen.dart';
import 'package:chitchat/widget/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});
  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    apis.getSelfinfo();

    apis.updateActiveStatus(true);

    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Messages: $message');
      if (apis.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          apis.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          apis.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: const Icon(CupertinoIcons.home),
            title: _isSearching
                ? TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Name, Email, ...'),
                    autofocus: true,
                    style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                    onChanged: (val) {
                      _searchList.clear();
                      for (var i in _list) {
                        if (i.Name.toLowerCase().contains(val.toLowerCase()) ||
                            i.Email.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                  )
                : const Text('ChitChat'),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                                  user: apis.me,
                                )));
                  },
                  icon: const Icon(Icons.more_vert))
            ],
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: Colors.indigo),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add_comment_rounded),
            ),
          ),
          body: StreamBuilder(
            stream: apis.getAllUser(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  _list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];
                  if (_list.isNotEmpty) {
                    return ListView.builder(
                        itemCount:
                            _isSearching ? _searchList.length : _list.length,
                        // padding: EdgeInsets.only(top: mq.height * .01),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return chatUserCard(
                            user: _isSearching
                                ? _searchList[index]
                                : _list[index],
                          );
                          // return Text('Name : ${list[index]}');
                        });
                  } else {
                    return const Center(
                        child: Text(
                      'Terjadi kesalahan, tolong periksa internet anda!',
                      style: TextStyle(fontSize: 20),
                    ));
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
