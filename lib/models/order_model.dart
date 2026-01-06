class OrderModel {
  final int id;
  final String status;
  final double totalPrice;
  final String createdAt;
  final String userName; // Assuming nested user or just ID, but MVP simple

  OrderModel({
    required this.id,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    required this.userName,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Check for 'user', 'customer', or 'buyer' keys
    var userData = json['user'] ?? json['customer'] ?? json['buyer'];
    String userDisplay = 'Guest';

    if (userData != null) {
      if (userData is Map) {
        userDisplay =
            userData['username'] ??
            userData['name'] ??
            userData['email'] ??
            'Unknown';
      } else if (userData is String) {
        userDisplay = userData;
      } else if (userData is int) {
        userDisplay = 'User #$userData';
      }
    }

    return OrderModel(
      id: json['id'] ?? 0,
      status: json['status'] ?? 'Pending',
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0.0,
      createdAt: json['created_at'] ?? '',
      userName: userDisplay,
    );
  }
}
