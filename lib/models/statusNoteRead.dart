import 'package:chitchat/helper/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StatusNoteRead extends StatefulWidget {
  StatusNoteRead(this.doc, {super.key});
  QueryDocumentSnapshot doc;
  @override
  State<StatusNoteRead> createState() => _StatusNoteReadState();
}

class _StatusNoteReadState extends State<StatusNoteRead> {
  @override
  Widget build(BuildContext context) {
    int color_id = widget.doc['color_id'];
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[color_id],
      body: Column(
        children: [
          const Spacer(flex: 2),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.doc["status_text"],
                style: AppStyle.family[widget.doc["family_id"]],
              )),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
