import 'package:flutter/material.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';

class OrderDetailPage extends StatefulWidget {
  final Map order;

  OrderDetailPage({required this.order});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  String formatDate(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime);
    return "${parsedDate.day}-${parsedDate.month}-${parsedDate.year} ${parsedDate.hour}:${parsedDate.minute}";
  }

  @override
  Widget build(BuildContext context) {
    final user =
        widget.order['user'] ?? {}; // Extract user details from the order
    final products =
        widget.order['products'] ?? []; // Extract products from the order

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.navigate_before)),
        title: Text('Order Details'),
        backgroundColor: AppColors.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Order Information
            Text(
              'Order ID: ${widget.order['id']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('User ID: ${widget.order['user_id'] ?? 'N/A'}'),
            Text('Address ID: ${widget.order['address_id'] ?? 'N/A'}'),
            Text('Order Status: ${widget.order['order_status'] ?? 'N/A'}'),
            Text('Subtotal: ₹${widget.order['subtotal'] ?? '0.00'}'),
            Text(
                'Delivery Charge: ₹${((double.tryParse(widget.order['grand_total'].toString()) ?? 0.0) - (double.tryParse(widget.order['subtotal'].toString()) ?? 0.0)) ?? "0.00"}'),

            Text('Grand Total: ₹${widget.order['grand_total'] ?? '0.00'}'),
            Text('Created At: ${formatDate(widget.order['created_at'])}'),
            Text('Updated At: ${formatDate(widget.order['updated_at'])}'),
            SizedBox(height: 20),

            // User Details
            Text(
              'User Details:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (widget.order.isNotEmpty) ...[
              Text('Name: ${widget.order["address_name"]}'),
              SizedBox(height: 4),
              Text('Mobile: ${widget.order["address_mobile"]}'),
              SizedBox(height: 4),
              Text('Address: ${widget.order["address"]}'),
            ] else
              Text('No user details available'),
            SizedBox(height: 20),

            // Products Section
            Text(
              'Products:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            products.isEmpty
                ? Text('No products available')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        elevation: 4,
                        child: ListTile(
                          title: Text(
                              'Product: ${product['product_name'] ?? 'N/A'}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Quantity: ${product['product_qty'] ?? 'N/A'}'),
                              Text(
                                  'Price: ₹${product['product_price'] ?? '0.00'}'),
                            ],
                          ),
                          leading: product['product_image_url'] != null
                              ? Image.network(
                                  product['product_image_url'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.image, size: 50),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
