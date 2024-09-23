import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Importaj GoRouter

class SettingsScreen extends StatelessWidget {
  final Function(ThemeMode) onThemeChanged;

  const SettingsScreen({super.key, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Omogućuje povratak na prethodni ekran koristeći GoRouter
            context.go('/movies'); // Navigacija natrag na listu filmova
          },
        ),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('System Theme'),
            onTap: () => onThemeChanged(ThemeMode.system),
          ),
          ListTile(
            title: const Text('Light Theme'),
            onTap: () => onThemeChanged(ThemeMode.light),
          ),
          ListTile(
            title: const Text('Dark Theme'),
            onTap: () => onThemeChanged(ThemeMode.dark),
          ),
        ],
      ),
    );
  }
}
