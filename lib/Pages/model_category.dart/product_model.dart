class Product {
  final int id;
  final int categoryId; // Assuming category_id is an integer
  final String productName;
  final String productPrice; // Keep as String if the API returns it as a string
  final String
      productDiscount; // Keep as String if the API returns it as a string
  final String stock; // Keep as String if the API returns it as a string
  final String
      deliveryCharge; // Keep as String if the API returns it as a string
  final String productImageUrl;

  Product({
    required this.id,
    required this.categoryId,
    required this.productName,
    required this.productPrice,
    required this.productDiscount,
    required this.stock,
    required this.deliveryCharge,
    required this.productImageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      categoryId: json['category_id'], // Ensure this matches the API response
      productName: json['product_name'],
      productPrice: json['product_price'],
      productDiscount: json['product_discount'],
      stock: json['stock'],
      deliveryCharge: json['delivery_charge'],
      productImageUrl: json['product_image_url'],
    );
  }
}
