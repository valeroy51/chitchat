import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StoryPageView extends StatelessWidget {
  const StoryPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = StoryController();
    final List<StoryItem> storyItems = [
      StoryItem.text(
          title: "Helloooo",
          backgroundColor: const Color.fromARGB(255, 53, 255, 213)),
      StoryItem.inlineImage(
          url:
              "https://images.unsplash.com/photo-1679678691006-0ad24fecb769?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
          controller: controller)
    ];

    return StoryView(
      storyItems: storyItems,
      controller: controller,
      inline: false,
      repeat: false,
    );
  }
}
