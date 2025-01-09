class Orderx {
  final int id;
  final String userId;
  final String addressId;
  final String? note;
  final String orderStatus;
  final String paymentStatus;
  final String subtotal;
  final String savings;
  final String gst;
  final String grandTotal;
  final List<Productx> products;

  Orderx({
    required this.id,
    required this.userId,
    required this.addressId,
    this.note,
    required this.orderStatus,
    required this.paymentStatus,
    required this.subtotal,
    required this.savings,
    required this.gst,
    required this.grandTotal,
    required this.products,
  });

  factory Orderx.fromJson(Map<String, dynamic> json) {
    return Orderx(
      id: json['id'],
      userId: json['user_id'],
      addressId: json['address_id'],
      note: json['note'],
      orderStatus: json['order_status'],
      paymentStatus: json['payment_status'],
      subtotal: json['subtotal'],
      savings: json['savings'],
      gst: json['gst'],
      grandTotal: json['grand_total'],
      products: (json['products'] as List)
          .map((productJson) => Productx.fromJson(productJson))
          .toList(),
    );
  }
}

class Productx {
  final int id;
  final String productName;
  final String productPrice;
  final String gst;
  final String grandTotal;
  final String productQty;
  final String? productImageUrl;

  Productx({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.gst,
    required this.grandTotal,
    required this.productQty,
    this.productImageUrl,
  });

  factory Productx.fromJson(Map<String, dynamic> json) {
    return Productx(
      id: json['id'],
      productName: json['product_name'],
      productPrice: json['product_price'],
      gst: json['gst'],
      grandTotal: json['grand_total'],
      productQty: json['product_qty'],
      productImageUrl: json['product_image_url'],
    );
  }
}
