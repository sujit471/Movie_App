import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerScreen extends StatefulWidget {
  const YoutubePlayerScreen({super.key});

  @override
  State<YoutubePlayerScreen> createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
// To control the youtube video functionality
  final _controller = YoutubePlayerController();
  @override
  void initState() {
    super.initState();
    // TO load a video by its unique id
    _controller.loadVideoById(videoId: "PLl99DlL6b4");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(8.0),

          child: Center(
            // Youtube player as widget
            child: YoutubePlayer(
              controller: _controller, // Controler that we created earlier
              aspectRatio: 16 / 9,	 // Aspect ratio you want to take in screen
            ),
          ),
        ),
      ),
    );
  }
}