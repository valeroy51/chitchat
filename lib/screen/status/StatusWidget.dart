// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:chitchat/api/api.dart';
import 'package:chitchat/screen/NoteScreen.dart';
import 'package:chitchat/screen/homescreen.dart';
import 'package:chitchat/screen/profilescreen.dart';
import 'package:chitchat/screen/status/StoryView.dart';
import 'package:chitchat/screen/status/StoryViewed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatusWidget extends StatefulWidget {
  const StatusWidget({super.key});

  @override
  State<StatusWidget> createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  void initState() {
    apis.getSelfInfo();
  }

  int _index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Text("View Status"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(children: [
            Container(
              child: Row(children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: EdgeInsets.all(0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(
                      "img/status1.jpg",
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
                        "Me",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        "Have a great day",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54),
                      )
                    ],
                  ),
                ),
                Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(
                                    user: apis.me,
                                  )));
                    },
                    icon: const Icon(Icons.more_vert)),
              ]),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Favourite Friends",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.6)),
              ),
            ),
            for (int i = 1; i <= 3; i++)
              Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StoryPageView())),
                      child: Container(
                        padding: EdgeInsets.all(1.5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: Colors.blue, width: 3)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset(
                            "img/status$i.jpeg",
                            height: 55,
                            width: 55,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Connie",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Today, 2:00",
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
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Friends",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.6)),
              ),
            ),
            for (int i = 4; i <= 5; i++)
              Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StoryPageViewed())),
                      child: Container(
                        padding: EdgeInsets.all(1.5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: Colors.grey, width: 3)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset(
                            "img/status$i.jpg",
                            height: 55,
                            width: 55,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Connie",
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
              )
          ]),
        ),
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
            if (Index == 0) {
            } else if (Index == 1) {}
          } else {
            setState(() {
              _index = Index;
              if (Index == 1) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const StatusWidget())); //ganti yang ini

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const StatusWidget())); //ganti yang ini
              }
              if (Index == 0) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const homeScreen()));
              }
            });
          }
        },
      ),
    );
  }
}
