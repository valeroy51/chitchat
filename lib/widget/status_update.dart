import 'package:chitchat/api/api.dart';
import 'package:chitchat/models/statusPicture.dart';
import 'package:flutter/material.dart';
import 'package:chitchat/models/chatuser.dart';

class StatusUpdate extends StatefulWidget {
  final ChatUser user;
  const StatusUpdate({super.key, required this.user});

  @override
  State<StatusUpdate> createState() => _StatusUpdateState();
}

class _StatusUpdateState extends State<StatusUpdate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StatusPicture(
                user: apis.me,
                imageUrl: apis.me.Image,
              ),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.blue, width: 3)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset(
                  widget.user.Image,
                  height: 55,
                  width: 55,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.Name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.user.About,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
