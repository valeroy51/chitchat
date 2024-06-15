import 'package:chitchat/api/api.dart';
import 'package:chitchat/models/statusPicture.dart';
import 'package:flutter/material.dart';

class StatusViewed extends StatefulWidget {
  const StatusViewed({super.key});

  @override
  State<StatusViewed> createState() => _StatusViewedState();
}

class _StatusViewedState extends State<StatusViewed> {
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
                  border: Border.all(color: Colors.grey, width: 3)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset(
                  "img/anto.png",
                  height: 55,
                  width: 55,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Yang Mulia Anthony",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Today, 12:00",
                      style: TextStyle(
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
