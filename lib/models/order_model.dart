class OrderItem {
  final int id;
  final String serviceName;
  final double price;
  final int quantity;
  final String? note;

  OrderItem({
    required this.id,
    required this.serviceName,
    required this.price,
    required this.quantity,
    this.note,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    // 1. Try to find the service name
    String name = 'Service';
    // Check if 'service' is a nested object
    if (json['service'] is Map) {
      final serviceMap = json['service'];
      name = serviceMap['name'] ?? serviceMap['title'] ?? 'Service';
    }
    // Check if 'service_name' exists at top level
    else if (json['service_name'] != null) {
      name = json['service_name'];
    }
    // Check if 'service' is just a string name
    else if (json['service'] is String) {
      name = json['service'];
    }

    // 2. Try to find the price
    // Note: The order item price might be 'price' or 'subtotal' or even inside service 'base_price'
    // But usually OrderItem has its own price snapshot.
    double parsedPrice = 0.0;
    if (json['price'] != null) {
      parsedPrice = double.tryParse(json['price'].toString()) ?? 0.0;
    } else if (json['total_price'] != null) {
      parsedPrice = double.tryParse(json['total_price'].toString()) ?? 0.0;
    } else if (json['service'] is Map &&
        json['service']['base_price'] != null) {
      // Fallback to service base price if item price is missing
      parsedPrice =
          double.tryParse(json['service']['base_price'].toString()) ?? 0.0;
    }

    return OrderItem(
      id: json['id'] ?? 0,
      serviceName: name,
      price: parsedPrice,
      quantity: int.tryParse(json['quantity'].toString()) ?? 1,
      note: json['note'],
    );
  }
}

class OrderModel {
  final int id;
  final String status;
  final double totalPrice;
  final String createdAt;
  final String userName;
  final String? note;
  final String? address;
  final String? customerPhone;
  final List<OrderItem> items;

  OrderModel({
    required this.id,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    required this.userName,
    this.note,
    this.address,
    this.customerPhone,
    this.items = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Check for 'user', 'customer', or 'buyer' keys
    var userData = json['user'] ?? json['customer'] ?? json['buyer'];
    String userDisplay = 'Guest';
    String? phone;
    String? addr;

    if (userData != null) {
      if (userData is Map) {
        userDisplay =
            userData['username'] ??
            userData['name'] ??
            userData['email'] ??
            'Unknown';

        // Try to get phone and address from user object/profile if available
        if (userData['profile'] is Map) {
          phone = userData['profile']['phone_number'];
          addr = userData['profile']['address'];
        }
      } else if (userData is String) {
        userDisplay = userData;
      }
    }

    // Fallback if address/phone are top level in order
    if (json['address'] != null) addr = json['address'];
    if (json['phone'] != null) phone = json['phone'];

    var itemsList = <OrderItem>[];
    if (json['items'] != null && json['items'] is List) {
      itemsList = (json['items'] as List)
          .map((i) => OrderItem.fromJson(i))
          .toList();
    }

    return OrderModel(
      id: json['id'] ?? 0,
      status: json['status'] ?? 'Pending',
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0.0,
      createdAt: json['created_at'] ?? '',
      userName: userDisplay,
      note: json['note'],
      address: addr,
      customerPhone: phone,
      items: itemsList,
    );
  }
}
