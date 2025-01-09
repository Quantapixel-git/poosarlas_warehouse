import 'package:e_commerce_grocery_application/Pages/models/JsonDartYOrders.dart';
import 'package:e_commerce_grocery_application/Pages/models/order_response_model.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';

class UserView extends StatelessWidget {
  final Orderxy order;

  UserView({Key? key, required this.order}) : super(key: key);

  /// Helper function to format date safely
  String formatDate(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) {
      return 'N/A';
    }
    try {
      DateTime parsedDate = DateTime.parse(dateTime);
      return "${parsedDate.day}-${parsedDate.month}-${parsedDate.year} ${parsedDate.hour}:${parsedDate.minute}";
    } catch (e) {
      return 'Invalid Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back),
        ),
        title: Text('Order Details'),
        backgroundColor: AppColors.mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Order Information
            Text(
              'Order ID: ${order.id}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('User ID: ${order.userId ?? 'N/A'}'),
            Text('Address ID: ${order.addressId ?? 'N/A'}'),
            Text('Order Status: ${order.orderStatus ?? 'N/A'}'),
            Text('Subtotal: ₹${order.subtotal ?? '0.00'}'),
            Text(
                'Delivery Charge: ₹${((double.tryParse(order.grandTotal.toString()) ?? 0.0) - (double.tryParse(order.subtotal.toString()) ?? 0.0)) ?? "0.00"}'),

            Text('Grand Total: ₹${order.grandTotal ?? '0.00'}'),
            Text('Created At: ${formatDate(order.createdAt)}'),
            Text('Updated At: ${formatDate(order.updatedAt)}'),
            SizedBox(height: 20),

            // Products Section
            Text(
              'Products:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            order.products == null || order.products!.isEmpty
                ? Text('No products available')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: order.products!.length,
                    itemBuilder: (context, index) {
                      final product = order.products![index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        elevation: 4,
                        child: ListTile(
                          title:
                              Text('Product: ${product.productName ?? 'N/A'}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Quantity: ${product.productQty ?? 'N/A'}'),
                              Text('Price: ₹${product.productPrice ?? '0.00'}'),
                            ],
                          ),
                          leading: product.productImageUrl != null
                              ? Image.network(
                                  product.productImageUrl!,
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
