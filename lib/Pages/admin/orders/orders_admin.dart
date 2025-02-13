import 'package:e_commerce_grocery_application/Pages/admin/orders/order_detail_page.dart';
import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:e_commerce_grocery_application/services/ImageSliderServices.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class MakeOrderPage extends StatefulWidget {
  final bool isAdmin; // True for Admin, False for User

  MakeOrderPage({required this.isAdmin});

  @override
  _MakeOrderPageState createState() => _MakeOrderPageState();
}

class _MakeOrderPageState extends State<MakeOrderPage> {
  List orders = [];
  List finalOrder = [];
  String orderStatus = "";
  String paymentStatus = "";
  TextEditingController searchController =
      TextEditingController(); // Search controller
  final Imagesliderservices _apiService = Imagesliderservices();
  bool _isLoading = false;
  String _message = "";

  // API base URL
  final String apiUrl =
      "https://quantapixel.in/ecommerce/grocery_app/public/api/all-orders";

  // Fetch Orders (Admin and User)
  Future<void> fetchOrders() async {
    final response = (await ProductService().fetchOrderList())!;
    orders = response['orders'];
    finalOrder = orders;
    print(response);
    setState(() {});
  }

  // Create Order (User)
  Future<void> createOrder(String product, int quantity, String address) async {
    final response = await http.post(
      Uri.parse('$apiUrl/orders'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "product": product,
        "quantity": quantity,
        "address": address,
      }),
    );
    if (response.statusCode == 201) {
      fetchOrders();
    }
  }

  // Update Order Status (Admin)
  Future<void> updateOrderStatus(
      int userId, int orderId, String orderstatus) async {
    var body = {
      "user_id": userId.toString(),
      "order_id": orderId.toString(),
      "order_status": orderstatus,
    };

    var response = await ProductService().updateOrderStatus(context, body);
    fetchOrders();
  }

  Future<void> updatePaymentStatus(
      int userId, int orderId, String status) async {
    final body = {
      "order_id": orderId.toString(),
      "payment_status": status.toUpperCase(),
    };

    try {
      var response = await ProductService()
          .updatePaymenttStatus(context, orderId, status.toUpperCase());

      // Debug: print the response to ensure it's not null
      print("API Response: $response");

      // Check if the response is not null and if it's a Map
      if (response != null && response is Map<String, dynamic>) {
        if (response['status'] == 1) {
          print("Payment status updated successfully!");
          _refreshPage();

          // Update the local orders list
          final updatedOrder = orders.firstWhere(
              (order) => order['id'] == orderId,
              orElse: () => null);
          if (updatedOrder != null) {
            setState(() {
              updatedOrder['payment_status'] = status.toUpperCase();
            });
          }

          //fetchOrders(); // Optionally refresh the entire list from the backend
        } else {
          // Handle the case when 'status' is not 1
          String message = response.containsKey('message')
              ? response['message']
              : 'Unknown error';
          print("Failed to update payment status: $message");
        }
      } else {
        // Log the invalid response
        print("Invalid response format: $response");
      }
    } catch (e) {
      print("Error updating payment status: $e");
    }
  }

  Future<void> _refreshPage() async {
    setState(() {
      fetchOrders();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text(widget.isAdmin ? 'ALL ORDERS' : 'Make Order'),
      ),
      body: widget.isAdmin ? adminView() : userView(),
    );
  }

  // Admin View
  Widget adminView() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: "Search Orders by Order ID",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (query) {
              if (query.isNotEmpty) {
                setState(() {
                  orders = orders
                      .where((order) => order['id'].toString().contains(query))
                      .toList();
                });
              } else {
                orders = finalOrder;
              }
              setState(() {});
            },
          ),
        ),
        Text(
          'Scroll Down to refresh',
          style: GoogleFonts.poppins(
            color: const Color.fromARGB(179, 0, 0, 0),
            fontSize: 12,
          ),
        ),
        Expanded(
          child: orders.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: _refreshPage,
                  child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text('Order ID: ${order['id']}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('User ID: ${order["user_id"]}'),
                                  SizedBox(height: 4),
                                  Text('Name: ${order["address_name"]}'),
                                  SizedBox(height: 4),
                                  Text('Mobile: ${order["address_mobile"]}'),
                                  SizedBox(height: 4),
                                  Text('Address: ${order["address"]}'),

                                  // Text('Subtotal: \₹${order['subtotal']}'),
                                  // Text(
                                  //     'Grand Total: \₹${order['grand_total']}'),
                                  SizedBox(height: 4),
                                  Text(
                                      'Created At: ${formatDate(order['created_at'])}'),
                                  SizedBox(height: 10),
                                  Text(
                                      'Payment Status: ${order['payment_status']}'), // Added payment status

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Order Status Dropdown
                                          // Order Status Dropdown
                                          DropdownButton<String>(
                                            value: [
                                              'placed',
                                              'processing',
                                              'delivered',
                                              'cancelled'
                                            ].contains(order['order_status'])
                                                ? order['order_status']
                                                : 'placed', // Default to 'placed' if order_status is invalid
                                            items: [
                                              'placed',
                                              'processing',
                                              'delivered',
                                              'cancelled'
                                            ]
                                                .map((orderstatus) =>
                                                    DropdownMenuItem(
                                                      value: orderstatus,
                                                      child: Text(
                                                        capitalize(orderstatus),
                                                      ),
                                                    ))
                                                .toList(),
                                            onChanged: (value) {
                                              if (value != null &&
                                                  value !=
                                                      order['order_status']) {
                                                updateOrderStatus(
                                                  int.tryParse(order['user_id']
                                                          .toString()) ??
                                                      0,
                                                  order['id'],
                                                  value.toLowerCase(),
                                                );
                                              }
                                            },
                                          ),

                                          // Payment Status Dropdown
                                          DropdownButton<String>(
                                            value: ['PAID', 'UNPAID'].contains(
                                                    order['payment_status']
                                                        ?.toUpperCase())
                                                ? order['payment_status']
                                                    ?.toUpperCase()
                                                : 'UNPAID', // Default to 'UNPAID' if invalid
                                            items: ['PAID', 'UNPAID']
                                                .map((status) =>
                                                    DropdownMenuItem(
                                                      value: status,
                                                      child: Text(capitalize(status
                                                          .toLowerCase())), // Display friendly text
                                                    ))
                                                .toList(),
                                            onChanged: (value) {
                                              if (value != null &&
                                                  value !=
                                                      order['payment_status']) {
                                                updatePaymentStatus(
                                                  int.tryParse(order['user_id']
                                                          .toString()) ??
                                                      0,
                                                  order['id'],
                                                  value
                                                      .toUpperCase(), // Send uppercase value
                                                );
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                      Container(
                                          child: ElevatedButton(
                                              onPressed: () {
                                                launch(
                                                    'https://quantapixel.in/ecommerce/grocery_app/public/invoice/${order['id']}');
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 255, 255, 255),
                                                  foregroundColor:
                                                      const Color.fromARGB(
                                                          255, 33, 58, 143)),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Download',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 16),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Icon(Icons.download),
                                                ],
                                              )))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return OrderDetailPage(order: order);
                                        },
                                      ),
                                    );
                                  },
                                  child: Text('View Details'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  // User View
  Widget userView() {
    final TextEditingController productController = TextEditingController();
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController addressController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: productController,
            decoration: InputDecoration(labelText: 'Product Name'),
          ),
          TextField(
            controller: quantityController,
            decoration: InputDecoration(labelText: 'Quantity'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: addressController,
            decoration: InputDecoration(labelText: 'Delivery Address'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              createOrder(
                productController.text,
                int.parse(quantityController.text),
                addressController.text,
              );
            },
            child: Text('Place Order'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text('Order ID: ${order['id']}'),
                      subtitle: Text('Status: ${order['status']}'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String capitalize(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }
}
