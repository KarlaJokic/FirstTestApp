// File: lib/screens/profile_screen.dart

import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final Function(ThemeMode) onThemeChanged;
  final VoidCallback onLogout;

  const ProfileScreen({
    required this.onThemeChanged,
    required this.onLogout,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          // Theme Toggle
          ListTile(
            title: const Text('Toggle Dark Mode'),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                onThemeChanged(value ? ThemeMode.dark : ThemeMode.light);
              },
            ),
          ),
          // Logout Option
          ListTile(
            title: const Text('Log Out'),
            trailing: const Icon(Icons.logout),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
