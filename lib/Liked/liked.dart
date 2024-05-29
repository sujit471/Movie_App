import 'package:flutter/material.dart';

class Liked extends StatelessWidget {
  final List<Map<String, dynamic>> likedImages;

  Liked({required this.likedImages});

  @override
  Widget build(BuildContext context) {
    return likedImages.isEmpty
        ? Center(child: Text('No liked images unitl '))
        : GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: likedImages.length,
      itemBuilder: (BuildContext context, int index) {
        final data = likedImages[index];
        return GridTile(
          child: Image.network(data['url'], fit: BoxFit.cover),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            title: Text(data['title']),
            subtitle: Text('${data['rating']} Stars'),
          ),
        );
      },
    );
  }
}
