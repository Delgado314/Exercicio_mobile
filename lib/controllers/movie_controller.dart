import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/database_helper.dart';

class MovieController extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Movie> _movies = [];
  bool _isLoading = false;

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;

  Future<void> loadMovies() async {
    _isLoading = true;
    notifyListeners();

    _movies = await _dbHelper.getAllMovies();
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addMovie(Movie movie) async {
    await _dbHelper.insertMovie(movie);
    await loadMovies();
  }

  Future<void> updateMovie(Movie movie) async {
    await _dbHelper.updateMovie(movie);
    await loadMovies();
  }

  Future<void> deleteMovie(int id) async {
    await _dbHelper.deleteMovie(id);
    await loadMovies();
  }


  Future<Movie?> getMovie(int id) async {
    return await _dbHelper.getMovie(id);
  }
} 