import 'package:chitchat/api/api.dart';
import 'package:chitchat/models/chatuser.dart';
import 'package:flutter/material.dart';

class StatusPicture extends StatefulWidget {
  final ChatUser user;

  const StatusPicture({super.key, required this.user});

  @override
  State<StatusPicture> createState() => _StatusPictureState();
}

class _StatusPictureState extends State<StatusPicture> {
  @override
  Widget build(BuildContext context) {
    void initState() {
      apis.getSelfInfo();
    }

    // TODO: implement build
    throw UnimplementedError();
  }
}
