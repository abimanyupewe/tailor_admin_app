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
    String userDisplay = 'Guest';
    if (json['user'] != null) {
      if (json['user'] is Map) {
        userDisplay = json['user']['username'] ?? 'Unknown';
      } else if (json['user'] is String) {
        userDisplay = json['user'];
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
