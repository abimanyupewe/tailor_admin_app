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
    // Flexible user parsing
    String name = 'User';
    String? avatar;

    var userData = json['user'] ?? json['participant'] ?? json['sender'];
    if (userData != null) {
      if (userData is Map) {
        name = userData['username'] ?? userData['name'] ?? name;
        avatar = userData['avatar'];
      } else if (userData is String) {
        name = userData;
      } else if (userData is int) {
        name = 'User #$userData';
      }
    }

    // Parse last_message safely
    String? msgContent;
    var rawMsg = json['last_message'];
    if (rawMsg != null) {
      if (rawMsg is Map) {
        msgContent = rawMsg['text'] ?? rawMsg['content'] ?? rawMsg.toString();
      } else {
        msgContent = rawMsg.toString();
      }
    }

    return ChatRoom(
      id: json['id'] ?? 0,
      userName: name,
      lastMessage: msgContent,
      lastMessageTime: json['updated_at'] ?? '',
      userAvatar: avatar,
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
