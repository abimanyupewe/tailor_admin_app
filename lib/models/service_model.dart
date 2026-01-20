class ServiceModel {
  final int id;
  final String name;
  final double price;
  final String description; // Optional
  final String duration; // e.g. "2 Days"
  final String serviceType; // "PERMAK" or "JAHIT"
  final bool isActive;

  ServiceModel({
    required this.id,
    required this.name,
    required this.price,
    this.description = '',
    this.duration = '',
    this.serviceType = 'PERMAK',
    this.isActive = true,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Layanan',
      // Map base_price from backend to price
      price:
          double.tryParse((json['base_price'] ?? json['price']).toString()) ??
          0.0,
      description: json['description'] ?? '',
      duration: (json['estimated_duration_days'] ?? json['duration'] ?? '')
          .toString(),
      serviceType: json['service_type'] ?? 'PERMAK',
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      // Send as base_price to backend
      'base_price': price,
      'description': description,
      'duration': duration,
      'service_type': serviceType,
      'is_active': isActive,
    };
  }
}
