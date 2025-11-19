import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cure_link/shared/models/message_model.dart';
import 'package:cure_link/shared/models/user_chat_model.dart';

class MessageChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _collectionForRole(String role) {
    switch (role.toLowerCase()) {
      case 'doctor':
        return 'doctors';
      case 'hospital':
        return 'hospitals';
      case 'pharmacy':
        return 'pharmacies';
      default:
        return 'users';
    }
  }

  String generateChatId(String userId1, String userId2) {
    List<String> ids = [userId1, userId2];
    ids.sort();
    return ids.join('_');
  }

  Stream<QuerySnapshot> getMessagesStream(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> sendMessage({
    required MessageModel message,
    required String chatId,
    required UserChatModel currentUser,
    required UserChatModel peerUser,
  }) async {
    final currentCollection = _collectionForRole(currentUser.role);
    final peerCollection = _collectionForRole(peerUser.role);

    final chatUpdateDataMe = {
      'chatId': chatId,
      'peerId': peerUser.uid,
      'peerName': peerUser.name,
      'peerRole': peerUser.role,
      'lastMessage': message.content,
      'timestamp': FieldValue.serverTimestamp(),
      'peerImageUrl': peerUser.imageUrl,
      'peerEmail': peerUser.email,
    };

    final chatUpdateDataPeer = {
      'chatId': chatId,
      'peerId': currentUser.uid,
      'peerName': currentUser.name,
      'peerRole': currentUser.role,
      'lastMessage': message.content,
      'timestamp': FieldValue.serverTimestamp(),
      'peerImageUrl': currentUser.imageUrl,
      'peerEmail': currentUser.email,
    };

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toMap());

    await _firestore
        .collection(currentCollection)
        .doc(currentUser.uid)
        .collection('active_chats')
        .doc(peerUser.uid)
        .set(chatUpdateDataMe);

    await _firestore
        .collection(peerCollection)
        .doc(peerUser.uid)
        .collection('active_chats')
        .doc(currentUser.uid)
        .set(chatUpdateDataPeer);
  }
}
