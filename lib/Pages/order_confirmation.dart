import 'package:e_commerce_grocery_application/Pages/bottomnavbar.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:flutter/material.dart';

class OrderConfirmationPage extends StatelessWidget {


  OrderConfirmationPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor, // Adjusted for success theme
        title: Text(
          'Order Confirmation',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Displaying the celebratory GIF
            Image.network(
              'https://i.pinimg.com/originals/4a/10/e3/4a10e39ee8325a06daf00881ac321b2f.gif',
              height: 200, // Adjust the size as needed
              width: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            // Order Placed Message
            Text(
              'Order Placed Successfully!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 10),
            // Additional details
            Text(
              'Thank you for shopping with us!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
           SizedBox(height: 20),
ElevatedButton(
  onPressed: () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Bottomnavbar()),
    );
    // Alternatively, use Navigator.push if you don't want to replace the current screen
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => Homescreen()),
    // );
  },
  child: Text('Continue Shopping'),
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.mainColor, // Button color
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
),

          ],
        ),
      ),
    );
  }
}
