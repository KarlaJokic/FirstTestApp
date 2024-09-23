import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = '';
  bool isLoading = false;

  Future<void> _login() async {
  // Validate the email and password fields
  if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
    setState(() {
      errorMessage = 'Email and password cannot be empty.';
    });
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    // Attempt to sign in with Firebase
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    // Example: Logging the user's email or other information
    print('Logged in as: ${userCredential.user?.email}');
    
    // On success, navigate to the movies screen
    context.go('/movies');
  } on FirebaseAuthException catch (e) {
    setState(() {
      errorMessage = e.message ?? 'An error occurred during login';
    });
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email input field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            // Password input field
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            
            // Loading indicator or login button
            isLoading
              ? const CircularProgressIndicator() // Show loading indicator while waiting for login
              : ElevatedButton(
                  onPressed: _login,
                  child: const Text('Login'),
                ),

            // Display any error messages
            if (errorMessage.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
