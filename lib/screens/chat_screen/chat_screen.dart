import 'package:cure_link/models/model/user_chat_model.dart';
import 'package:cure_link/widgets/custom_user_tile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:cure_link/widgets/custom_text_from_field.dart';
import 'package:cure_link/screens/chat_details_screen/chat_details_screen.dart';
import '../../../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _searchController = TextEditingController();

  List<UserChatModel> _searchResults = [];
  bool _isLoading = false;
  bool _isDisplayingSearchResults = false;

  UserChatModel? _currentProfile;
  bool _isProfileLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _chatService.fetchCurrentUserProfile();
    setState(() {
      _currentProfile = profile;
      _isProfileLoading = false;
    });
  }

  Future<void> _searchUsers() async {
    final searchValue = _searchController.text.trim();
    if (searchValue.isEmpty) {
      setState(() {
        _isDisplayingSearchResults = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _isDisplayingSearchResults = true;
    });

    final results = await _chatService.searchUsersByEmail(searchValue);

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  void _openChat(UserChatModel peerUser) {
    if (_currentProfile == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatDetailsScreen(
          peerUser: peerUser,
          currentUserId: _chatService.currentUserId,
          currentUserProfile: _currentProfile!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isProfileLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 45, left: 16, right: 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    controller: _searchController,
                    hintText: 'Search by Email',
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _searchUsers,
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: AppColor.greenColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.check, color: Colors.white),
                  ),
                ),
              ],
            ),
            if (_isDisplayingSearchResults)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isDisplayingSearchResults = false;
                      _searchController.clear();
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColor.greenColor,
                  ),
                  label: const Text(
                    'Back to Recent Chats',
                    style: TextStyle(color: AppColor.greenColor),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Expanded(
              child: _isDisplayingSearchResults
                  ? _buildSearchResults()
                  : _buildActiveChats(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_searchResults.isEmpty) {
      return Center(
        child: Text('No user found with email: ${_searchController.text}'),
      );
    }
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) => CustomUserTile(
        user: _searchResults[index],
        onTap: () => _openChat(_searchResults[index]),
      ),
    );
  }

  Widget _buildActiveChats() {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getActiveChatsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No recent chats found.'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final data =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
            final user = UserChatModel(
              uid: data['peerId'] ?? '',
              name: data['peerName'] ?? 'Unknown User',
              role: data['peerRole'] ?? 'User',
              email: data['peerEmail'] ?? '',
              imageUrl: data['peerImageUrl'] ?? '',
            );
            return CustomUserTile(user: user, onTap: () => _openChat(user));
          },
        );
      },
    );
  }
}
