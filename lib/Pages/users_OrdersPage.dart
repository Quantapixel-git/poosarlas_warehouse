import 'package:e_commerce_grocery_application/Pages/admin/users/userview_detail.dart';
import 'package:e_commerce_grocery_application/Pages/models/JsonDartYOrders.dart';
import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage({super.key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<JsonDartYOrders> _futureOrders;

 Future<void> fetchUserDetail(BuildContext context) async {
  final userService = UserService(); // Use the singleton instance

  var userId = await userService.getUserId();
  print('Fetched user ID: $userId');

  // Ensure userId is a string
  if (userId is int) {
    userId = userId.toString(); // Convert to string if it's an integer
  } else if (userId is String) {
    // It's already a string, do nothing
  } else {
    print('User  ID is neither int nor String, cannot fetch orders.');
    return; // Exit if userId is not valid
  }

  print('Fetching orders for user ID: $userId');
  _futureOrders = ProductService().fetchOrders(userId);
  setState(() {});
}

  @override
  void initState() {
    super.initState();
    print('Initializing OrdersPage...');
    fetchUserDetail(context);
  }

  @override
  Widget build(BuildContext context) {
    print('Building OrdersPage...');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Order History"),
      ),
      body: FutureBuilder<JsonDartYOrders>(
        future: _futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('Waiting for orders to load...');
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error fetching orders: ${snapshot.error}');
            return Center(child: Text("No Orders yet"));
          } else if (snapshot.hasData) {
            final orders = snapshot.data!.orders;
            print(
                'Orders fetched successfully. Number of orders: ${orders!.length}');
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                print('Building order card for Order ID: ${order.id}');
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order ID: ${order.id}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("Status: ${order.orderStatus}"),
                        Text("Total: ₹${order.grandTotal}"),
                        Divider(),
                        Text("Products:", style: TextStyle(fontSize: 14)),
                        ElevatedButton(
                          onPressed: () {
                            print(
                                'Navigating to details for Order ID: ${order.id}');
                            // Navigate to the details page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserView(order: order),
                              ),
                            );
                          },
                          child: Text('View Details'),
                        ),
                        ...order.products!.map((product) {
                          print(
                              'Building product tile for: ${product.productName}');
                          return ListTile(
                            leading: Image.network(
                              product.productImageUrl ?? '',
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.error),
                            ),
                            title: Text(product.productName.toString()),
                            subtitle: Text(
                                "Price: ₹${product.productPrice}\nQty: ${product.productQty}"),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            print('No orders available.');
            return Center(child: Text("No orders available"));
          }
        },
      ),
    );
  }
}
