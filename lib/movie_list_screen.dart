import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

final moviesProvider = FutureProvider<List>((ref) async {
  final response = await Dio().get('https://api.themoviedb.org/3/movie/popular?api_key=faa5bc2acc3d9a811902b1ef84bd6ba8');
  return response.data['results'];
});

class MovieListScreen extends ConsumerWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsyncValue = ref.watch(moviesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: moviesAsyncValue.when(
        data: (movies) => ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            final posterUrl = 'https://image.tmdb.org/t/p/w500${movie['poster_path']}';

            return ListTile(
              leading: Image.network(
                posterUrl,
                width: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error); // Ako slika ne uspije učitati
                },
              ),
              title: Text(
                movie['title'],
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                'Release Date: ${movie['release_date']}', // Dodan podnaslov s datumom izlaska
                style: TextStyle(color: Colors.grey[600]),
              ),
              trailing: const Icon(Icons.arrow_forward_ios), // Dodana strelica za bolji UX
              onTap: () => context.go('/movies/${movie['id']}', extra: movie),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
