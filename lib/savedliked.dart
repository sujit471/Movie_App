import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllLikedPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Map<String, dynamic>> likedImages; // Define likedImages parameter

  AllLikedPage({Key? key, required this.likedImages}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Liked Movies',style: TextStyle(color:Colors.white),),
      ),
      body: Container(

        color: Colors.black,
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('liked_movies').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No liked movies found.'),
              );
            }

            final likedMovies = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

            return Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3), // Whitish shadow color
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7, // Adjust aspect ratio for better image display
                ),
                itemCount: likedMovies.length,
                itemBuilder: (context, index) {
                  final movie = likedMovies[index];

                  final String imageUrl = movie['url'] ?? 'https://via.placeholder.com/150';
                  final String title = movie['title'] ?? 'No Title';
                  final double rating = (movie['rating'] ?? 0).toDouble();

                  return GestureDetector(
                    onTap: () {
                      // Navigate to movie detail page or perform action
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.black12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 16/9,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2, // Limit title to 2 lines
                                  overflow: TextOverflow.ellipsis, // Add ellipsis if title exceeds 2 lines
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber, size: 18),
                                    SizedBox(width: 4),
                                    Text(
                                      rating.toStringAsFixed(1),
                                      style: TextStyle(fontSize: 14,color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete,color: Colors.white,),
                            onPressed: () {
                              _deleteMovie(context,snapshot.data!.docs[index].id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
  void _deleteMovie(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            'Confirm Deletion',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Colors.red, // Change title color
            ),
          ),
          content: Text(
            'Are you sure you want to remove this movie from liked movies?',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white, // Change content text color
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Close the dialog and return false
              },
              child: Text(
                'CANCEL',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey, // Change cancel button text color
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true); // Close the dialog and return true
              },
              child: Text(
                'DELETE',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.red, // Change delete button text color
                ),
              ),
            ),
          ],
          // Change dialog background color
          elevation: 8.0, // Add elevation to the dialog
        );
      },
    ).then((confirmed) {
      if (confirmed != null && confirmed) {
        // User confirmed deletion
        _performDeleteAndShowSnackbar(context, docId);
      }
    });
  }


  void _performDeleteAndShowSnackbar(BuildContext context, String docId) async {
    try {
      await _firestore.collection('liked_movies').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Movie removed from liked movies successfully.'),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {
              // Perform any action on press if needed
            },
          ),
        ),
      );
    } catch (error) {
      print('Error deleting movie: $error');
    }
  }



}
