import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cure_link/shared/models/message_model.dart';
import 'package:cure_link/shared/models/user_chat_model.dart';
import 'package:cure_link/shared/services/message_chat_service.dart';
import 'package:cure_link/widgets/custom_message_bubble.dart';
import 'package:cure_link/widgets/custom_user_tile.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DoctorChatScreen extends StatefulWidget {
  const DoctorChatScreen({super.key});

  @override
  State<DoctorChatScreen> createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserChatModel? _currentDoctorProfile;
  bool _isProfileLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctorProfile();
  }

  Future<void> _loadDoctorProfile() async {
    final doctorId = FirebaseAuth.instance.currentUser?.uid;
    if (doctorId == null) {
      setState(() => _isProfileLoading = false);
      return;
    }

    try {
      final doc = await _firestore.collection('doctors').doc(doctorId).get();
      if (doc.exists && mounted) {
        final data = doc.data()!;
        setState(() {
          _currentDoctorProfile = UserChatModel(
            uid: doctorId,
            name: data['name'] ?? 'Doctor',
            role: 'doctor',
            email: data['email'] ?? '',
            imageUrl: data['imageUrl'] ?? '',
          );
          _isProfileLoading = false;
        });
      } else {
        setState(() => _isProfileLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProfileLoading = false);
      }
    }
  }

  void _openChat(UserChatModel patient) {
    if (_currentDoctorProfile == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorChatDetailsScreen(
          patient: patient,
          doctor: _currentDoctorProfile!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctorId = FirebaseAuth.instance.currentUser?.uid;

    if (_isProfileLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (doctorId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Messages'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Please login to view messages.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        centerTitle: true,
        backgroundColor: AppColor.greenColor,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('doctors')
            .doc(doctorId)
            .collection('active_chats')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 60, color: Colors.red[300]),
                  const SizedBox(height: 12),
                  Text(
                    'Error loading messages',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => setState(() {}),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.greenColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          // Handle empty state
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline,
                      size: 60, color: AppColor.greenColor),
                  const SizedBox(height: 12),
                  const Text(
                    'No messages yet.',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Messages from patients will appear here.',
                    style: TextStyle(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final data =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              final patient = UserChatModel(
                uid: data['peerId'] ?? '',
                name: data['peerName'] ?? 'Unknown Patient',
                role: data['peerRole'] ?? 'patient',
                email: data['peerEmail'] ?? '',
                imageUrl: data['peerImageUrl'] ?? '',
              );
              return CustomUserTile(
                user: patient,
                onTap: () => _openChat(patient),
              );
            },
          );
        },
      ),
    );
  }
}

class DoctorChatDetailsScreen extends StatefulWidget {
  final UserChatModel patient;
  final UserChatModel doctor;

  const DoctorChatDetailsScreen({
    super.key,
    required this.patient,
    required this.doctor,
  });

  @override
  State<DoctorChatDetailsScreen> createState() =>
      _DoctorChatDetailsScreenState();
}

class _DoctorChatDetailsScreenState extends State<DoctorChatDetailsScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final MessageChatService _chatService = MessageChatService();

  late final String _chatId;

  @override
  void initState() {
    super.initState();
    _chatId = _chatService.generateChatId(
      widget.doctor.uid,
      widget.patient.uid,
    );
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    _messageController.clear();

    final message = MessageModel(
      senderId: widget.doctor.uid,
      receiverId: widget.patient.uid,
      content: text,
      timestamp: Timestamp.now(),
    );

    await _chatService.sendMessage(
      message: message,
      chatId: _chatId,
      currentUser: widget.doctor,
      peerUser: widget.patient,
    );

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 50), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.greenColor,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.patient.name, style: const TextStyle(fontSize: 18)),
            Text(
              widget.patient.role,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatService.getMessagesStream(_chatId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 48, color: Colors.red[300]),
                        const SizedBox(height: 12),
                        Text(
                          'Error loading messages',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () => setState(() {}),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('Say hello! Start your conversation.'),
                  );
                }

                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => _scrollToBottom(),
                );

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final msg = MessageModel.fromFirestore(
                      snapshot.data!.docs[index],
                    );
                    final isMe = msg.senderId == widget.doctor.uid;

                    return MessageBubble(
                      message: msg.content,
                      isMe: isMe,
                      timestamp: msg.timestamp,
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: _sendMessage,
            mini: true,
            backgroundColor: AppColor.greenColor,
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

