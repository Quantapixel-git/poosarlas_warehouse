class ModelCategory {
  final int id;
  final String name;
  final String imageUrl;

  ModelCategory({required this.id, required this.name, required this.imageUrl});

  factory ModelCategory.fromJson(Map<String, dynamic> json) {
    return ModelCategory(
      id: json['id'],
      name: json['category_name'] as String,
      imageUrl: json['image_url'] as String,
    );
  }
}
