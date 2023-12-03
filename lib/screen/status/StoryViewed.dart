import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StoryPageViewed extends StatelessWidget {
  const StoryPageViewed({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = StoryController();
    final List<StoryItem> storyItems = [
      StoryItem.inlineImage(
          url:
              "https://i.pinimg.com/564x/b1/7c/80/b17c8078d92bb5be450da8b96672357a.jpg",
          controller: controller),
      StoryItem.inlineImage(
          url:
              "https://images.unsplash.com/photo-1616091216791-a5360b5fc78a?q=80&w=1895&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
          controller: controller),
      StoryItem.text(
          title: "Pinjam dulu seratus",
          backgroundColor: const Color.fromARGB(155, 100, 10, 223)),
    ];

    return StoryView(
      storyItems: storyItems,
      controller: controller,
      inline: false,
      repeat: false,
    );
  }
}
