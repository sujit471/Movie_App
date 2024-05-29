import 'package:flutter/material.dart';
import 'package:untitled/youtube_video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class FullDescriptionPage extends StatelessWidget {
  final String description;
  final String title;
  final int? year;
  final String videoUrl;

  FullDescriptionPage({
    required this.description,
    required this.title,
    required this.year,
    required this.videoUrl,
  });

  @override
  Widget build(BuildContext context) {
    String videoId = YoutubePlayer.convertUrlToId(videoUrl) ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Full Description', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name of Movie: $title",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Year: $year',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(description, style: TextStyle(color: Colors.white)),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => YoutubePlayerScreen(),
                      ),
                    );
                  },
                  child: Text('Watch Trailer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
