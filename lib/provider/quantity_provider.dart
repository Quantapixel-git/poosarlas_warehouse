import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  Map<int, int> _productQuantities = {};

  Map<int, int> get productQuantities => _productQuantities;

  void incrementQuantity(int productId) {
    _productQuantities[productId] = (_productQuantities[productId] ?? 0) + 1;
    notifyListeners();
  }

  void decrementQuantity(int productId) {
    if (_productQuantities[productId] != null &&
        _productQuantities[productId]! > 0) {
      _productQuantities[productId] = _productQuantities[productId]! - 1;
      notifyListeners();
    }
  }

  void setQuantity(int productId, int quantity) {
    _productQuantities[productId] = quantity;
    notifyListeners();
  }
}
