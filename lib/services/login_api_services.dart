import 'dart:convert';
import 'package:e_commerce_grocery_application/Pages/bottomnavbar.dart';
import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:e_commerce_grocery_application/provider/userIdprovider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:provider/provider.dart';

class ApiService {
  final String baseUrl =
      "https://quantapixel.in/ecommerce/grocery_app/public/api";
  Future<Map<String, dynamic>> getMinOrder() async {
    final url = Uri.parse('$baseUrl/getMinorder');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 1) {
          return responseData; // Return full response
        } else {
          throw Exception(responseData['message'] ?? "Failed to fetch data");
        }
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching data: ${e.toString()}");
    }
  }

  Future<bool> updatePaymentStatus(int orderId, String paymentStatus) async {
    final url = Uri.parse("$baseUrl/updatePaymentStatus");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "order_id": orderId,
          "payment_status": paymentStatus,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          print(responseData['message']);
          return true; // Success
        } else {
          print("Error: ${responseData['message']}");
          return false;
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Exception occurred: $e");
      return false;
    }
  }

  // Future<Map<String, dynamic>> login(
  //     String mobile, String password, context) async {
  //   final url = Uri.parse('$baseUrl/sign-in');
  //   final headers = {
  //     "Content-Type": "application/json",
  //   };
  //   final body = jsonEncode({
  //     "mobile": mobile,
  //     "password": password,
  //   });

  //   final response = await http.post(url, headers: headers, body: body);
  //   print("the error is ${response.statusCode}");
  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> responseData = jsonDecode(response.body);

  //     if (responseData['status'] == 1) {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => Bottomnavbar()),
  //       );
  //       // Login successful
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //             backgroundColor: const Color.fromARGB(255, 226, 226, 226),
  //             content: Text(
  //               "Login successful! Welcome ${responseData['data']['name']}",
  //               style: TextStyle(
  //                   fontWeight: FontWeight.w500,
  //                   color: Colors.green,
  //                   fontSize: 18),
  //             )),
  //       );

  //       // Navigate to the home screen or save user data for future use

  //       return responseData['data'];
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //             backgroundColor: const Color.fromARGB(255, 226, 226, 226),
  //             content: Text(
  //               "Login failed! Something went wrong.",
  //               style: TextStyle(
  //                   fontWeight: FontWeight.w500,
  //                   color: Colors.redAccent,
  //                   fontSize: 18),
  //             )),
  //       );
  //       throw Exception(responseData['message']);
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //           backgroundColor: const Color.fromARGB(255, 226, 226, 226),
  //           content: Text(
  //             "Login failed! Something went wrong.",
  //             style: TextStyle(
  //                 fontWeight: FontWeight.w500,
  //                 color: Colors.redAccent,
  //                 fontSize: 18),
  //           )),
  //     );
  //     throw Exception("Unexpected server response: ${response.body}");
  //   }
  // }

  Future<void> updateMinOrder(String id, String minOrder) async {
    // Define the API URL
    const String apiUrl =
        'https://quantapixel.in/ecommerce/grocery_app/public/api/updateMinorder';

    // Create the request body
    final Map<String, dynamic> body = {
      "id": id,
      "min_order": minOrder,
    };

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      // Check the status code
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          print(responseData[
              'message']); // "Min Order Value updated successfully."
        } else {
          print("Failed: ${responseData['message']}");
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future<Map<String, dynamic>> login(
      String mobile, String password, BuildContext context) async {
    final url = Uri.parse('$baseUrl/sign-in');
    final headers = {
      "Content-Type": "application/json",
    };
    final body = jsonEncode({
      "mobile": mobile,
      "password": password,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Extract user ID from the response
      final String userpasskey = responseData['data']['id'].toString();

      Provider.of<UserProvider>(context, listen: false).setUserId(userpasskey);

      final userService = UserService();

      // Save user ID after login
      await userService.saveUserId(userpasskey);
      print(userpasskey); // Correctly save the user ID

      // Return the response data after saving the user ID
      return responseData;
    } else {
      throw Exception("Failed to log in: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> register(
      {String? name,
      String? mobile,
      String? email,
      String? password,
      String? confirmPassword,
      String? address,
      context}) async {
    final url = Uri.parse('$baseUrl/register');
    final headers = {
      "Content-Type": "application/json",
    };
    final body = jsonEncode({
      "name": name,
      "mobile": mobile,
      "password": password,
      "password_confirmation": confirmPassword,
      "address": address
    });

    final response = await http.post(url, headers: headers, body: body);
    print("Response");
    print(jsonEncode(response.body));

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['status'] == 1) {
        // Login successful

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                responseData['message'].toString(),
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 18),
              )),
        );
        return responseData;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: const Color.fromARGB(255, 226, 226, 226),
              content: Text(
                responseData['message'],
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.redAccent,
                    fontSize: 18),
              )),
        );
        throw Exception(responseData['message']);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: const Color.fromARGB(255, 226, 226, 226),
            content: Text(
              "User with this Phone Number already exists",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.redAccent,
                  fontSize: 18),
            )),
      );
      throw Exception("Unexpected server response: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> editUser(
      {String? name,
      String? mobile,
      String? userid,
      String? address,
      context}) async {
    final url = Uri.parse('$baseUrl/edit-user');
    final headers = {
      "Content-Type": "application/json",
    };
    final body = jsonEncode({
      "name": name,
      "mobile": mobile,
      'user_id': userid,
      "address": address
    });

    final response = await http.post(url, headers: headers, body: body);
    print("Response");
    print(jsonEncode(response.body));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['status'] == 1) {
        // Login successful

        // Navigate to the home screen or save user data for future use
        Navigator.pop(context);

        return responseData;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: const Color.fromARGB(255, 226, 226, 226),
              content: Text(
                responseData['message'],
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.redAccent,
                    fontSize: 18),
              )),
        );
        throw Exception(responseData['message']);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: const Color.fromARGB(255, 226, 226, 226),
            content: Text(
              "Creation failed! Something went wrong.",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.redAccent,
                  fontSize: 18),
            )),
      );
      throw Exception("Unexpected server response: ${response.body}");
    }
  }
}
