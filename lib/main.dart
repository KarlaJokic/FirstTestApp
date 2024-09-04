import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/movie_list_screen.dart';
import 'package:movie_app/movie_details_screen.dart';
import 'package:movie_app/login_screen.dart'; 
import 'package:movie_app/settings_screen.dart'; 

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Definiramo GoRouter za navigaciju
  final GoRouter _router = GoRouter(
    initialLocation: '/', // Postavljamo početnu rutu na '/'
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginScreen(), // Početna ruta sada vodi na LoginScreen
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/movies',
        builder: (context, state) => MovieListScreen(),
      ),
      GoRoute(
        path: '/movies/:id',
        builder: (context, state) {
          final movie = state.extra as Map;
          return MovieDetailsScreen(movie: movie);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingsScreen(
          onThemeChanged: (ThemeMode mode) {
            // Poziva se funkcija za promjenu teme u MyApp
            (context.findAncestorStateOfType<_MyAppState>())?._toggleTheme(mode);
          },
        ),
      ),
    ],
  );

  // Postavljanje tema i modova
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Movie App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light, // Svijetla tema
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark, // Tamna tema
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode, // Postavljanje trenutne teme
      routerConfig: _router, // Postavljamo GoRouter konfiguraciju
    );
  }

  void _toggleTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }
}