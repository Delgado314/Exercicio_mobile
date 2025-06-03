import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'movie.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('movies.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE movies(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imageUrl TEXT NOT NULL,
        title TEXT NOT NULL,
        genre TEXT NOT NULL,
        ageRating TEXT NOT NULL,
        duration INTEGER NOT NULL,
        score REAL NOT NULL,
        description TEXT NOT NULL,
        year INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertMovie(Movie movie) async {
    final db = await database;
    return await db.insert('movies', movie.toMap());
  }

  Future<List<Movie>> getAllMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('movies');
    return List.generate(maps.length, (i) => Movie.fromMap(maps[i]));
  }

  Future<Movie?> getMovie(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'movies',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Movie.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateMovie(Movie movie) async {
    final db = await database;
    return await db.update(
      'movies',
      movie.toMap(),
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<int> deleteMovie(int id) async {
    final db = await database;
    return await db.delete(
      'movies',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

} 