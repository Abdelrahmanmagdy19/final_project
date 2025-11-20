import 'package:cloud_firestore/cloud_firestore.dart';

class UserChatModel {
  final String uid;
  final String name;
  final String role;
  final String email;
  final String imageUrl;

  UserChatModel({
    required this.uid,
    required this.name,
    required this.role,
    required this.email,
    required this.imageUrl,
  });

  factory UserChatModel.fromFirestore(
    DocumentSnapshot doc,
    String collectionName,
  ) {
    final data = doc.data() as Map<String, dynamic>;
    final role =
        data['role'] ?? collectionName.substring(0, collectionName.length - 1);
    return UserChatModel(
      uid: doc.id,
      name: data['name'] ?? 'Unknown User',
      role: role,
      email: data['email'] ?? 'No Email',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
