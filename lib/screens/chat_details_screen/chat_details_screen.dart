import 'package:cure_link/models/model/message_model.dart';
import 'package:cure_link/models/model/user_chat_model.dart';
import 'package:cure_link/services/message_chat_service.dart';
import 'package:cure_link/widgets/custom_message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cure_link/utils/app_color.dart';

class ChatDetailsScreen extends StatefulWidget {
  final UserChatModel peerUser;
  final String currentUserId;
  final UserChatModel currentUserProfile;

  const ChatDetailsScreen({
    super.key,
    required this.peerUser,
    required this.currentUserId,
    required this.currentUserProfile,
  });

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final MessageChatService _chatService = MessageChatService();

  late final String _chatId;

  @override
  void initState() {
    super.initState();
    _chatId = _chatService.generateChatId(
      widget.currentUserId,
      widget.peerUser.uid,
    );
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    _messageController.clear();

    final message = MessageModel(
      senderId: widget.currentUserId,
      receiverId: widget.peerUser.uid,
      content: text,
      timestamp: Timestamp.now(),
    );

    await _chatService.sendMessage(
      message: message,
      chatId: _chatId,
      currentUser: widget.currentUserProfile,
      peerUser: widget.peerUser,
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
            Text(widget.peerUser.name, style: const TextStyle(fontSize: 18)),
            Text(
              widget.peerUser.role,
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
                  return Center(child: Text('Error: ${snapshot.error}'));
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
                    final isMe = msg.senderId == widget.currentUserId;

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
