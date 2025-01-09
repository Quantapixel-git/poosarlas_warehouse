class OrderResponseModel {
  int? status;
  String? message;
  List<Order>? orders;

  OrderResponseModel({this.status, this.message, this.orders});

  OrderResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['orders'] != null) {
      orders = <Order>[];
      json['orders'].forEach((v) {
        orders!.add(new Order.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Order {
  int? id;
  String? userId;
  String? addressId;
  String? orderStatus;
  String? subtotal;
  String? savings;
  String? gst;
  String? grandTotal;
  String? isPushed;
  String? createdAt;
  String? updatedAt;
  List<Items>? products;

  Order(
      {this.id,
      this.userId,
      this.addressId,
      this.orderStatus,
      this.subtotal,
      this.savings,
      this.gst,
      this.grandTotal,
      this.isPushed,
      this.createdAt,
      this.updatedAt,
      this.products});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    addressId = json['address_id'];
    orderStatus = json['order_status'];
    subtotal = json['subtotal'];
    savings = json['savings'];
    gst = json['gst'];
    grandTotal = json['grand_total'];
    isPushed = json['is_pushed'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['products'] != null) {
      products = <Items>[];
      json['products'].forEach((v) {
        products!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['address_id'] = this.addressId;
    data['order_status'] = this.orderStatus;
    data['subtotal'] = this.subtotal;
    data['savings'] = this.savings;
    data['gst'] = this.gst;
    data['grand_total'] = this.grandTotal;
    data['is_pushed'] = this.isPushed;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
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
  Item? product;

  Items(
      {this.id,
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
      this.product});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    userId = json['user_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    productPrice = json['product_price'];
    gst = json['gst'];
    grandTotal = json['grand_total'];
    productQty = json['product_qty'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productImageUrl = json['product_image_url'];
    product =
        json['product'] != null ? new Item.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_price'] = this.productPrice;
    data['gst'] = this.gst;
    data['grand_total'] = this.grandTotal;
    data['product_qty'] = this.productQty;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['product_image_url'] = this.productImageUrl;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

class Item {
  int? id;
  String? categoryId;
  String? productName;
  String? productPrice;
  String? productDiscount;
  String? stock;
  String? productImage;
  String? additionalImage1;
  String? additionalImage2;
  Null? productShortDescription;
  String? productDescription;
  String? deliveryCharge;
  String? status;
  String? createdAt;
  String? updatedAt;

  Item(
      {this.id,
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
      this.updatedAt});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    productName = json['product_name'];
    productPrice = json['product_price'];
    productDiscount = json['product_discount'];
    stock = json['stock'];
    productImage = json['product_image'];
    additionalImage1 = json['additional_image_1'];
    additionalImage2 = json['additional_image_2'];
    productShortDescription = json['product_short_description'];
    productDescription = json['product_description'];
    deliveryCharge = json['delivery_charge'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['product_name'] = this.productName;
    data['product_price'] = this.productPrice;
    data['product_discount'] = this.productDiscount;
    data['stock'] = this.stock;
    data['product_image'] = this.productImage;
    data['additional_image_1'] = this.additionalImage1;
    data['additional_image_2'] = this.additionalImage2;
    data['product_short_description'] = this.productShortDescription;
    data['product_description'] = this.productDescription;
    data['delivery_charge'] = this.deliveryCharge;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
