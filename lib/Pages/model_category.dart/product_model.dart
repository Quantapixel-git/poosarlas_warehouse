class Product {
  final int id;
  final String categoryId;
  final String productName;
  final String productPrice;
  final String productDiscount;
  final String stock;
  final String productDescription;
  final String productImageUrl;
  final String additionalImage1Url;
  final String additionalImage2Url;
  bool isActive;

  Product({
    required this.id,
    required this.categoryId,
    required this.productName,
    required this.productPrice,
    required this.productDiscount,
    required this.stock,
    required this.productDescription,
    required this.productImageUrl,
    required this.additionalImage1Url,
    required this.additionalImage2Url,
    required this.isActive
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      categoryId: json['category_id'] ?? '',
      productName: json['product_name'] ?? '',
      productPrice: json['product_price'] ?? '',
      productDiscount: json['product_discount'] ?? '',
      stock: json['stock'] ?? '',
      productDescription: json['product_description'] ?? '',
      productImageUrl: json['product_image_url'] ?? '',
      additionalImage1Url: json['additional_image_1_url'] ?? '',
      additionalImage2Url: json['additional_image_2_url'] ?? '',
      isActive: json['isActive']??false,
    );
  }
}
