class ModelSubCategory {
  final int id;
  final String name;
  final String imageUrl;
  //final String categoryname;

  ModelSubCategory({
    required this.id,
    required this.name,
    required this.imageUrl,
    // required this.categoryname
  });

  factory ModelSubCategory.fromJson(Map<String, dynamic> json) {
    return ModelSubCategory(
      id: json['id'],
      name: json['subcategory_name'] as String,
      // categoryname: json['category_name'] as String,
      imageUrl: json['image_url'] as String,
    );
  }
}
