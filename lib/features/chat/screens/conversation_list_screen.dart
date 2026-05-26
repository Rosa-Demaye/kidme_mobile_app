import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../models/chat_models.dart';
import 'chat_detail_screen.dart';

class ConversationListScreen extends StatelessWidget {
  const ConversationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final conversations = [
      Conversation(
        id: '1',
        otherUserName: 'Fale Tech Recruitment',
        lastMessage: 'Your interview is scheduled for tomorrow at 10 AM.',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 30)),
        avatarUrl: 'F',
      ),
      Conversation(
        id: '2',
        otherUserName: 'UNICEF Chad Admin',
        lastMessage: 'Thank you for your application. We will be in touch.',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
        avatarUrl: 'U',
      ),
      Conversation(
        id: '3',
        otherUserName: 'Design Lab',
        lastMessage: 'Are you available for a remote trial task?',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        avatarUrl: 'D',
        isOnline: true,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Messages'), centerTitle: true),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: conversations.length,
        separatorBuilder: (_, __) => const Divider(indent: 80, height: 1),
        itemBuilder: (context, index) {
          final conv = conversations[index];
          return ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.blueMist,
                  child: Text(
                    conv.avatarUrl,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                ),
                if (conv.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 14,
                      width: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            title: Text(
              conv.otherUserName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              conv.lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              _formatTime(conv.lastMessageTime),
              style: const TextStyle(fontSize: 12, color: AppColors.softGrey),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChatDetailScreen(conversation: conv),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}
