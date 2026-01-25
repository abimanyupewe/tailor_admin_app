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

  factory ChatRoom.fromJson(Map<String, dynamic> json, [int? myUserId]) {
    String name = 'User';
    String? avatar;
    dynamic otherUser;

    // 0. Priority: Check for direct partner fields from customized API (Backend-provided)
    if (json['partner_name'] != null) {
      name = json['partner_name'];
      avatar = json['partner_avatar'];
    } else {
      // Fallback logic if partner_name is not provided directly
      // 1. Check for specific role keys
      if (json.containsKey('customer') || json.containsKey('tailor')) {
        final customer = json['customer'];
        final tailor = json['tailor'];

        if (myUserId != null && tailor != null && customer != null) {
          int tailorId = (tailor is Map)
              ? (tailor['id'] ?? 0)
              : (tailor is int ? tailor : 0);
          int customerId = (customer is Map)
              ? (customer['id'] ?? 0)
              : (customer is int ? customer : 0);

          if (tailorId == myUserId) {
            otherUser = customer;
          } else if (customerId == myUserId) {
            otherUser = tailor;
          }
        }

        if (otherUser == null) {
          otherUser = customer ?? tailor;
        }
      }

      // 2. Fallback to generic keys
      if (otherUser == null) {
        otherUser = json['user'] ?? json['participant'] ?? json['sender'];
      }

      // 3. Extract details from object
      if (otherUser != null) {
        if (otherUser is Map) {
          name =
              otherUser['username'] ??
              otherUser['name'] ??
              otherUser['full_name'] ??
              name;
          avatar = otherUser['avatar'] ?? otherUser['profile_picture'];
        } else if (otherUser is String) {
          name = otherUser;
        } else if (otherUser is int) {
          if (name == 'User') name = 'User #$otherUser';
        }
      }
    }

    // Parse last_message safely
    String? msgContent;
    String time = json['updated_at'] ?? json['created_at'] ?? '';

    var rawMsg = json['last_message'];
    if (rawMsg != null) {
      if (rawMsg is Map) {
        msgContent = rawMsg['text'] ?? rawMsg['content'] ?? rawMsg.toString();
        // Prefer last message time
        if (rawMsg['created_at'] != null) {
          time = rawMsg['created_at'];
        }
      } else {
        msgContent = rawMsg.toString();
      }
    }

    print(
      'DEBUG PARSE: id=${json['id']} partner_name=${json['partner_name']} finalName=$name avatar=$avatar',
    );

    return ChatRoom(
      id: json['id'] ?? 0,
      userName: name,
      lastMessage: msgContent,
      lastMessageTime: time,
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
    bool isMe;
    if (json.containsKey('is_me')) {
      isMe = json['is_me'];
    } else {
      isMe = (json['sender'] ?? 0) == myUserId;
    }

    return ChatMessage(
      id: json['id'] ?? 0,
      senderId: json['sender'] ?? 0,
      text: json['text'] ?? '',
      createdAt: json['created_at'] ?? '',
      isMe: isMe,
    );
  }
}
