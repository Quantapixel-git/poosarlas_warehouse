class PlaceOrderRequestModel {
  String? userId;
  int? addressId;
  String? orderStatus;
  double? subtotal;
  double? savings;
  int? gst;
  double? grandTotal;
  List<Products>? products;
  String? deliveryCharge;

  PlaceOrderRequestModel(
      {this.userId,
      this.addressId,
      this.orderStatus,
      this.subtotal,
      this.savings,
      this.gst,
      this.grandTotal,
      this.deliveryCharge,
      this.products});

  PlaceOrderRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    addressId = json['address_id'];
    orderStatus = json['order_status'];
    subtotal = json['subtotal'];
    savings = json['savings'];
    gst = json['gst'];
    grandTotal = json['grand_total'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['address_id'] = this.addressId;
    data['order_status'] = this.orderStatus;
    data['subtotal'] = this.subtotal;
    data['savings'] = this.savings;
    data['gst'] = this.gst;
    data['grand_total'] = this.grandTotal;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? productId;
  String? productName;
  double? productPrice;
  double? gst;
  double? grandTotal;
  int? productQty;

  Products(
      {this.productId,
      this.productName,
      this.productPrice,
      this.gst,
      this.grandTotal,
      this.productQty});

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productPrice = double.parse(json['product_price'].toString());
    gst = json['gst'];
    grandTotal = json['grand_total'];
    productQty = json['product_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_price'] = this.productPrice;
    data['gst'] = this.gst;
    data['grand_total'] = this.grandTotal;
    data['product_qty'] = this.productQty;
    return data;
  }
}
