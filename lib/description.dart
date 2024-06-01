import 'package:flutter/material.dart';
import 'package:untitled/youtube_video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FullDescriptionPage extends StatelessWidget {
  final String description;
  final String title;
  final int? year;
  final String videoUrl;
  final String imageUrl; // Add the image URL
  final String heroTag; // Add the hero tag

  FullDescriptionPage({
    required this.description,
    required this.title,
    required this.year,
    required this.videoUrl,
    required this.imageUrl, // Include image URL
    required this.heroTag, // Include hero tag
  });

  @override
  Widget build(BuildContext context) {
    String videoId = YoutubePlayer.convertUrlToId(videoUrl) ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Full Description', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: heroTag,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 10),
                Text(description, style: TextStyle(color: Colors.white)),
                const SizedBox(height: 20),
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
      ),
    );
  }
}
