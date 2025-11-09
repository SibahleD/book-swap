import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(String uid, String email, String username) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'username': username,
        'createdAt': FieldValue.serverTimestamp(),
        'lastActive': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // merge: true ensures existing data is not overwritten
      print('User $username added/updated in Firestore!');
    } catch (e) {
      print('Error adding user to Firestore: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  Stream<Map<String, dynamic>?> getUserStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) => snapshot.data());
  }

  Future<void> updateUsername(String uid, String newUsername) async {
    try {
      await _firestore.collection('users').doc(uid).update({'username': newUsername});
      print('Username for $uid updated to $newUsername!');
    } catch (e) {
      print('Error updating username: $e');
    }
  }

  Future<void> deleteUserDocument(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      print('User document for $uid deleted!');
    } catch (e) {
      print('Error deleting user document: $e');
    }
  }

  Future<void> addMessage(String chatRoomId, String senderUid, String messageText) async {
    try {
      await _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').add({
        'senderId': senderUid,
        'message': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Message sent in chat room $chatRoomId');
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getMessagesStream(String chatRoomId) {
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
