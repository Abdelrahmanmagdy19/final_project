import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cure_link/shared/services/message_chat_service.dart';

class ChatLinkService {
  ChatLinkService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  final MessageChatService _messageChatService = MessageChatService();

  Future<String> ensureChatLink({
    required String patientId,
    required String patientName,
    required String patientEmail,
    required String patientImage,
    required String doctorId,
    required String doctorName,
    required String doctorEmail,
    required String doctorImage,
  }) async {
    final chatId = _messageChatService.generateChatId(patientId, doctorId);
    final timestamp = FieldValue.serverTimestamp();

    final patientActiveChatData = {
      'chatId': chatId,
      'peerId': doctorId,
      'peerName': doctorName,
      'peerRole': 'doctor',
      'peerImageUrl': doctorImage,
      'peerEmail': doctorEmail,
      'lastMessage': '',
      'timestamp': timestamp,
    };

    final doctorActiveChatData = {
      'chatId': chatId,
      'peerId': patientId,
      'peerName': patientName,
      'peerRole': 'patient',
      'peerImageUrl': patientImage,
      'peerEmail': patientEmail,
      'lastMessage': '',
      'timestamp': timestamp,
    };

    await _firestore
        .collection('users')
        .doc(patientId)
        .collection('active_chats')
        .doc(doctorId)
        .set(patientActiveChatData, SetOptions(merge: true));

    await _firestore
        .collection('doctors')
        .doc(doctorId)
        .collection('active_chats')
        .doc(patientId)
        .set(doctorActiveChatData, SetOptions(merge: true));

    await _firestore.collection('chats').doc(chatId).set({
      'participants': [patientId, doctorId],
      'updatedAt': timestamp,
    }, SetOptions(merge: true));

    return chatId;
  }
}

