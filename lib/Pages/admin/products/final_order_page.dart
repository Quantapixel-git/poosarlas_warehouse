import 'dart:convert';
import 'package:e_commerce_grocery_application/Pages/model_category.dart/product_model.dart';
import 'package:e_commerce_grocery_application/Pages/order_confirmation.dart';
import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:e_commerce_grocery_application/services/login_api_services.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:flutter/material.dart';

class FinalOrderDeliveryPage extends StatefulWidget {
  final Map params;
  final String address;

  FinalOrderDeliveryPage({required this.params, required this.address});

  @override
  _FinalOrderDeliveryPageState createState() => _FinalOrderDeliveryPageState();
}

class _FinalOrderDeliveryPageState extends State<FinalOrderDeliveryPage> {
  final TextEditingController instructionsController = TextEditingController();
  String selectedPaymentMethod = 'Cash on Delivery';

  bool isLoading = true; // Loading state
  Map<String, dynamic> orderSummary = {}; // Data to hold the order summary

  @override
  void initState() {
    super.initState();
    _fetchFinalPricing(); // Fetch the pricing when the page loads
  }

  // Fetch pricing data from the API
  Future<void> _fetchFinalPricing() async {
    try {
      setState(() {
        orderSummary = {
          'subtotal':
              double.tryParse(widget.params['subtotal'].toString()) ?? 0.0,
          'savings':
              double.tryParse(widget.params['savings'].toString()) ?? 0.0,
          'gst': double.tryParse(widget.params['gst'].toString()) ?? 0.0,
          'delivery_charge':
              (double.tryParse(widget.params['grand_total'].toString()) ??
                      0.0) -
                  (double.tryParse(widget.params['subtotal'].toString()) ??
                      0.0),
          'grand_total':
              double.tryParse(widget.params['grand_total'].toString()) ?? 0.0,
        };
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching pricing: $e');
    }
  }

  Future<void> updatePayment(int orderId, String paymentStatus) async {
    bool success =
        await ApiService().updatePaymentStatus(orderId, paymentStatus);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment status updated successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update payment status.")),
      );
    }
  }

  Future<void> placeOrder() async {
    print('${widget.params} 12345');

    // Prepare products list
    List<Map<String, dynamic>> prod = widget.params['products']
            ?.map<Map<String, dynamic>>((product) => {
                  "product_id": product['product_id'],
                  "product_name": product['product_name'],
                  "product_price":
                      double.tryParse(product['product_price'].toString()) ??
                          0.0,
                  "gst": double.tryParse(product['gst'].toString()) ?? 0.0,
                  "grand_total":
                      double.tryParse(product['grand_total'].toString()) ?? 0.0,
                  "product_qty": product['product_qty'],
                })
            ?.toList() ??
        [];

    if (prod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No products found in the order.')),
      );
      return;
    }

    // Get user ID
    final userService = UserService();
    String? userId = await userService.getUserId();
    print('User ID: $userId');

    if (userId == null || userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ID is missing. Please login again.')),
      );
      return;
    }

    // Prepare request body
    Map<String, dynamic> body = {
      "user_id": int.parse(userId),
      "address_id": widget.params['address_id'],
      "order_status": "Pending",
      "note": instructionsController.text,
      "subtotal": double.tryParse(widget.params['subtotal'].toString()) ?? 0.0,
      "savings": double.tryParse(widget.params['savings'].toString()) ?? 0.0,
      "gst": double.tryParse(widget.params['gst'].toString()) ?? 0.0,
      "grand_total":
          double.tryParse(widget.params['grand_total'].toString()) ?? 0.0,
      "products": prod,
    };

    print('Request Body: ${jsonEncode(body)}');

    // Fetch minimum order value
    try {
      final response = await ApiService().getMinOrder();
      if (response['status'] == 1) {
        final minOrder =
            double.parse(response['data'][0]['min_order'].toString());
        final grandTotal =
            double.tryParse(widget.params['grand_total'].toString()) ?? 0.0;

        if (grandTotal < minOrder) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('The minimum order value should be ₹$minOrder')),
          );
          return;
        }
      } else {
        throw Exception(
            response['message'] ?? 'Failed to fetch minimum order value');
      }
    } catch (e) {
      print('Error fetching minimum order value: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to fetch minimum order value.')),
      );
      return;
    }

    // Place the order
    setState(() {
      isLoading = true;
    });

    try {
      var response = await ProductService().placeOrder(body);
      setState(() {
        isLoading = false;
      });

      if (response != null && response['status'] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order placed successfully!')),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return OrderConfirmationPage();
        }));
      } else if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response['message'] ?? 'Order placement failed.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Please clear pending payments to proceed with your order.')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error placing order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderItems =
        List<Map<String, dynamic>>.from(widget.params['products'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Text('Final Order'),
        backgroundColor: AppColors.mainColor,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loader
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery Address
                    Text('Delivery Address',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Card(
                      elevation: 4,
                      child: ListTile(
                        title: Text(widget.address),
                        trailing: TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Change address logic
                          },
                          child: Text('Change'),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Order Summary
                    Text('Order Summary',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: orderItems.length,
                      itemBuilder: (context, index) {
                        final item = orderItems[index];
                        return ListTile(
                          title: Text(item['product_name']),
                          subtitle: Text('Qty: ${item['product_qty']}'),
                          trailing: Text('₹${item['product_price']}'),
                        );
                      },
                    ),
                    Divider(),
                    ListTile(
                      title: Text('Subtotal'),
                      trailing: Text('₹${orderSummary['subtotal']}'),
                    ),
                    ListTile(
                      title: Text('Delivery Charge'),
                      trailing: Text(
                          '₹${orderSummary['delivery_charge'].toString()}'),
                    ),
                    ListTile(
                      title: Text('Grand Total',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      trailing: Text('₹${orderSummary['grand_total']}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    SizedBox(height: 16),

                    // Payment Method
                    Text('Payment Method',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      value: selectedPaymentMethod,
                      items: ['Cash on Delivery']
                          .map((method) => DropdownMenuItem<String>(
                                value: method,
                                child: Text(method),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16),

                    // Additional Instructions
                    Text('Additional Instructions',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    TextField(
                      controller: instructionsController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText:
                            'Add any special instructions for delivery...',
                      ),
                    ),
                    SizedBox(height: 16),

                    // Place Order Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          placeOrder();
                        },
                        child: Text('Place Order'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
