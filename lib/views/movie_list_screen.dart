import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../controllers/movie_controller.dart';
import '../models/movie.dart';
import 'movie_form_screen.dart';
import 'movie_detail_screen.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({Key? key}) : super(key: key);

  void _showGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Group Members'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("• Álvaro Antônio Brito Pereira de Lima"),
            Text("• Anna Victória Domingos Dantas"),
            Text("• José Lucas Herculano Delgado"),
            Text("• José Mateus dos Santos"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showGroupDialog(context),
            color: Colors.white,
          ),
        ],
      ),
      body: Consumer<MovieController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.movies.isEmpty) {
            return const Center(child: Text('No movies found'));
          }

          return ListView.builder(
            itemCount: controller.movies.length,
            itemBuilder: (context, index) {
              final movie = controller.movies[index];
              return Dismissible(
                key: Key(movie.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  controller.deleteMovie(movie.id!);
                },
                child: Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        movie.imageUrl,
                        width: 60,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 90,
                            color: Colors.grey,
                            child: const Icon(Icons.error),
                          );
                        },
                      ),
                    ),
                    title: Text(movie.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(movie.genre),
                        Text('${movie.duration} min'),
                        RatingBar.builder(
                          initialRating: movie.score,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 20,
                          ignoreGestures: true,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                      ],
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.visibility),
                              title: const Text('View Details'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailScreen(movie: movie),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.edit),
                              title: const Text('Edit'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieFormScreen(movie: movie),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MovieFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 