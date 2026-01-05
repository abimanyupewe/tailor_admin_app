class ServiceModel {
  final int id;
  final String name;
  final double price;
  final String description; // Optional
  final String duration; // e.g. "2 Days"

  ServiceModel({
    required this.id,
    required this.name,
    required this.price,
    this.description = '',
    this.duration = '',
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Layanan',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      description: json['description'] ?? '',
      duration: json['duration'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'duration': duration,
    };
  }
}
