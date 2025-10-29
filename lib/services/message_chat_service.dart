import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cure_link/models/model/message_model.dart';
import 'package:cure_link/models/model/user_chat_model.dart';

class MessageChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        .collection('users')
        .doc(currentUser.uid)
        .collection('active_chats')
        .doc(peerUser.uid)
        .set(chatUpdateDataMe);

    await _firestore
        .collection('users')
        .doc(peerUser.uid)
        .collection('active_chats')
        .doc(currentUser.uid)
        .set(chatUpdateDataPeer);
  }
}
