import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../controllers/movie_controller.dart';
import '../models/movie.dart';

class MovieFormScreen extends StatefulWidget {
  final Movie? movie;

  const MovieFormScreen({Key? key, this.movie}) : super(key: key);

  @override
  State<MovieFormScreen> createState() => _MovieFormScreenState();
}

class _MovieFormScreenState extends State<MovieFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imageUrlController = TextEditingController();
  final _titleController = TextEditingController();
  final _genreController = TextEditingController();
  final _durationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _yearController = TextEditingController();
  String _selectedAgeRating = 'Free';
  double _rating = 0;

  final List<String> _ageRatings = ['Free', '10', '12', '14', '16', '18'];

  @override
  void initState() {
    super.initState();
    if (widget.movie != null) {
      _imageUrlController.text = widget.movie!.imageUrl;
      _titleController.text = widget.movie!.title;
      _genreController.text = widget.movie!.genre;
      _selectedAgeRating = widget.movie!.ageRating;
      _durationController.text = widget.movie!.duration.toString();
      _rating = widget.movie!.score;
      _descriptionController.text = widget.movie!.description;
      _yearController.text = widget.movie!.year.toString();
    }
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _titleController.dispose();
    _genreController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _saveMovie() {
    if (_formKey.currentState!.validate()) {
      final movie = Movie(
        id: widget.movie?.id,
        imageUrl: _imageUrlController.text,
        title: _titleController.text,
        genre: _genreController.text,
        ageRating: _selectedAgeRating,
        duration: int.parse(_durationController.text),
        score: _rating,
        description: _descriptionController.text,
        year: int.parse(_yearController.text),
      );

      final controller = context.read<MovieController>();
      if (widget.movie == null) {
        controller.addMovie(movie);
      } else {
        controller.updateMovie(movie);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.movie == null ? 'Add Movie' : 'Edit Movie'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an image URL';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _genreController,
              decoration: const InputDecoration(labelText: 'Genre'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a genre';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _selectedAgeRating,
              decoration: const InputDecoration(labelText: 'Age Rating'),
              items: _ageRatings.map((rating) {
                return DropdownMenuItem(
                  value: rating,
                  child: Text(rating),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedAgeRating = value!;
                });
              },
            ),
            TextFormField(
              controller: _durationController,
              decoration: const InputDecoration(labelText: 'Duration (minutes)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter duration';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text('Rating'),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 40,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _yearController,
              decoration: const InputDecoration(labelText: 'Year'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a year';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid year';
                }
                final year = int.parse(value);
                if (year < 1900 || year > DateTime.now().year) {
                  return 'Please enter a valid year';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveMovie,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                widget.movie == null ? 'Add Movie' : 'Update Movie',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 