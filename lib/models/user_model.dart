class UserModel {
  final int id;
  final String username;
  final String email;
  final String role;
  final bool isActive;
  final String? avatar; // User avatar
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;

  // Tailor specific fields
  final String? shopName;
  final String? bio;
  final String? shopImage;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.isActive,
    this.avatar,
    this.shopName,
    this.bio,
    this.shopImage,
    this.firstName,
    this.lastName,
    this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // 1. Try to extract User data
    // If json has 'user' key (Tailor profile structure), use that for user details
    Map<String, dynamic> userData = json;
    if (json.containsKey('user') && json['user'] is Map) {
      userData = json['user'];
    } else if (json.containsKey('data') && json['data'] is Map) {
      userData = json['data'];
    }

    // 2. Extract Tailor data from root if available
    // (If json IS the tailor profile, it has shop_name at root)
    String? shopName = json['shop_name'];
    String? bio = json['bio'];
    String? shopImage = json['shop_image'];

    return UserModel(
      id: userData['id'] ?? 0,
      username: userData['username'] ?? userData['name'] ?? 'Unknown',
      email: userData['email'] ?? '',
      role: userData['role'] ?? 'user',
      isActive: userData['is_active'] ?? true,
      avatar: userData['avatar'],
      firstName: userData['first_name'] ?? '',
      lastName: userData['last_name'] ?? '',
      phoneNumber: userData['phone_number'] ?? '',
      shopName: shopName,
      bio: bio,
      shopImage: shopImage,
    );
  }
}
