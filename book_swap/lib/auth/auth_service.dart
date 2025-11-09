import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firestore_service.dart'; // Import the FirestoreService

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  Stream<User?> get user => _auth.authStateChanges();

  // Register with email & password
  Future<User?> registerWithEmailAndPassword(String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        // Add user to Firestore
        await _firestoreService.addUser(user.uid, email, username);
      }

      return user;
    } on FirebaseAuthException catch (e) {
      print("Registration error: ${e.code} - ${e.message}");
      return null;
    }
  }

  // Sign in with email & password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        // Update last active timestamp in Firestore
        await _firestoreService.addUser(user.uid, user.email!, user.displayName ?? 'User');
      }

      return user;
    } on FirebaseAuthException catch (e) {
      print("Sign-in error: ${e.code} - ${e.message}");
      return null;
    }
  }

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      if (user != null) {
        // Add or update Firestore user document
        await _firestoreService.addUser(user.uid, user.email!, user.displayName ?? 'Google User');
      }

      return user;
    } catch (e) {
      print("Google Sign-In error: $e");
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}
