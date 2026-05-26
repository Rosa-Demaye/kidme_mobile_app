class Message {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isMe;

  Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isMe,
  });
}

class Conversation {
  final String id;
  final String otherUserName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String avatarUrl;
  final bool isOnline;

  Conversation({
    required this.id,
    required this.otherUserName,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.avatarUrl,
    this.isOnline = false,
  });
}
