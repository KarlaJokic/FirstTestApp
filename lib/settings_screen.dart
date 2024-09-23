// File: lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  final Function(ThemeMode) onThemeChanged;

  const SettingsScreen({
    required this.onThemeChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // GoRouter navigation back to previous screen (e.g., movies list)
            context.go('/movies');
          },
        ),
      ),
      body: Column(
        children: [
          // Change theme to System default
          ListTile(
            title: const Text('System Theme'),
            onTap: () => onThemeChanged(ThemeMode.system),
          ),
          // Change theme to Light
          ListTile(
            title: const Text('Light Theme'),
            onTap: () => onThemeChanged(ThemeMode.light),
          ),
          // Change theme to Dark
          ListTile(
            title: const Text('Dark Theme'),
            onTap: () => onThemeChanged(ThemeMode.dark),
          ),
        ],
      ),
    );
  }
}
