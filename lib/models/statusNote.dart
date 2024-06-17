import 'dart:io';
import 'dart:math';
import 'package:chitchat/api/api.dart';
import 'package:chitchat/helper/style.dart';
import 'package:chitchat/main.dart';
import 'package:chitchat/models/chatuser.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatusNote extends StatefulWidget {
  final ChatUser user;
  const StatusNote({super.key, required this.user});

  @override
  State<StatusNote> createState() => _StatusNoteState();
}

class _StatusNoteState extends State<StatusNote> {
  int color_id = Random().nextInt(AppStyle.cardsColor.length);
  int family_id = Random().nextInt(AppStyle.family.length);
  String date = DateTime.now().toString();
  final TextEditingController _statusController = TextEditingController();
  bool _showEmoji = false;

  void initState() {
    apis.getSelfInfo();
  }

  void changeColor() {
    setState(() {
      color_id = (color_id + 1) % AppStyle.cardsColor.length;
    });
  }

  void changeFamily() {
    setState(() {
      family_id = (family_id + 1) % AppStyle.family.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[color_id],
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: const Icon(CupertinoIcons.arrow_left),
        ),
        backgroundColor: AppStyle.cardsColor[color_id],
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                setState(() => _showEmoji = !_showEmoji);
              },
              icon: const Icon(Icons.sentiment_satisfied_outlined)),
          IconButton(
              onPressed: () {
                changeFamily();
              },
              icon: const Icon(Icons.text_fields_outlined)),
          IconButton(
              onPressed: () {
                changeColor();
              },
              icon: const Icon(Icons.color_lens_outlined)),
        ],
      ),
      body: Column(
        children: [
          const Spacer(flex: 2),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _statusController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onTap: () {
                if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
              },
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "Type a status"),
              style: AppStyle.statusNote.copyWith(
                fontFamily: AppStyle.family[family_id],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(flex: 3),
          if (_showEmoji)
            SizedBox(
              height: mq.height * .35,
              child: EmojiPicker(
                textEditingController: _statusController,
                config: Config(
                  bgColor: const Color.fromARGB(255, 234, 248, 255),
                  columns: 7,
                  initCategory: Category.FOODS,
                  emojiSizeMax: 32 * (Platform.isAndroid ? 1.30 : 1.0),
                ),
              ),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyle.bgColor,
        onPressed: () async {
          {
            await apis.sendingStatusNote(
                apis.me, _statusController.text, color_id, family_id, context);
                Navigator.pop(context);
          }
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}
