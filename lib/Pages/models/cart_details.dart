class CartDetailsModel {
  int? status;
  String? message;
  List<Data>? data;

  CartDetailsModel({this.status, this.message, this.data});

  CartDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? cartId;
  int? productId;
  String? productName;
  String? productPrice;
  String? productDiscount;
  String? deliveryCharge;
  String? productImageUrl;
  int? quantity;

  Data(
      {this.cartId,
      this.productId,
      this.productName,
      this.productPrice,
      this.productDiscount,
      this.deliveryCharge,
      this.productImageUrl,
      this.quantity});

  Data.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    productPrice = json['product_price'];
    deliveryCharge=json['delivery_charge'];
    productDiscount = json['product_discount'];
    productImageUrl = json['product_image_url'];
    quantity = int.parse(json['quantity']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cart_id'] = this.cartId;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_price'] = this.productPrice;
    data['delivery_charge']=this.deliveryCharge;
    data['product_discount'] = this.productDiscount;
    data['product_image_url'] = this.productImageUrl;
    data['quantity'] = this.quantity;
    return data;
  }
}
