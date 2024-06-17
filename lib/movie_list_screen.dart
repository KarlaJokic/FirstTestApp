import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

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
      appBar: AppBar(title: const Text('Movies')),
      body: moviesAsyncValue.when(
        data: (movies) => ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(movies[index]['title']),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
