import 'package:cure_link/models/model/user_chat_model.dart';
import 'package:flutter/material.dart';
import '../utils/app_color.dart';

class CustomUserTile extends StatelessWidget {
  final UserChatModel user;
  final VoidCallback onTap;

  const CustomUserTile({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: onTap,
        title: Text(user.name),
        subtitle: Text('${user.role} - ${user.email}'),
        leading: CircleAvatar(
          backgroundImage: user.imageUrl.isNotEmpty
              ? NetworkImage(user.imageUrl)
              : null,
          child: user.imageUrl.isEmpty ? const Icon(Icons.person) : null,
        ),
        trailing: const Icon(
          Icons.chat_bubble_outline,
          color: AppColor.greenColor,
        ),
      ),
    );
  }
}
