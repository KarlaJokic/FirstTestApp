import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/movie_list_screen.dart';
import 'package:movie_app/movie_details_screen.dart';
import 'package:movie_app/login_screen.dart';
import 'package:movie_app/settings_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie_app/profile_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    // Initialize GoRouter in initState, so _toggleTheme can be referenced
    _router = GoRouter(
      initialLocation: '/login', // Start from login screen
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/movies',
          builder: (context, state) => const MovieListScreen(),
        ),
        GoRoute(
          path: '/movies/:id',
          builder: (context, state) {
            // Ensure movie is passed as a Map, if not provide empty map
            final movie = state.extra as Map<dynamic, dynamic>? ?? {};
            return MovieDetailsScreen(movie: movie);
          },
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => SettingsScreen(
            onThemeChanged: (ThemeMode mode) {
              _toggleTheme(mode);
            },
          ),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfileScreen(
            onThemeChanged: (ThemeMode mode) {
              _toggleTheme(mode);
            },
            onLogout: () {
              // Navigate back to login on logout
              context.go('/login');
            },
          ),
        ),
      ],
    );
  }

  // Theme toggle method
  void _toggleTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Movie App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      routerConfig: _router, // Assign the router config
    );
  }
}
