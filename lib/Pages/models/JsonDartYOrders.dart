class JsonDartYOrders {
  int? status;
  String? message;
  List<Orderxy>? orders;

  JsonDartYOrders({this.status, this.message, this.orders});

  factory JsonDartYOrders.fromJson(Map<String, dynamic> json) {
    return JsonDartYOrders(
      status: json['status'],
      message: json['message'],
      orders: json['orders'] != null
          ? (json['orders'] as List).map((i) => Orderxy.fromJson(i)).toList()
          : null,
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
  String? userId;
  String? addressId;
  String? note;
  String? orderStatus;
  String? paymentStatus;
  String? subtotal;
  String? savings;
  String? gst;
  String? grandTotal;
  String? isPushed;
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
      isPushed: json['is_pushed'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      products: json['products'] != null
          ? (json['products'] as List)
              .map((i) => Productxy.fromJson(i))
              .toList()
          : null,
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
  String? orderId;
  String? userId;
  String? productId;
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
  ProductDetails? product;

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
    this.product,
  });

  factory Productxy.fromJson(Map<String, dynamic> json) {
    return Productxy(
      id: json['id'],
      orderId: json['order_id'],
      userId: json['user_id'],
      productId: json['product_id'],
      productName: json['product_name'],
      productPrice: json['product_price'],
      gst: json['gst'],
      grandTotal: json['grand_total'],
      productQty: json['product_qty'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      productImageUrl: json['product_image_url'],
      additionalImage1Url: json['additional_image_1_url'],
      additionalImage2Url: json['additional_image_2_url'],
      product: json['product'] != null
          ? ProductDetails.fromJson(json['product'])
          : null,
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
      'product': product?.toJson(),
    };
  }
}

class ProductDetails {
  int? id;
  String? categoryId;
  String? productName;
  String? productPrice;
  String? productDiscount;
  String? stock;
  String? productImage;
  String? additionalImage1;
  String? additionalImage2;
  String? productShortDescription;
  String? productDescription;
  String? deliveryCharge;
  String? status;
  String? createdAt;
  String? updatedAt;

  ProductDetails({
    this.id,
    this.categoryId,
    this.productName,
    this.productPrice,
    this.productDiscount,
    this.stock,
    this.productImage,
    this.additionalImage1,
    this.additionalImage2,
    this.productShortDescription,
    this.productDescription,
    this.deliveryCharge,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      id: json['id'],
      categoryId: json['category_id'],
      productName: json['product_name'],
      productPrice: json['product_price'],
      productDiscount: json['product_discount'],
      stock: json['stock'],
      productImage: json['product_image'],
      additionalImage1: json['additional_image_1'],
      additionalImage2: json['additional_image_2'],
      productShortDescription: json['product_short_description'],
      productDescription: json['product_description'],
      deliveryCharge: json['delivery_charge'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'product_name': productName,
      'product_price': productPrice,
      'product_discount': productDiscount,
      'stock': stock,
      'product_image': productImage,
      'additional_image_1': additionalImage1,
      'additional_image_2': additionalImage2,
      'product_short_description': productShortDescription,
      'product_description': productDescription,
      'delivery_charge': deliveryCharge,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
