class JsonDartYOrders {
  int? status;
  String? message;
  List<Orderxy>? orders;

  JsonDartYOrders({this.status, this.message, this.orders});

  factory JsonDartYOrders.fromJson(Map<String, dynamic> json) {
    return JsonDartYOrders(
      status: json['status'] is int ? json['status'] : int.tryParse(json['status'].toString()),
      message: json['message']?.toString(),
      orders: (json['orders'] as List?)?.map((i) => Orderxy.fromJson(i)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'orders': orders?.map((e) => e.toJson()).toList(),
    };
  }
}

class Orderxy {
  int? id;
  int? userId;
  String? addressId;
  String? note;
  String? orderStatus;
  String? paymentStatus;
  String? subtotal;
  String? savings;
  String? gst;
  String? grandTotal;
  int? isPushed;
  String? createdAt;
  String? updatedAt;
  List<Productxy>? products;

  Orderxy({
    this.id,
    this.userId,
    this.addressId,
    this.note,
    this.orderStatus,
    this.paymentStatus,
    this.subtotal,
    this.savings,
    this.gst,
    this.grandTotal,
    this.isPushed,
    this.createdAt,
    this.updatedAt,
    this.products,
  });

  factory Orderxy.fromJson(Map<String, dynamic> json) {
    return Orderxy(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id'].toString()),
      addressId: json['address_id']?.toString(),
      note: json['note']?.toString(),
      orderStatus: json['order_status']?.toString(),
      paymentStatus: json['payment_status']?.toString(),
      subtotal: json['subtotal']?.toString(),
      savings: json['savings']?.toString(),
      gst: json['gst']?.toString(),
      grandTotal: json['grand_total']?.toString(),
      isPushed: json['is_pushed'] is int ? json['is_pushed'] : int.tryParse(json['is_pushed'].toString()),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      products: (json['products'] as List?)?.map((i) => Productxy.fromJson(i)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'address_id': addressId,
      'note': note,
      'order_status': orderStatus,
      'payment_status': paymentStatus,
      'subtotal': subtotal,
      'savings': savings,
      'gst': gst,
      'grand_total': grandTotal,
      'is_pushed': isPushed,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'products': products?.map((e) => e.toJson()).toList(),
    };
  }
}

class Productxy {
  int? id;
  int? orderId;
  int? userId;
  int? productId;
  String? productName;
  String? productPrice;
  String? gst;
  String? grandTotal;
  String? productQty;
  String? createdAt;
  String? updatedAt;
  String? productImageUrl;
  String? additionalImage1Url;
  String? additionalImage2Url;

  Productxy({
    this.id,
    this.orderId,
    this.userId,
    this.productId,
    this.productName,
    this.productPrice,
    this.gst,
    this.grandTotal,
    this.productQty,
    this.createdAt,
    this.updatedAt,
    this.productImageUrl,
    this.additionalImage1Url,
    this.additionalImage2Url,
  });

  factory Productxy.fromJson(Map<String, dynamic> json) {
    return Productxy(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      orderId: json['order_id'] is int ? json['order_id'] : int.tryParse(json['order_id'].toString()),
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id'].toString()),
      productId: json['product_id'] is int ? json['product_id'] : int.tryParse(json['product_id'].toString()),
      productName: json['product_name']?.toString(),
      productPrice: json['product_price']?.toString(),
      gst: json['gst']?.toString(),
      grandTotal: json['grand_total']?.toString(),
      productQty: json['product_qty']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      productImageUrl: json['product_image_url']?.toString(),
      additionalImage1Url: json['additional_image_1_url']?.toString(),
      additionalImage2Url: json['additional_image_2_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'user_id': userId,
      'product_id': productId,
      'product_name': productName,
      'product_price': productPrice,
      'gst': gst,
      'grand_total': grandTotal,
      'product_qty': productQty,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'product_image_url': productImageUrl,
      'additional_image_1_url': additionalImage1Url,
      'additional_image_2_url': additionalImage2Url,
    };
  }
}