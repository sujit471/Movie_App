import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import '../description.dart';
import '../savedliked.dart';
import 'package:firebase_core/firebase_core.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _imageData = [];
  List<Map<String, dynamic>> _likedImages = [];
  List<Map<String, dynamic>> _filteredImageData = [];
  bool _isSearching = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  void _saveLikedImages() async {
    CollectionReference likedImagesRef = _firestore.collection('liked_movies');
    for (var likedImage in _likedImages) {
      try {
        QuerySnapshot existingImages = await likedImagesRef
            .where('url', isEqualTo: likedImage['url'])
            .get();

        if (existingImages.docs.isEmpty) {
          await likedImagesRef.add(likedImage);
        } else {
          print('Image already saved.');
        }
      } catch (e) {
        print('Error saving liked image: $e');
      }
    }
  }

  void _searchMovies(String query) {
    final filteredMovies = _imageData.where((movie) {
      final titleLower = movie['title'].toLowerCase();
      final descriptionLower = movie['description'].toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower) || descriptionLower.contains(searchLower);
    }).toList();

    setState(() {
      _filteredImageData = filteredMovies;
    });
  }

  Future<void> _fetchImages() async {
    const String apiUrl = 'https://imdb-top-100-movies.p.rapidapi.com';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'x-rapidapi-key': '7686336606msh423d12d765bcde1p132ed7jsn5072df0b3c64',
          'x-rapidapi-host': 'imdb-top-100-movies.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _imageData = data.map((item) {
            double rating = double.tryParse(item['rating'].toString()) ?? 0.0;
            return {
              'url': item['image'],
              'description': item['description'],
              'title': item['title'],
              'rating': rating,
              'year': item['year'],
              'isLiked': false,
            };
          }).toList();
          _filteredImageData = _imageData;
        });
      } else {
        throw Exception('Failed to load images');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: !_isSearching
            ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Movies',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.favorite, color: Colors.white),
                  onPressed: () {
                    _saveLikedImages();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllLikedPage(likedImages: _likedImages),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        )
            : TextField(
          decoration: const InputDecoration(
            hintText: 'Search movies...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (query) {
            _searchMovies(query);
          },
          onSubmitted: (query) {
            setState(() {
              _isSearching = false;
            });
          },
        ),
        leading: _isSearching
            ? IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _filteredImageData = _imageData;
            });
          },
        )
            : null,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCarousel(autoPlay: true),
              const SizedBox(height: 40),
              const Row(
                children: [
                  Icon(Icons.video_library, color: Colors.red),
                  SizedBox(width: 10),
                  Text('Now playing', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              const SizedBox(height: 20),
              _buildCarousel(autoPlay: false),
              const SizedBox(height: 40),
              const Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.red),
                  SizedBox(width: 10),
                  Text('Coming soon', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              const SizedBox(height: 20),
              _buildCarousel(autoPlay: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel({bool autoPlay = false}) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: autoPlay,
        aspectRatio: 2.0,
        enlargeCenterPage: true,
        scrollPhysics: BouncingScrollPhysics(),
      ),
      items: _filteredImageData.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> data = entry.value;
        bool isLiked = data['isLiked'] ?? false;

        return Builder(
          builder: (BuildContext context) {
            final String heroTag = 'movieImage${data['url']}';
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullDescriptionPage(
                      description: data['description'],
                      title: data['title'],
                      year: data['year'],
                      videoUrl: 'https://youtu.be/gmA6MrX81z4?si=XD-n1kqmOJ_Ekp9H',
                      imageUrl: data['url'],
                      heroTag: heroTag,
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  Hero(
                    tag: heroTag,
                    child: Container(
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          data['url'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isLiked = !isLiked;
                          _filteredImageData[index]['isLiked'] = isLiked;
                          if (isLiked) {
                            if (!_likedImages.contains(data)) {
                              _likedImages.add(data);
                            }
                          } else {
                            _likedImages.removeWhere((item) => item['url'] == data['url']);
                          }
                        });
                      },
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        color: Colors.black.withOpacity(0.6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          _buildStarRating(data['rating']),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildStarRating(double rating) {
    int numberOfStars = rating.round();
    return Row(
      children: List.generate(
        numberOfStars,
            (index) => Icon(Icons.star, color: Colors.amber, size: 16),
      ),
    );
  }
}
