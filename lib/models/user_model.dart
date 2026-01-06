class UserModel {
  final int id;
  final String username;
  final String email;
  final String role;
  final bool isActive;
  final String? avatar; // Optional avatar

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.isActive,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle potential wrapper like { "data": {...} } or { "user": {...} }
    Map<String, dynamic> data = json;
    if (json.containsKey('data') && json['data'] is Map) {
      data = json['data'];
    } else if (json.containsKey('user') && json['user'] is Map) {
      data = json['user'];
    }

    return UserModel(
      id: data['id'] ?? 0,
      username: data['username'] ?? data['name'] ?? 'Unknown',
      email: data['email'] ?? '',
      role: data['role'] ?? 'user',
      isActive: data['is_active'] ?? true,
      avatar: data['avatar'],
    );
  }
}
