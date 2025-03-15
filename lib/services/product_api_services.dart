import 'dart:convert';
import 'dart:io';
import 'package:e_commerce_grocery_application/Pages/cartpage.dart';
import 'package:e_commerce_grocery_application/Pages/model_category.dart/product_model.dart';
import 'package:e_commerce_grocery_application/Pages/models/JsonDartYOrders.dart';
import 'package:e_commerce_grocery_application/Pages/models/cart_details.dart';
import 'package:e_commerce_grocery_application/Pages/models/user_details_model.dart';
import 'package:e_commerce_grocery_application/Pages/models/user_model.dart';
import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ProductService {
  final String baseUrl =
      "https://quantapixel.in/ecommerce/grocery_app/public/api";
  final String accessKey = "PMAT-01JDF1ZCPKHE7PXSVT9J6YG1AZ";
  Future<Response?> addProduct({
    required File productImage,
    File? additionalImage1,
    File? additionalImage2,
    required String categoryId,
    required String productName,
    required String productPrice,
    required String productDiscount,
    required String stock, // Expect numeric string values here
    required String productShortDescription,
    required String productDescription,
    required String Deliverycharge,
  }) async {
    final uri = Uri.parse(
        'https://quantapixel.in/ecommerce/grocery_app/public/api/storeProduct');

    final request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      "Authorization": "Bearer $accessKey", // Ensure accessKey is defined
      "Accept": "application/json",
    });

    // Add required image
    request.files.add(
      await http.MultipartFile.fromPath('product_image', productImage.path),
    );

    // Add optional images
    if (additionalImage1 != null && additionalImage1.path.isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath(
            'additional_image_1', additionalImage1.path),
      );
    }

    if (additionalImage2 != null && additionalImage2.path.isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath(
            'additional_image_2', additionalImage2.path),
      );
    }

    // Add other fields
    request.fields['category_id'] = categoryId;
    request.fields['product_name'] = productName;
    request.fields['product_price'] = productPrice; // Numeric as string
    request.fields['product_discount'] = productDiscount; // Numeric as string
    request.fields['stock'] = stock; // Integer as string
    request.fields['delivery_charge'] = Deliverycharge;

    request.fields['product_description'] = productDescription;
    request.fields['product_short_description'] = productShortDescription;

    try {
      final streamedResponse = await request.send();
      return await http.Response.fromStream(streamedResponse);
    } catch (e) {
      print("Error sending request: $e");
      return null;
    }
  }

  Future<http.Response?> editProduct({
    required String productId,
    required String categoryId,
    required String productName,
    required String productPrice,
    required String productDiscount,
    required String stock,
    required String productDescription,
    File? productImage,
    File? additionalImage1,
    File? additionalImage2,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/editProduct"),
      );

      // Add form fields
      request.fields['product_id'] = productId;
      request.fields['category_id'] = categoryId;
      request.fields['product_name'] = productName;
      request.fields['product_price'] = productPrice;
      request.fields['product_discount'] = productDiscount;
      request.fields['stock'] = stock;
      request.fields['product_description'] = productDescription;

      // Add images only if they are not null
      if (productImage != null && productImage.path.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'product_image',
          productImage.path,
        ));
      }

      if (additionalImage1 != null && additionalImage1.path.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'additional_image_1',
          additionalImage1.path,
        ));
      }

      if (additionalImage2 != null && additionalImage2.path.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'additional_image_2',
          additionalImage2.path,
        ));
      }

      // Send request
      final streamedResponse = await request.send();
      return await http.Response.fromStream(streamedResponse);
    } catch (e) {
      print("Error editing product: $e");
      return null;
    }
  }

  // Fetch product by ID
  Future<Map<String, dynamic>?> fetchProductById(String productId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getProductById'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'product_id': int.parse(productId)}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          return data['data'];
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception(
            'Failed to fetch product. Status: ${response.statusCode}');
      }
    } catch (error) {
      print("Error fetching product by ID: $error");
      return null;
    }
  }

  Future<Map<String, dynamic>?> similarProducts(String categoryId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/similar-products'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'category_id': int.parse(categoryId)}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          return data['data'];
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception(
            'Failed to fetch product. Status: ${response.statusCode}');
      }
    } catch (error) {
      print("Error fetching product by ID: $error");
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchProductByName(String productName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/product-search'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'product_name': int.parse(productName)}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          return data['data'];
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception(
            'Failed to fetch product. Status: ${response.statusCode}');
      }
    } catch (error) {
      print("Error fetching product by ID: $error");
      return null;
    }
  }

  Future<List<Product>> getAllProducts() async {
    const String apiUrl =
        "https://quantapixel.in/ecommerce/grocery_app/public/api/getAllProducts";

    try {
      final response = await http.get(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'});

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}"); // Log the response body

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Check if the response contains the expected structure
        if (jsonResponse['status'] == 1) {
          final List<dynamic> productsData = jsonResponse['data'];
          return productsData
              .map((product) => Product.fromJson(product))
              .toList();
        } else {
          throw Exception(
              'Failed to load products: ${jsonResponse['message']}');
        }
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print("Exception: $e");
      throw Exception('Failed to load products');
    }
  }

  Future<Map<String, dynamic>> getFilter() async {
    final url = Uri.parse('$baseUrl/getFilter');
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

  Future<Map<String, dynamic>> getAllProductsByUserId(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getAllProductsByUserId'),
        headers: {
          "Authorization": "Bearer $accessKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_id": userId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        print("Products fetched successfully!");
        return data;
      } else {
        print("Failed to fetch products: ${response.statusCode}");
        print("Response: ${response.body}");
        return {
          "success": false,
          "message": "Failed to fetch products",
          "status_code": response.statusCode,
          "body": response.body,
        };
      }
    } catch (e) {
      print("Error during fetch: $e");
      return {
        "success": false,
        "message": "Error during fetch: $e",
      };
    }
  }

  Future<void> deleteProduct(int productId, String accessKey) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/deleteProduct'),
        headers: {
          "Authorization": "Bearer $accessKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "product_id": productId,
        }),
      );

      if (response.statusCode == 200) {
        print("Category deleted successfully!");
      } else {
        print("Failed to delete category: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Error during deletion: $e");
    }
  }

  Future<void> updateStatus(int productId, String status) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/updateProductStatus'),
        headers: {
          "Authorization": "Bearer $accessKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"product_id": productId, "status": status}),
      );

      if (response.statusCode == 200) {
        print("Product updated successfully!");
      } else {
        print("Failed to Updated Product: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Error during deletion: $e");
    }
  }

  Future<void> updateFilter(String id, String filter) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/updateFilter'),
        headers: {
          "Authorization": "Bearer $accessKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"id": id, "filter": filter}),
      );

      if (response.statusCode == 200) {
        print("User status updated successfully!");
      } else {
        print("Failed to Update User Status: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> updateUserStatus(int userId, String status) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/updateUserStatus'),
        headers: {
          "Authorization": "Bearer $accessKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"user_id": userId, "status": status}),
      );

      if (response.statusCode == 200) {
        print("User status updated successfully!");
      } else {
        print("Failed to Update User Status: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<Map<String, dynamic>?> addToCart(
      String userIdCart, String productIdd, context, int quantitty) async {
    Map<String, dynamic> data = {"user_id": userIdCart};
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/add-to-cart'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'product_id': productIdd,
          'user_id': userIdCart,
          'quantity': quantitty
        }),
      );
      print(json.encode({
        'product_id': productIdd,
        'user_id': userIdCart,
        'quantity': quantitty
      }));
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(data['message']),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Cartpage()),
          );
          return data['data'];
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(data['message']),
            ),
          );
          throw Exception(data['message']);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content:
                Text("Failed to fetch product. Status: ${response.statusCode}"),
          ),
        );
        throw Exception(
            'Failed to fetch product. Status: ${response.statusCode}');
      }
    } catch (error) {
      print("Error fetching product by ID: $error");
      return null;
    }
  }

  Future<CartDetailsModel?> cartDetail(
      String useridCD, BuildContext context) async {
    Map<String, dynamic> data = {"user_id": useridCD};

    try {
      print(userId);
      final response = await http.post(
        Uri.parse('$baseUrl/carts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': useridCD}),
      );

      // Decode the JSON response
      print('Raw response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Check for success status in the API response
        if (data['status'] == 1) {
          // Check if cart data is empty
          if (data['data'] == null || (data['data'] as List).isEmpty) {
            // If cart is empty, return null
            return null;
          } else {
            // Map the response to CartDetailsModel
            return CartDetailsModel.fromJson(data);
          }
        } else {
          // Handle the case where status is not 1
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(data['message'] ?? 'Unknown error occurred'),
            ),
          );
          return null;
        }
      } else {
        // Handle HTTP status code errors

        print("Failed to fetch cart. Status: ${response.statusCode}");

        return null;
      }
    } catch (error, _) {
      // Handle exceptions
      print("Error fetching cart by ID: $error");
      print("Error fetching cart by ID: $_");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("An error occurred: $error"),
        ),
      );
      return null;
    }
  }

  Future<CartDetailsModel?> cartQuantityUpdate(
      BuildContext context, cartId, quantity) async {
    try {
      print(cartId);
      final response = await http.post(
        Uri.parse('$baseUrl/quantity'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'cart_id': cartId, 'quantity': quantity}),
      );

      // Decode the JSON response

      // Debugging the raw response
      print('Raw response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Check for success status in the API response
        if (data['status'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(data['message'] ?? ''),
            ),
          );
          return CartDetailsModel.fromJson(data);
        } else {
          // Handle the case where status is not 1
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(data['message'] ?? 'Unknown error occurred'),
            ),
          );
          return null;
        }
      } else {
        // Handle HTTP status code errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content:
                Text("Failed to fetch cart. Status: ${response.statusCode}"),
          ),
        );
        return null;
      }
    } catch (error) {
      // Handle exceptions
      print("Error fetching cart by ID: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("An error occurred: $error"),
        ),
      );
      return null;
    }
  }

  Future<Map<String, dynamic>?> deleteCartItem(
      String userIdDelCart, BuildContext context, int? cartId) async {
    Map<String, dynamic> data = {"user_id": userIdDelCart};
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete-cart'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': userIdDelCart, 'cart_id': cartId}),
      );
      // print(userId);
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(data['message'] ?? 'Item deleted successfully'),
            ),
          );
          return data;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(data['message'] ?? 'Failed to delete item'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to delete item. Please try again later.'),
          ),
        );
        print("Failed to delete item: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      // Print detailed error information to help debug the issue
      print("Error during deletion: $e");
      if (e is http.ClientException) {
        print("ClientException: ${e.message}");
      } else if (e is SocketException) {
        print("SocketException: Unable to connect to the server.");
      } else {
        print("Unknown error: $e");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    }
    return null;
  }

  Future<List<User>> fetchUsersList() async {
    try {
      // Sending GET request to the API
      final response = await http.get(
        Uri.parse('$baseUrl/get-users'),
        headers: {'Content-Type': 'application/json'},
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        final data = json.decode(response.body); // Decode JSON response

        // Check if the 'status' field indicates success
        if (data['status'] == 1) {
          // Extract the 'users' list and map it to a list of User objects
          List<dynamic> usersJson = data['users'];
          return usersJson.map((json) => User.fromJson(json)).toList();
        } else {
          throw Exception(
              data['message']); // Throw an exception if 'status' is not 1
        }
      } else {
        throw Exception(
            'Failed to fetch users. Status: ${response.statusCode}');
      }
    } catch (error) {
      print("Error fetching users: $error");
      rethrow; // Rethrow the error to be handled in the UI or calling code
    }
  }

  Future<Map<String, dynamic>?> deleteUser(
      BuildContext context, String? user_id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete-user'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': user_id,
        }),
      );
      print(response.body);
      final Map<String, dynamic> data = json.decode(response.body);

      if (response.statusCode == 200) {
        if (data['status'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(data['message']),
            ),
          );
          return data;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Already deleted.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Already deleted.'),
          ),
        );
        print("Failed to Updated Product: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e, test) {
      print("Error during deletion: $e");
      print("Error during deletion: $test");
      return null;
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchOrderList() async {
    try {
      print("Starting to fetch order list...");

      final response = await http.get(
        Uri.parse('$baseUrl/all-orders'),
        headers: {'Content-Type': 'application/json'},
      );

      print("Response received. Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Response body: ${response.body}");

        final data = json.decode(response.body);
        print("Decoded JSON data: $data");

        if (data['status'] == 1) {
          print("Order list fetched successfully.");
          return data;
        } else {
          print("Error in response: ${data['message']}");
          throw Exception(data['message']);
        }
      } else {
        print("Failed to fetch product. Status: ${response.statusCode}");
        throw Exception(
            'Failed to fetch product. Status: ${response.statusCode}');
      }
    } catch (error) {
      print("Error fetching order list: $error");
      return null;
    }
  }

  Future<UserDetailsModel> getUserDetails(String userIdget, context) async {
    // Check if userId is available
    if (userIdget == null) {
      throw Exception('User ID not found');
    }
    Map<String, dynamic> data = {"user_id": userIdget};
    // print(" 123 $data");
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/get-profile'), body: data);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("jsonResponse $jsonResponse");

        if (jsonResponse['status'] == 1) {
          return UserDetailsModel.fromJson(jsonResponse);
        } else {
          throw Exception(
              'Failed to load user details: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to load user details: ${response.statusCode}');
      }
    } catch (e, _) {
      print("Error fetching user details: $e, $_");
      throw Exception('Failed to load products');
    }
  }

  Future<dynamic> fetchUserOrder(BuildContext context) async {
    try {
      print(userId);
      final response = await http.post(
        Uri.parse('$baseUrl/user-orders'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'': userId}),
      );

      // Decode the JSON response

      // Debugging the raw response
      print('Raw response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Check for success status in the API response
        if (data['status'] == 1) {
          // Map the response to CartDetailsModel
          return data;
        } else {
          // Handle the case where status is not 1
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(data['message'] ?? 'Unknown error occurred'),
            ),
          );
          return null;
        }
      } else {
        // Handle HTTP status code errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content:
                Text("Failed to fetch cart. Status: ${response.statusCode}"),
          ),
        );
        return null;
      }
    } catch (error) {
      // Handle exceptions
      print("Error fetching cart by ID: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("An error occurred: $error"),
        ),
      );
      return null;
    }
  }

  Future<dynamic> signin(BuildContext context, mobile, password) async {
    try {
      print(userId);
      final response = await http.post(
        Uri.parse('$baseUrl/sign-in'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'mobile': mobile, 'password': password}),
      );

      // Decode the JSON response

      // Debugging the raw response
      print('Raw response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Check for success status in the API response
        if (data['status'] == 1) {
          // Map the response to CartDetailsModel
          return data;
        } else {
          // Handle the case where status is not 1
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(data['message'] ?? 'Unknown error occurred'),
            ),
          );
          return null;
        }
      } else {
        // Handle HTTP status code errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content:
                Text("Failed to fetch cart. Status: ${response.statusCode}"),
          ),
        );
        return null;
      }
    } catch (error) {
      // Handle exceptions
      print("Error fetching cart by ID: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("An error occurred: $error"),
        ),
      );
      return null;
    }
  }

  Future<JsonDartYOrders> fetchOrders(String userId) async {
    final url = "$baseUrl/user-orders";
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "user_id": userId, // Ensure this is a string
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}'); // Log the response body

    if (response.statusCode == 200) {
      return JsonDartYOrders.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load orders: ${response.body}");
    }
  }

  Future<dynamic> fetchaddress(String userIdFAdd) async {
    Map<String, dynamic> data = {"user_id": userIdFAdd};
    print(userIdFAdd);
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getAddress'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': userIdFAdd}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          return data['data'];
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception(
            'Failed to fetch product. Status: ${response.statusCode}');
      }
    } catch (error) {
      print("Error fetching product by ID: $error");
      return null;
    }
  }

  Future<Map<String, dynamic>?> store_address(dynamic parameter) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/storeAddress'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(parameter),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          return data['data'];
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception(
            'Failed to fetch product. Status: ${response.statusCode}');
      }
    } catch (error) {
      print("Error to store address: $error");
      return null;
    }
  }

  // Future<OrderResponseModel?> fetchOrders(String userId) async {
  //   const String baseUrl =
  //       "https://quantapixel.in/ecommerce/grocery_app/public/api";

  //   final response = await http.post(
  //     Uri.parse('$baseUrl/user-orders'),
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({"user_id": userId}),
  //   );

  //   if (response.statusCode == 200) {
  //     final jsonResponse = jsonDecode(response.body);
  //     if (jsonResponse['status'] == 1) {
  //       return OrderResponseModel.fromJson(jsonResponse);
  //     } else {
  //       throw Exception("API Error: ${jsonResponse['message']}");
  //     }
  //   } else {
  //     throw Exception("HTTP Error: ${response.statusCode}");
  //   }
  // }

  Future<dynamic> updatePaymenttStatus(
      context, int orderId, String paymentStatus) async {
    try {
      // API request body
      final body = jsonEncode({
        "order_id": orderId,
        "payment_status": paymentStatus,
      });

      // Sending the POST request
      final response = await http.post(
        Uri.parse('$baseUrl/updatePaymentStatus'),
        headers: {
          "Content-Type": "application/json",
        },
        body: body,
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("jsonResponse $jsonResponse");

        if (jsonResponse['status'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(jsonResponse['message'].toString()),
            ),
          );
          //   return OrderResponseModel.fromJson(jsonResponse.body);
        } else {
          throw Exception(
              'Failed to load products: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e, _) {
      print("Error fetching products: $e");
      print("Error fetching products: $_");
      throw Exception('Failed to load products');
    }
  }

  // Check if the request was successful

  // Future<dynamic> updatePaymentStatus(context, var data) async {
  //   print("jsonResponse ");
  //   print("${jsonEncode(data)}");
  //   try {
  //     final response = await http
  //         .post(Uri.parse('$baseUrl/updatePaymentStatus'), body: data);

  //     // API request body
  //     // final body = jsonEncode({
  //     //   "order_id": orderId,
  //     //   "payment_status": paymentStatus,
  //     // });

  //     if (response.statusCode == 200) {
  //       final jsonResponse = json.decode(response.body);
  //       print("jsonResponse $jsonResponse");

  //       if (jsonResponse['status'] == 1) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             backgroundColor: Colors.green,
  //             content: Text(jsonResponse['message'].toString()),
  //           ),
  //         );
  //         //   return OrderResponseModel.fromJson(jsonResponse.body);
  //       } else {
  //         throw Exception(
  //             'Failed to load products: ${jsonResponse['message']}');
  //       }
  //     } else {
  //       throw Exception('Failed to load products: ${response.statusCode}');
  //     }
  //   } catch (e, _) {
  //     print("Error fetching products: $e");
  //     print("Error fetching products: $_");
  //     throw Exception('Failed to load products');
  //   }
  // }

  Future<dynamic> updateOrderStatus(context, var data) async {
    print("jsonResponse ");
    print("${jsonEncode(data)}");
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/updateOrderStatus'), body: data);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("jsonResponse $jsonResponse");

        if (jsonResponse['status'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(jsonResponse['message'].toString()),
            ),
          );
          //   return OrderResponseModel.fromJson(jsonResponse.body);
        } else {
          throw Exception(
              'Failed to load products: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e, _) {
      print("Error fetching products: $e");
      print("Error fetching products: $_");
      throw Exception('Failed to load products');
    }
  }

  Future<Map<String, dynamic>?> fetchUserProfile(String userId) async {
    final String apiUrl = "$baseUrl/get-profile";

    // Request body
    Map<String, dynamic> body = {
      "user_id": userId,
    };

    try {
      // Send POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      // Check response status
      if (response.statusCode == 200) {
        // Decode response body
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Check API status
        if (responseData['status'] == 1) {
          return responseData['data'];
        } else {
          print("Error: ${responseData['message']}");
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
      }
    } catch (error) {
      print("An error occurred: $error");
    }
    return null; // Return null in case of failure
  }

  Future<UserDetailsModel> updateUserDetails(
      context, name, mobile, address, userId) async {
    Map<String, dynamic> data = {
      "name": name,
      "mobile": mobile,
      "address": address,
      "user_id": userId,
    };
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/edit-user'), body: data);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("jsonResponse $jsonResponse");

        if (jsonResponse['status'] == 1) {
          return UserDetailsModel.fromJson(jsonResponse);
        } else {
          throw Exception(
              'Failed to load user details: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Failed to load user details: ${response.statusCode}');
      }
    } catch (e, _) {
      print("Error fetching user details: $e, $_");
      throw Exception('Failed to load products');
    }
  }

  Future<void> submitIssue(
      String UserSubmitId, String subject, String description) async {
    Map<String, dynamic> data = {"user_id": UserSubmitId};
    final url = Uri.parse(
        'https://quantapixel.in/ecommerce/grocery_app/public/api/need-help');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // Add additional headers if required by the API
        },
        body: json.encode({
          'subject': subject,
          'description': description,
          'user_id': UserSubmitId
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle success response
        print('Issue submitted successfully: ${response.body}');
      } else {
        // Handle error response
        print(
            'Failed to submit issue: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Handle exceptions like network issues
      print('Error occurred: $e');
    }
  }

  Future<dynamic> placeOrder(Map body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/place-order'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      print('${json.encode(body)}hii');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        print(data);
        if (data['status'] == 1) {
          return data;
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception(
            'Failed to fetch product. Status: ${response.statusCode}');
      }
    } catch (error) {
      print("Error Placing Order : $error");
      return null;
    }
  }

  Future<dynamic> getBestSellings(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/best-selling'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          return data;
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception(
            'Failed to fetch product. Status: ${response.statusCode}');
      }
    } catch (error) {
      print("Error Placing Order : $error");
      return null;
    }
  }

  Future<void> submitedIssue(
      String subject, String description, String userId) async {
    final url = Uri.parse(
        'https://quantapixel.in/ecommerce/grocery_app/public/api/helps');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Success response
        print('Issue submitted successfully: ${response.body}');
      } else {
        // Handle error response
        print(
            'Failed to submit issue: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Handle exceptions like network issues
      print('Error occurred: $e');
    }
  }
}
