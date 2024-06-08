import 'dart:math';
import 'package:chitchat/helper/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StatusNote extends StatefulWidget {
  StatusNote({super.key});

  @override
  State<StatusNote> createState() => _StatusNodeState();
}

class _StatusNodeState extends State<StatusNote> {
  int color_id = Random().nextInt(AppStyle.cardsColor.length);
  int family_id = Random().nextInt(AppStyle.family.length);
  String date = DateTime.now().toString();
  TextEditingController _statusController = TextEditingController();

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
        backgroundColor: AppStyle.cardsColor[color_id],
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              onPressed: () {},
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
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: "Type a status"),
              style: AppStyle.statusNote.copyWith(
                fontFamily: AppStyle.family[family_id].fontFamily,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyle.bgColor,
        onPressed: () {
          {
            // FirebaseFirestore.instance.collection("Notes").add({
            //   "note_title": _titleController.text,
            //   "creation_date": date,
            //   "note_content": _mainController.text,
            //   "color_id": color_id
            // }).then((value) {
            //   print(value.id);
            //   Navigator.pop(context);
            // }).catchError(
            //     (error) => print("Failed to add new note due to $error"));
          }
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}
