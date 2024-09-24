import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

// Movie provider for fetching movies with pagination and search
final moviePaginationProvider = StateNotifierProvider<MoviePaginationNotifier, MoviePaginationState>((ref) {
  return MoviePaginationNotifier();
});

// State class to manage pagination and movies
class MoviePaginationState {
  final List movies;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;

  MoviePaginationState({
    required this.movies,
    required this.isLoading,
    required this.hasMore,
    required this.currentPage,
  });

  MoviePaginationState copyWith({
    List? movies,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
  }) {
    return MoviePaginationState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

// StateNotifier for managing pagination and search
class MoviePaginationNotifier extends StateNotifier<MoviePaginationState> {
  MoviePaginationNotifier()
      : super(MoviePaginationState(
          movies: [],
          isLoading: false,
          hasMore: true,
          currentPage: 1,
        ));

  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.themoviedb.org/3/movie/popular';
  final String _apiKey = 'faa5bc2acc3d9a811902b1ef84bd6ba8';

  // Fetch movies from TMDB API with pagination
  Future<void> fetchMovies({String searchQuery = '', int page = 1}) async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final response = await _dio.get(_baseUrl, queryParameters: {
        'api_key': _apiKey,
        'page': page,
        'query': searchQuery.isNotEmpty ? searchQuery : null,
      });

      final newMovies = response.data['results'] as List;

      state = state.copyWith(
        movies: [...state.movies, ...newMovies],
        currentPage: page,
        hasMore: newMovies.isNotEmpty,
        isLoading: false,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false);
      // Handle error (log or display error in UI)
    }
  }

  // Reset the state and start a new search
  Future<void> searchMovies(String query) async {
    state = MoviePaginationState(
      movies: [],
      isLoading: false,
      hasMore: true,
      currentPage: 1,
    );
    await fetchMovies(searchQuery: query, page: 1);
  }

  // Load the next page of movies
  Future<void> loadNextPage(String searchQuery) async {
    await fetchMovies(searchQuery: searchQuery, page: state.currentPage + 1);
  }
}

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

    // Load the first page of movies when the screen initializes
    ref.read(moviePaginationProvider.notifier).fetchMovies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieState = ref.watch(moviePaginationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.go('/profile');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
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
                  _searchQuery = value.toLowerCase();
                });
                ref.read(moviePaginationProvider.notifier).searchMovies(_searchQuery);
              },
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  // Load next page when scrolled to the bottom
                  ref.read(moviePaginationProvider.notifier).loadNextPage(_searchQuery);
                }
                return false;
              },
              child: movieState.isLoading && movieState.movies.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: movieState.movies.length + (movieState.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == movieState.movies.length) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        final movie = movieState.movies[index];
                        final posterUrl = 'https://image.tmdb.org/t/p/w500${movie['poster_path']}';

                        return ListTile(
                          leading: AspectRatio(
                            aspectRatio: 2 / 3,
                            child: Image.network(
                              posterUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error);
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
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
