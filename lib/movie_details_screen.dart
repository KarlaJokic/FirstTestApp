import 'package:flutter/material.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Map movie;

  const MovieDetailsScreen({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    final posterUrl = 'https://image.tmdb.org/t/p/w500${movie['poster_path']}';

    return Scaffold(
      appBar: AppBar(title: Text(movie['title'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(posterUrl),  // Dodajemo poster slike
            const SizedBox(height: 10),
            Text('Title: ${movie['title']}', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            Text('Overview: ${movie['overview']}'),
          ],
        ),
      ),
    );
  }
}
