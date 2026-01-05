class PostModel {
  final int id;
  final String? caption;
  final String? image; // URL to image
  final String createdAt;

  PostModel({
    required this.id,
    this.caption,
    this.image,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? 0,
      caption: json['caption'],
      image: json['image'],
      createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'caption': caption, 'image': image};
  }
}
