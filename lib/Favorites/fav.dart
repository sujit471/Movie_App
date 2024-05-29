import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Movie {
  final String title;
  final String imageUrl;
  final String description;

  Movie({
    required this.title,
    required this.imageUrl,
    required this.description,
  });
}

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late List<Movie> _movies = []; // Initialize _movies as an empty list
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    setState(() {
      _isLoading = true;
    });

    const String apiUrl = 'https://imdb-top-100-movies.p.rapidapi.com';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'x-rapidapi-key':
          '7686336606msh423d12d765bcde1p132ed7jsn5072df0b3c64',
          'x-rapidapi-host': 'imdb-top-100-movies.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _movies = data.map((item) {
            // Parse rating as double
            double rating =
                double.tryParse(item['rating'].toString()) ?? 0.0;
            return Movie(
              title: item['title'],
              imageUrl: item['image'],
              description: item['description'],
            );
          }).toList();
          // Shuffle the list of movies
          _movies.shuffle();

          // Take the first 10 movies
          _movies = _movies.take(10).toList();
          _movies = _movies.take(10).toList();
        });
      } else {
        throw Exception(
            'Failed to load movies: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      _showErrorDialog();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content:
          Text('Failed to load movies. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending',style: TextStyle(color:Colors.white),),
        backgroundColor: Colors.black, // Change app bar color to black
      ),
      backgroundColor: Colors.black, // Set scaffold background color to black
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _movies.isEmpty
          ? const Center(child: Text('No movies found'))
          : Container(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _movies.length,
          itemBuilder: (context, index) {
            final movie = _movies[index];
            return Card(
              elevation: 4,
              color: Colors.red, // Change card color to red
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Image.network(
                  movie.imageUrl,
                  width: 80,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  movie.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Change text color to white
                  ),
                ),
                subtitle: Text(
                  movie.description,
                  style: TextStyle(color: Colors.white), // Change text color to white
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
