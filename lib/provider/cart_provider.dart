// import 'package:flutter/material.dart';

// class CartProvider with ChangeNotifier {
//   Map<int, int> _cartItems = {}; // Stores product id and quantity
//   // Getter for cart items
//   Map<int, int> get cartItems => _cartItems;

//   // Method to update the quantity in the cart
//   void updateCart(int productId, int quantity) {
//     if (quantity > 0) {
//       _cartItems[productId] = quantity; // Add/update item
//     } else {
//       _cartItems.remove(productId); // Remove item if quantity is 0
//     }
//     notifyListeners(); // Notify listeners to rebuild UI
//     // Here you would also call an API to update the cart on the server.
//     _updateCartOnServer(
//         productId, quantity); // API call to update cart remotely
//   }

//   // Simulate an API call to update the cart on the server or local storage
//   Future<void> _updateCartOnServer(int productId, int quantity) async {
//     // Example API call logic: Add or update the cart in the database
//     // Replace with actual API service call if needed

//     print("Updating cart for product $productId with quantity $quantity...");
//     // Example API call code
//     // await CartService.updateCart(productId, quantity);
//   }

//   // Method to get the quantity of a specific product in the cart
//   int getQuantity(int productId) {
//     return _cartItems[productId] ?? 0;
//   }

//   // Method to clear the cart (for example, after checkout)
//   void clearCart() {
//     _cartItems.clear();
//     notifyListeners(); // Notify listeners that the cart is now empty
//   }
// }
