class ChatRoom {
  final int id;
  final String userName; // Name of the user chatting with
  final String? lastMessage;
  final String lastMessageTime;
  final String? userAvatar;

  ChatRoom({
    required this.id,
    required this.userName,
    this.lastMessage,
    required this.lastMessageTime,
    this.userAvatar,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    // Adjust logic based on real API response structure if needed
    // Assuming structure: { id, user: { name, avatar }, last_message, timestamp }
    return ChatRoom(
      id: json['id'] ?? 0,
      userName: json['user']?['username'] ?? 'User',
      lastMessage: json['last_message'],
      lastMessageTime: json['updated_at'] ?? '',
      userAvatar: json['user']?['avatar'],
    );
  }
}

class ChatMessage {
  final int id;
  final int senderId;
  final String text;
  final String createdAt;
  final bool isMe; // Helper to know if I sent it

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.createdAt,
    this.isMe = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json, int myUserId) {
    return ChatMessage(
      id: json['id'] ?? 0,
      senderId: json['sender'] ?? 0,
      text: json['text'] ?? '',
      createdAt: json['created_at'] ?? '',
      isMe: (json['sender'] ?? 0) == myUserId,
    );
  }
}
