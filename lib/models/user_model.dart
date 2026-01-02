class UserModel {
  final int id;
  final String username;
  final String email;
  final String role;
  final bool isActive;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? 'Unknown',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      isActive: json['is_active'] ?? true,
    );
  }
}
