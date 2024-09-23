import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

// Provider za dohvaćanje popularnih filmova iz TMDB API-ja
final moviesProvider = FutureProvider<List>((ref) async {
  final response = await Dio().get(
      'https://api.themoviedb.org/3/movie/popular?api_key=faa5bc2acc3d9a811902b1ef84bd6ba8');
  return response.data['results'];
});

class MovieListScreen extends ConsumerStatefulWidget {
  const MovieListScreen({super.key});

  @override
  MovieListScreenState createState() => MovieListScreenState();
}

class MovieListScreenState extends ConsumerState<MovieListScreen> {
  late TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moviesAsyncValue = ref.watch(moviesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Navigacija na ekran profila koristeći GoRouter
              context.go('/profile');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigacija na ekran postavki koristeći GoRouter
              context.go('/settings');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Movies',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase(); // Ažuriranje pretrage
                });
              },
            ),
          ),
          Expanded(
            child: moviesAsyncValue.when(
              data: (movies) {
                // Filtriranje filmova na temelju pretrage
                final filteredMovies = movies.where((movie) {
                  final title = movie['title'].toString().toLowerCase();
                  return title.contains(_searchQuery);
                }).toList();

                if (filteredMovies.isEmpty) {
                  return const Center(child: Text('No movies found.'));
                }

                return ListView.builder(
                  itemCount: filteredMovies.length,
                  itemBuilder: (context, index) {
                    final movie = filteredMovies[index];
                    final posterUrl =
                        'https://image.tmdb.org/t/p/w500${movie['poster_path']}';

                    return ListTile(
                      leading: AspectRatio(
                        aspectRatio: 2 / 3, // Zadržava proporcije slike
                        child: Image.network(
                          posterUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error); // Ako slika ne uspije učitati
                          },
                        ),
                      ),
                      title: Text(
                        movie['title'],
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        'Release Date: ${movie['release_date']}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => context.go('/movies/${movie['id']}', extra: movie),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}
