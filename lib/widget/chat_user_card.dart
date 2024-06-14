import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/api/api.dart';
import 'package:chitchat/helper/mydateutil.dart';
import 'package:chitchat/main.dart';
import 'package:chitchat/models/Message.dart';
import 'package:chitchat/models/chatuser.dart';
import 'package:chitchat/screen/chatscreen.dart';
import 'package:chitchat/widget/dialog/profiledialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  final Function onArchive;
  final bool isArchivedScreen;

  const ChatUserCard({
    Key? key,
    required this.user,
    required this.onArchive,
    required this.isArchivedScreen,
  }) : super(key: key);

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Messages? _message;
  bool _isBlocked = false;

  @override
  void initState() {
    super.initState();
    _loadBlockStatus();
  }

Future<void> _loadBlockStatus() async {
  bool isBlocked = await _getBlockStatus(widget.user.Id);
  if (mounted) {
    setState(() {
      _isBlocked = isBlocked;
    });
  }
}


  Future<void> _saveBlockStatus(String userId, bool isBlocked) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('blocked_$userId', isBlocked);
  }

  Future<bool> _getBlockStatus(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('blocked_$userId') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .001, vertical: 0.1),
      color: Colors.lightBlue.shade50,
      elevation: 0.5,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: InkWell(
        onTap: () {
          if (!_isBlocked) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => chatScreen(user: widget.user)),
            );
          }
        },
        onLongPress: () {
          _showOptions(context);
        },
        child: StreamBuilder(
          stream: apis.getLastMessage(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => Messages.fromJson(e.data())).toList() ?? [];
            if (list.isNotEmpty) {
              _message = list[0];
            }
            if (_isBlocked) {
              return _blockedUserTile();
            } else {
              return _normalUserTile();
            }
          },
        ),
      ),
    );
  }

  ListTile _normalUserTile() {
    return ListTile(
      leading: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => ProfileDialog(user: widget.user),
          );
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .3),
              child: CachedNetworkImage(
                width: mq.height * .055,
                height: mq.height * .055,
                imageUrl: widget.user.Image,
                errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(CupertinoIcons.person)),
              ),
            ),
            if (widget.user.IsOnline)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 43, 144, 47),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
          ],
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
          : _message!.read.isEmpty && _message!.fromId != apis.user.uid
              ? Container()
              : Text(
                  MyDateUtil.getLastMessageTime(
                      context: context, time: _message!.sent),
                  style: const TextStyle(color: Colors.black54),
                ),
    );
  }

  ListTile _blockedUserTile() {
    return ListTile(
      leading: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => ProfileDialog(user: widget.user),
          );
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .3),
              child: CachedNetworkImage(
                width: mq.height * .055,
                height: mq.height * .055,
                imageUrl: widget.user.Image,
                errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(CupertinoIcons.person)),
              ),
            ),
            if (widget.user.IsOnline)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 43, 144, 47),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    )),
                ),
              ),
          ],
        ),
      ),
      title: Text(widget.user.Name),
      subtitle: const Text('Blocked'),
      trailing: const Icon(Icons.block, color: Colors.red),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            leading: Icon(
              widget.isArchivedScreen ? Icons.unarchive : Icons.archive,
              size: 30,
            ),
            title: Text(
              widget.isArchivedScreen ? 'Unarchive' : 'Archive',
              style: const TextStyle(fontSize: 18),
            ),
            onTap: () async {
              Navigator.pop(context);
              try {
                if (widget.isArchivedScreen) {
                  await apis.unarchiveChat(apis.user.uid, widget.user.Id);
                } else {
                  await apis.archiveChat(apis.user.uid, widget.user.Id);
                }
                widget.onArchive(widget.user);
              } catch (error) {
                print('Error during archive/unarchive: $error');
              }
            },
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            leading: const Icon(Icons.delete, size: 30),
            title: const Text('Delete Chat', style: TextStyle(fontSize: 18)),
            onTap: () async {
              Navigator.pop(context);
              // Panggil fungsi untuk menghapus chat dari halaman utama
                 await apis.deleteConversation(widget.user.Id);
            },
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 30),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: const Icon(Icons.block, size: 30),
              title: Text(
                _isBlocked ? 'Unblock Contact' : 'Block Contact',
                style: const TextStyle(fontSize: 18),
              ),
              onTap: () async {
                Navigator.pop(context);
                if (_isBlocked) {
                  // Tampilkan dialog konfirmasi sebelum unblock
                  _showConfirmationDialog(widget.user);
                } else {
                  // Tampilkan dialog konfirmasi sebelum block
                  _showConfirmationDialog(widget.user);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(ChatUser user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_isBlocked ? 'Unblock Contact' : 'Block Contact'),
          content: Text(
              'Are you sure you want to ${_isBlocked ? 'unblock' : 'block'} ${widget.user.Name}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Tutup dialog
                if (_isBlocked) {
                  await _unblockUser(user); // Unblock pengguna setelah dialog ditutup
                } else {
                  await _blockUser(user); // Block pengguna setelah dialog ditutup
                }
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

Future<void> _blockUser(ChatUser user) async {
  try {
    await _saveBlockStatus(widget.user.Id, true);
    await apis.blockUser(apis.user.uid, widget.user.Id);
    // Perbarui status blokir pengguna di database dan shared preferences
    
    if (mounted) {
      setState(() {
        _isBlocked = true; // Update local state
      });
    }
    
  } catch (error) {
    print('Error blocking user: $error');
  }
}

Future<void> _unblockUser(ChatUser user) async {
  try {
     await _saveBlockStatus(widget.user.Id, false);
    await apis.unblockUser(apis.user.uid, widget.user.Id);
    // Hapus status blokir pengguna dari database dan shared preferences
   
    if (mounted) {
      setState(() {
        _isBlocked = false; // Update local state
      });
    }
  } catch (error) {
    print('Error unblocking user: $error');
  }
}


}
