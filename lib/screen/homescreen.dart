import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/models/chatuser.dart';
import 'package:chitchat/screen/NoteScreen.dart';
import 'package:chitchat/screen/profilescreen.dart';
import 'package:chitchat/screen/status/StatusWidget.dart';
import 'package:chitchat/widget/chat_user_card.dart';
import 'package:chitchat/widget/QRCodeScannerScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../api/api.dart';
import '../helper/dialog.dart';
import '../main.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    apis.getSelfInfo();
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');

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
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: Colors.indigo),
            leading: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NoteScreen(user: apis.me),
                  ),
                );
              },
              child: const Icon(CupertinoIcons.bookmark),
            ),
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
                          setState(() {
                            _searchList;
                          });
                        }
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
                            builder: (_) => ProfileScreen(user: apis.me)));
                  },
                  icon: const Icon(Icons.more_vert)),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
                onPressed: () {
                  _addChatUserDialog();
                },
                child: const Icon(Icons.add_comment_rounded)),
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
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                                  ?.map((e) => ChatUser.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                                itemCount: _isSearching
                                    ? _searchList.length
                                    : _list.length,
                                padding: EdgeInsets.only(top: mq.height * .001),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return chatUserCard(
                                      user: _isSearching
                                          ? _searchList[index]
                                          : _list[index]);
                                });
                          } else {
                            return const Center(
                              child: Text('Invite teman dengan akun Gmail!',
                                  style: TextStyle(fontSize: 20)),
                            );
                          }
                      }
                    },
                  );
              }
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _index,
            type: BottomNavigationBarType.shifting,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home),
                  label: 'Home',
                  backgroundColor: Colors.indigo),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.bell),
                  label: 'Status',
                  backgroundColor: Colors.indigo)
            ],
            onTap: (Index) {
              if (_index == Index) {
              } else {
                setState(() {
                  _index = Index;
                  if (Index == 1) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const StatusWidget()));
                  }
                  if (Index == 0) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const homeScreen()));
                  }
                });
              }
            },
          ),
        ),
      ),
    );
  }

bool _isDialogOpen = false;


void _addChatUserDialog() async {
  String email = '';

  // Memeriksa apakah dialog sedang terbuka
  if (_isDialogOpen) return;

  _isDialogOpen = true; // Set flag dialog terbuka menjadi true

  // Fungsi untuk memunculkan dialog
  void showDialogAgain() async {
    await Future.delayed(Duration.zero);
    _addChatUserDialog(); // Memanggil fungsi untuk menampilkan dialog lagi
  }

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) {
        return WillPopScope(
          onWillPop: () async {
            _isDialogOpen = false; // Set flag dialog terbuka menjadi false saat dialog ditutup
            showDialogAgain(); // Memunculkan dialog lagi
            return true;
          },
          child: AlertDialog(
            contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Row(
              children: [
                Icon(Icons.person_add, color: Colors.blue, size: 28),
                Text('  Add User')
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  maxLines: null,
                  onChanged: (value) => email = value,
                  decoration: InputDecoration(
                    hintText: 'Email Id',
                    prefixIcon: const Icon(Icons.email, color: Colors.blue),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QRCodeScannerScreen(
                          onScan: (String result) async {
                            log('Scanned Value: $result');
                            setState(() {
                              email = result;
                            });

                            // Fetch user data based on scanned email
                            ChatUser? user = await apis.getUserByEmail(email);
                            if (user != null) {
                              // Display user information
                              _showUserInfoDialog(user);
                            } else {
                              log('User with email $email does not exist.');
                            }
                          },
                        ),
                      ),
                    );

                    _isDialogOpen = false; // Set flag dialog terbuka menjadi false setelah selesai pemindaian QR
                    showDialogAgain(); // Memunculkan dialog lagi setelah pemindaian QR selesai
                  },
                  icon: Icon(Icons.qr_code_scanner),
                  label: Text('Scan QR Code'),
                ),
                if (email.isNotEmpty) ...[
                  SizedBox(height: 10),
                  Text('Scanned Email: $email', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ],
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  _isDialogOpen = false; // Set flag dialog terbuka menjadi false saat tombol cancel diklik
                },
                child: const Text('Cancel', style: TextStyle(color: Colors.blue, fontSize: 16)),
              ),
              MaterialButton(
                onPressed: () async {
                  Navigator.pop(context);
                  _isDialogOpen = false; // Set flag dialog terbuka menjadi false setelah tombol add diklik
                  if (email.isNotEmpty) {
                    bool userExists = await apis.addChatUser(email);
                    if (!userExists) {
                      log('Failed to add user with email $email.');
                    }
                  }
                },
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              )
            ],
          ),
        );
      },
    ),
  );
}



void _showUserInfoDialog(ChatUser user) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('User Information'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .1),
            child: CachedNetworkImage(
              width: mq.height * .1,
              height: mq.height * .1,
              fit: BoxFit.cover,
              imageUrl: user.Image,
              errorWidget: (context, url, error) => const CircleAvatar(
                child: Icon(CupertinoIcons.person),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(user.Name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(user.Email, style: TextStyle(fontSize: 14)),
          SizedBox(height: 5),
          Text(user.About, style: TextStyle(fontSize: 14)),
        ],
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close', style: TextStyle(color: Colors.blue, fontSize: 16)),
        ),
        MaterialButton(
          onPressed: () async {
            await apis.addChatUser(user.Email);
            Navigator.pop(context);
          },
          child: const Text(
            'Add',
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
        )
      ],
    ),
  );
}
}
