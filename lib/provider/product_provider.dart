import 'package:flutter/material.dart';
import 'package:e_commerce_grocery_application/Pages/model_category.dart/product_model.dart';

class ProductProvider with ChangeNotifier {
  late Product _productName;

  Product get searchedProduct => _productName;

  // Set the selected product
  void setSelectedProduct(productName) {
    _productName = productName;
    notifyListeners(); // Notify listeners when data is updated
  }
}
