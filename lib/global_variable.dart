import 'package:e_commerce_grocery_application/provider/userIdprovider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// String? getUserId(BuildContext context, {bool listen = false}) {
//   final userId = Provider.of<UserProvider>(context, listen: listen).userId;
//   return userId?.toString();
// }

String userId = "";

class UserService {
  // Singleton pattern to ensure only one instance of UserService is created
  static final UserService _instance = UserService._internal();

  factory UserService() {
    return _instance;
  }

  UserService._internal(); // Private constructor

  // Function to save the user ID to SharedPreferences
  Future<void> saveUserId(String userpassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userpassword);
    print('User ID saved: $userId'); // Optional for debugging
  }

  // Function to retrieve the user ID from SharedPreferences
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }
}

displayHeight(context) {
  return MediaQuery.of(context).size.height;
}

displayWidth(context) {
  return MediaQuery.of(context).size.width;
}

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

String formatDate(String dateString) {
  // Parse the input date string
  DateTime parsedDate = DateTime.parse(dateString);

  // Format the date
  String formattedDate = DateFormat('MMMM d, yyyy, h:mm a').format(parsedDate);
  return formattedDate;
}
