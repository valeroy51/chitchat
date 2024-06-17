import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:story_view/story_view.dart';
import 'dart:developer';
import 'package:chitchat/models/chatuser.dart';
import 'package:chitchat/api/api.dart';
import 'package:chitchat/helper/style.dart';

class StoryPageView extends StatefulWidget {
  final ChatUser user;
  const StoryPageView({super.key, required this.user});

  @override
  _StoryPageViewState createState() => _StoryPageViewState();
}

class _StoryPageViewState extends State<StoryPageView> {
  final StoryController _controller = StoryController();
  List<StoryItem> _storyItems = [];

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    try {
      List<Map<String, dynamic>> statusList = await apis.getStatus(widget.user);

      log('Status List in StoryPageView: $statusList');

      List<StoryItem> items = statusList.map((status) {
        if (status['image_path'] != null && status['image_path'] != "") {
          return StoryItem.inlineImage(
            url: status['image_path'],
            controller: _controller,
            imageFit: BoxFit.contain,
          );
        } else {
          return StoryItem.text(
            title: status['status_text'] ?? '',
            backgroundColor: status['color_id'] != null
                ? AppStyle.cardsColor[status['color_id']]
                : Colors.transparent,
            textStyle: status['family_id'] != null
                ? AppStyle.statusNote.copyWith(
                    fontFamily: AppStyle.family[status['family_id']],
                  )
                : AppStyle.statusNote,
          );
        }
      }).toList();

      setState(() {
        _storyItems = items;
      });

      if (_storyItems.isEmpty) {
        log('No stories available');
      }
    } catch (e) {
      log('Error loading status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_storyItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('No Stories Available'),
        ),
        body: const Center(
          child: Text('No stories available for this user.'),
        ),
      );
    }

    return StoryView(
      storyItems: _storyItems,
      controller: _controller,
      inline: false,
      repeat: false,
      onComplete: () {
        Navigator.pop(context); // Menutup layar status setelah selesai
      },
    );
  }
}
