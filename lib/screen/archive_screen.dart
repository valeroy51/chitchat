import 'package:chitchat/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Cloud Firestore
import 'package:chitchat/models/chatuser.dart';
import 'package:chitchat/widget/chat_user_card.dart';
import '../api/api.dart';

class ArchiveScreen extends StatefulWidget {
  final String userId;

  const ArchiveScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Initialize the Stream of archived chats
  }

  void _removeArchivedUser(ChatUser user) {
    setState(() {
      _list.removeWhere((element) => element.Id == user.Id);
      _searchList.removeWhere((element) => element.Id == user.Id);
    });
  }

  void _unarchiveChat(ChatUser user) {
    setState(() {
      _list.removeWhere((element) => element.Id == user.Id);
      _searchList.removeWhere((element) => element.Id == user.Id);
    });
    apis.unarchiveChat(user.Id);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
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
                    }
                    setState(() {});
                  },
                )
              : const Text('Archived Chats'),
          backgroundColor: Colors.indigo,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(_isSearching ? Icons.clear : Icons.search)),
          ],
        ),
        body: StreamBuilder(
          stream: apis.getMyUsersId(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:
              case ConnectionState.done:
                return StreamBuilder(
                  stream: apis.getAllUsers(
                      snapshot.data?.docs.map((e) => e.id).toList() ?? []),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        _list = data
                                ?.map((e) => ChatUser.fromJson(e.data()))
                                .toList() ??
                            [];
                        _list = _list
                            .where((user) => user.isArchived)
                            .toList(); // Filter users that are archived

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                              itemCount: _isSearching
                                  ? _searchList.length
                                  : _list.length,
                              padding: EdgeInsets.only(top: mq.height * .001),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ChatUserCard(
                                    user: _isSearching
                                        ? _searchList[index]
                                        : _list[index],
                                    onArchive:
                                        _unarchiveChat); // Set callback onArchive
                              });
                        } else {
                          return const Center(
                            child: Text('No archived chats found',
                                style: TextStyle(fontSize: 20)),
                          );
                        }
                    }
                  },
                );
            }
          },
        ),
      ),
    );
  }
}
