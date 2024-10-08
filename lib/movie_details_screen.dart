import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/providers/favorites_provider.dart';

class MovieDetailsScreen extends ConsumerWidget {
  final Map movie;

  const MovieDetailsScreen({required this.movie, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posterUrl = 'https://image.tmdb.org/t/p/w500${movie['poster_path']}';

    return Scaffold(
      appBar: AppBar(
        title: Text(movie['title']),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigacija natrag na listu filmova koristeći GoRouter
            context.go('/movies');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // Dodaj film u favorite
              ref.read(favoritesProvider.notifier).addMovie(movie);
              // Možete dodati snackbar za povratne informacije
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${movie['title']} added to favorites')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView( // Omogućuje skrolanje ako je sadržaj prevelik
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio( // Zadržava proporcije slike
              aspectRatio: 2 / 3,
              child: Image.network(
                posterUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, size: 100, color: Colors.red);
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Title: ${movie['title']}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              'Overview: ${movie['overview']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Release Date: ${movie['release_date']}',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
