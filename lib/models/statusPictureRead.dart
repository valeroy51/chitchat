import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StatusPictureRead extends StatefulWidget {
  StatusPictureRead(this.doc, {super.key});
  QueryDocumentSnapshot doc;
  @override
  State<StatusPictureRead> createState() => _StatusPictureReadState();
}

class _StatusPictureReadState extends State<StatusPictureRead> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CachedNetworkImage(
          imageUrl: widget.doc["image_path"],
          placeholder: (context, url) => const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(strokeWidth: 5),
          ),
        ),
      ),
    );
  }
}
