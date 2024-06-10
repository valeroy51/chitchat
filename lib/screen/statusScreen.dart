import 'dart:developer';
import 'package:chitchat/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/api/api.dart';
import 'package:chitchat/models/statusNote.dart';
import 'package:chitchat/models/statusPicture.dart';
import 'package:chitchat/screen/NoteScreen.dart';
import 'package:chitchat/screen/homescreen.dart';
import 'package:chitchat/screen/profilescreen.dart';
import 'package:chitchat/screen/status/StoryView.dart';
import 'package:chitchat/screen/status/StoryViewed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chitchat/models/chatuser.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class StatusScreen extends StatefulWidget {
  final ChatUser user;
  const StatusScreen({super.key, required this.user});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  void initState() {
    apis.getSelfInfo();
  }

  String? _image;
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
        title: const Text("View Status"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(children: [
            Container(
              child: Row(children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: const EdgeInsets.all(0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: CachedNetworkImage(
                      imageUrl: widget.user.Image,
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
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        widget.user.About,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(user: apis.me)));
                    },
                    icon: const Icon(Icons.more_vert)),
              ]),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Updated",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.6)),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StoryPageView())),
                    child: Container(
                      padding: const EdgeInsets.all(1.5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: Colors.blue, width: 3)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                          "img/hans.png",
                          height: 55,
                          width: 55,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hans Nathanael",
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
                "Viewed",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.6)),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StoryPageViewed())),
                    child: Container(
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
            )
          ]),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
            onPressed: () {
              _showBottomSheet();
            },
            child: const Icon(Icons.stream_outlined)),
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
                        builder: (_) => StatusScreen(user: apis.me)));

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => StatusScreen(user: apis.me)));
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

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          padding:
              EdgeInsets.only(top: mq.height * .05, bottom: mq.height * .1),
          children: [
            const Text(
              'Status',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: mq.height * .02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    fixedSize: Size(mq.width * .3, mq.height * .15),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StatusNote(user: apis.me)));
                  },
                  child: Image.asset("img/note.png"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    fixedSize: Size(mq.width * .3, mq.height * .15),
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery, imageQuality: 80);
                    if (image != null) {
                      log('image path: ${image.path} --MimeType: ${image.mimeType}');
                      setState(() {
                        _image = image.path;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StatusPicture(user: apis.me)));
                      Navigator.pop(context);
                    }
                  },
                  child: Image.asset("img/gallery.png"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    fixedSize: Size(mq.width * .3, mq.height * .15),
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                        source: ImageSource.camera, imageQuality: 80);
                    if (image != null) {
                      log('Image Path: ${image.path}');
                      setState(() {
                        _image = image.path;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StatusPicture(user: apis.me)));
                      Navigator.pop(context);
                    }
                  },
                  child: Image.asset("img/camera.png"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
