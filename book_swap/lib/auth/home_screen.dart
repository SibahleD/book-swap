import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, ${currentUser?.displayName ?? currentUser?.email ?? 'Guest'}!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Example: navigate to profile/settings page
                print('Navigate to Profile or Settings');
              },
              child: const Text('Go to Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
