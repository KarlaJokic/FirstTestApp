import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final Function(ThemeMode) onThemeChanged;
  final VoidCallback onLogout;

  const ProfileScreen({required this.onThemeChanged, required this.onLogout, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Toggle Dark Mode'),
            trailing: Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                onThemeChanged(value ? ThemeMode.dark : ThemeMode.light);
              },
            ),
          ),
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
