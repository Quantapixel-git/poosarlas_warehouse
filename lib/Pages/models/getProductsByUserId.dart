class getProductsByUserId {
  int? status;
  String? message;
  List<Data>? data;

  getProductsByUserId({this.status, this.message, this.data});

  getProductsByUserId.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? categoryId;
  String? productName;
  String? productPrice;
  String? productDiscount;
  String? stock;
  String? deliveryCharge;
  String? productShortDescription;
  String? productDescription;
  int? cartQuantity;
  String? productImageUrl;
  Null? additionalImage1Url;
  Null? additionalImage2Url;

  Data(
      {this.id,
      this.categoryId,
      this.productName,
      this.productPrice,
      this.productDiscount,
      this.stock,
      this.deliveryCharge,
      this.productShortDescription,
      this.productDescription,
      this.cartQuantity,
      this.productImageUrl,
      this.additionalImage1Url,
      this.additionalImage2Url});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    productName = json['product_name'];
    productPrice = json['product_price'];
    productDiscount = json['product_discount'];
    stock = json['stock'];
    deliveryCharge = json['delivery_charge'];
    productShortDescription = json['product_short_description'];
    productDescription = json['product_description'];
    cartQuantity = json['cart_quantity'];
    productImageUrl = json['product_image_url'];
    additionalImage1Url = json['additional_image_1_url'];
    additionalImage2Url = json['additional_image_2_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['product_name'] = this.productName;
    data['product_price'] = this.productPrice;
    data['product_discount'] = this.productDiscount;
    data['stock'] = this.stock;
    data['delivery_charge'] = this.deliveryCharge;
    data['product_short_description'] = this.productShortDescription;
    data['product_description'] = this.productDescription;
    data['cart_quantity'] = this.cartQuantity;
    data['product_image_url'] = this.productImageUrl;
    data['additional_image_1_url'] = this.additionalImage1Url;
    data['additional_image_2_url'] = this.additionalImage2Url;
    return data;
  }
}
