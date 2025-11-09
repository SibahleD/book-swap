import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the Google Sign-In flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null; // user cancelled

    // Obtain auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the credential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Sign-In Demo")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final userCredential = await signInWithGoogle();
            if (userCredential != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Signed in as ${userCredential.user?.displayName}")),
              );
            }
          },
          child: const Text("Sign in with Google"),
        ),
      ),
    );
  }
}
