class Orderss {
  final int id;
  final String orderStatus;
  final String paymentStatus;
  final double subtotal;
  final double grandTotal;
  final List<Productsss> products;

  Orderss({
    required this.id,
    required this.orderStatus,
    required this.paymentStatus,
    required this.subtotal,
    required this.grandTotal,
    required this.products,
  });

  factory Orderss.fromJson(Map<String, dynamic> json) {
    return Orderss(
      id: json['id'],
      orderStatus: json['order_status'],
      paymentStatus: json['payment_status'],
      subtotal: double.parse(json['subtotal']),
      grandTotal: double.parse(json['grand_total']),
      products: (json['products'] as List<dynamic>)
          .map((productJson) => Productsss.fromJson(productJson))
          .toList(),
    );
  }
}

class Productsss {
  final int id;
  final String productName;
  final double productPrice;
  final int quantity;

  Productsss({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.quantity,
  });

  factory Productsss.fromJson(Map<String, dynamic> json) {
    return Productsss(
      id: json['id'],
      productName: json['product_name'],
      productPrice: double.parse(json['product_price']),
      quantity: int.parse(json['product_qty']),
    );
  }
}
