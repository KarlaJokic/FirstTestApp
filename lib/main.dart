import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/movie_list_screen.dart';
import 'package:movie_app/movie_details_screen.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
    );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => SplashScreen()),
      GoRoute(path: '/movies', builder: (context, state) => MovieListScreen()),
      GoRoute(
        path: '/movies/:id',
        builder: (context, state) {
          final movie = state.extra as Map;
          return MovieDetailsScreen(movie: movie);
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Movie App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
