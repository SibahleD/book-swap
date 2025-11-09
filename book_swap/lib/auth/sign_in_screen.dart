import 'package:flutter/material.dart';
import 'auth_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthService _auth = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool _isRegistering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isRegistering ? 'Register' : 'Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_isRegistering)
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_isRegistering) {
                  // Register
                  final user = await _auth.registerWithEmailAndPassword(
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                    _usernameController.text.trim(),
                  );
                  if (user != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registered Successfully!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registration Failed.')),
                    );
                  }
                } else {
                  // Sign in
                  final user = await _auth.signInWithEmailAndPassword(
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                  );
                  if (user != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Signed In Successfully!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sign In Failed.')),
                    );
                  }
                }
              },
              child: Text(_isRegistering ? 'Register' : 'Sign In'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  _isRegistering = !_isRegistering;
                });
              },
              child: Text(_isRegistering
                  ? 'Already have an account? Sign In'
                  : 'Don’t have an account? Register'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final user = await _auth.signInWithGoogle();
                if (user != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Signed In with Google!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Google Sign In Failed.')),
                  );
                }
              },
              icon: Image.asset(
                'assets/google_logo.png', // Make sure to add a Google logo in your assets
                height: 24,
                width: 24,
              ),
              label: const Text('Sign In with Google'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
