import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/providers/favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteMovies = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Movies'),
      ),
      body: favoriteMovies.isEmpty
          ? const Center(child: Text('No favorite movies yet.'))
          : ListView.builder(
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = favoriteMovies[index];
                final posterUrl = 'https://image.tmdb.org/t/p/w500${movie['poster_path']}';

                return ListTile(
                  leading: Image.network(posterUrl, width: 50, fit: BoxFit.cover),
                  title: Text(movie['title']),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () {
                      ref.read(favoritesProvider.notifier).removeMovie(movie);
                    },
                  ),
                );
              },
            ),
    );
  }
}
