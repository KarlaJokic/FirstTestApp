import 'package:flutter/material.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Map movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie['title'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(movie['description']),
      ),
    );
  }
}
