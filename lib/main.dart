import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/movie_controller.dart';
import 'views/movie_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MovieController(),
      child: MaterialApp(
        title: 'Movie Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const MovieListScreen(),
      ),
    );
  }
}
