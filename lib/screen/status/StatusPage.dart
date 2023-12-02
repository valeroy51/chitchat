import 'package:chitchat/StatusPageUI/HeadOwnStatus.dart';
import 'package:chitchat/StatusPageUI/OtherStatus.dart';
import 'package:chitchat/screen/status/StoryView.dart';
import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: const Icon(Icons.home),
      //   title: const Text('ChitChat'),
      //   actions: [
      //     IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
      //     IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
      //   ],
      // ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 48,
            child: FloatingActionButton(
              backgroundColor: Colors.blueGrey[100],
              elevation: 8,
              onPressed: () {},
              child: Icon(
                Icons.edit,
                color: Colors.blueGrey[900],
              ),
            ),
          ),
          const SizedBox(
            height: 13,
          ),
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.greenAccent[700],
            elevation: 5,
            child: const Icon(Icons.camera_alt),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeadOwnStatus(),
            label("Recent updates"),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StoryPageView(),
                ),
              ),
              child: const OtherStatus(
                name: "Margot",
                imageName: "img/margot.jpg",
                time: "01:27",
                isSeen: false,
                statusNum: 1,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StoryPageView(),
                ),
              ),
              child: const OtherStatus(
                name: "Kaya",
                imageName: "img/kaya.jpg",
                time: "04:47",
                isSeen: false,
                statusNum: 2,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StoryPageView(),
                ),
              ),
              child: const OtherStatus(
                name: "berta",
                imageName: "img/berta.jpg",
                time: "05:23",
                isSeen: false,
                statusNum: 3,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            label("Viewed updates"),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StoryPageView(),
                ),
              ),
              child: const OtherStatus(
                name: "Margot",
                imageName: "img/margot.jpg",
                time: "01:27",
                isSeen: true,
                statusNum: 1,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StoryPageView(),
                ),
              ),
              child: const OtherStatus(
                name: "Kaya",
                imageName: "img/kaya.jpg",
                time: "04:47",
                isSeen: true,
                statusNum: 2,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StoryPageView(),
                ),
              ),
              child: const OtherStatus(
                name: "berta",
                imageName: "img/berta.jpg",
                time: "05:23",
                isSeen: true,
                statusNum: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget label(String labelname) {
    return Container(
      height: 33,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[300],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        child: Text(
          labelname,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
