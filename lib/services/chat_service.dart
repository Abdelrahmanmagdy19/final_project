import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cure_link/models/model/user_chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  final List<String> _collections = [
    'users',
    'doctors',
    'hospitals',
    'pharmacies',
  ];

  Future<UserChatModel?> fetchCurrentUserProfile() async {
    if (currentUserId.isEmpty) return null;

    for (final collection in _collections) {
      final doc = await _firestore
          .collection(collection)
          .doc(currentUserId)
          .get();
      if (doc.exists) {
        return UserChatModel.fromFirestore(doc, collection);
      }
    }
    return null;
  }

  Future<List<UserChatModel>> searchUsersByEmail(String email) async {
    if (email.isEmpty) return [];

    List<UserChatModel> results = [];

    for (final collection in _collections) {
      final snapshot = await _firestore
          .collection(collection)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      for (var doc in snapshot.docs) {
        if (doc.id != currentUserId) {
          results.add(UserChatModel.fromFirestore(doc, collection));
        }
      }
    }

    return results;
  }

  Stream<QuerySnapshot> getActiveChatsStream() {
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('active_chats')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
