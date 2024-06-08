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

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  final Function onArchive;

  const ChatUserCard({Key? key, required this.user, required this.onArchive})
      : super(key: key);

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
  
  void onDelete(String userId) {}
  
  void onBlock(String userId) {}
}

class _ChatUserCardState extends State<ChatUserCard> {
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
            MaterialPageRoute(builder: (_) => chatScreen(user: widget.user)),
          );
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
            return ListTile(
              leading: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => ProfileDialog(user: widget.user),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .3),
                  child: CachedNetworkImage(
                    width: mq.height * .055,
                    height: mq.height * .055,
                    imageUrl: widget.user.Image,
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),
              ),
              title: Text(widget.user.Name,style: TextStyle(fontWeight: FontWeight.bold),),
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
                      ? Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.lightGreenAccent.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )
                      : Text(
                          MyDateUtil.getLastMessageTime(
                              context: context, time: _message!.sent),
                          style: const TextStyle(color: Colors.black54),
                        ),
            );
          },
        ),
      ),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          leading: Icon(
              widget.user.isArchived ? Icons.unarchive : Icons.archive,
              size: 30),
          title: Text(widget.user.isArchived ? 'Unarchive' : 'Archive',
              style: const TextStyle(fontSize: 18)),
          onTap: () async {
            Navigator.pop(context);
            if (widget.user.isArchived) {
              await apis.unarchiveChat(widget.user.Id);
            } else {
              await apis().archiveChat(widget.user.Id);
            }
            widget.onArchive(widget.user);
          },
        ),
        ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: const Icon(Icons.delete, size: 30),
        title: const Text('Delete Chat', style: TextStyle(fontSize: 18)),
        onTap: () async {
          Navigator.pop(context);
          // Panggil fungsi untuk menghapus chat dari halaman utama
          await apis.deleteChatFromMainPage(widget.user.Id); 
        },
      ),

        Container(
          margin: const EdgeInsets.only(bottom: 30),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            leading: const Icon(Icons.block, size: 30),
            title: const Text('Block Contact', style: TextStyle(fontSize: 18)),
            onTap: () async {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    ),
  );
}
}