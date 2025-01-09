import 'package:flutter/material.dart';
import 'package:e_commerce_grocery_application/Pages/models/place_order_request_model.dart';

class CartProvider extends ChangeNotifier {
  List<Products> _cart = [];
  List<Products> get cart => _cart;

  // Getter for the total price
  double get totalPrice {
    return _cart.fold(
      0,
      (sum, product) =>
          sum + (product.productPrice ?? 0) * (product.productQty ?? 0),
    );
  }

  // Add product to the cart
  void addToCart(Products product) {
    final index =
        _cart.indexWhere((item) => item.productId == product.productId);
    if (index != -1) {
      _cart[index].productQty = (_cart[index].productQty ?? 0) + 1;
    } else {
      _cart.add(product..productQty = 1); // Add new product with quantity = 1
    }
    notifyListeners();
  }

  // Remove product from the cart
  void removeProduct(String productId) {
    _cart.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  // Change quantity of a specific product in the cart
  void changeQuantity(String productId, int newQuantity) {
    final index = _cart.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      if (newQuantity > 0) {
        _cart[index].productQty = newQuantity;
      } else {
        removeProduct(productId); // Remove product if quantity is 0
      }
      notifyListeners();
    }
  }
}
