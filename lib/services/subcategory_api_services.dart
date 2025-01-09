import 'dart:convert';
import 'dart:io';

import 'package:e_commerce_grocery_application/Pages/model_category.dart/model_subcategory.dart';
import 'package:http/http.dart' as http;

class SubcategoryApiServices {
  final String baseUrl =
      "https://quantapixel.in/ecommerce/grocery_app/public/api";
  final String accessKey = "PMAT-01JDF1ZCPKHE7PXSVT9J6YG1AZ";
  Future<List<ModelSubCategory>> fetchsubCategories() async {
    final response = await http.get(Uri.parse(
        'https://quantapixel.in/ecommerce/grocery_app/public/api/get_sub_categories'));

    if (response.statusCode == 200) {
      final List categories = json.decode(response.body)['data'];
      return categories.map((data) => ModelSubCategory.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> deletesubCategory(int categoryId, String accessKey) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://quantapixel.in/ecommerce/grocery_app/public/api//delete_sub_category'),
        headers: {
          "Authorization": "Bearer $accessKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "category_id": categoryId,
        }),
      );

      if (response.statusCode == 200) {
        print("SubCategory deleted successfully!");
      } else {
        print("Failed to delete Subcategory: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Error during deletion: $e");
    }
  }

  Future<void> editsubCategory(
      Map<String, String> fields, File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$base64Url/edit_sub_categories'),
      );

      // Add fields (e.g., category name)
      fields.forEach((key, value) {
        request.fields[key] = value;
      });

      // Add the image file
      request.files.add(await http.MultipartFile.fromPath(
        'image', // Key expected by your API for the image
        imageFile.path,
      ));

      // Add headers
      request.headers.addAll({
        "Authorization": "Bearer $accessKey",
        "Content-Type": "multipart/form-data",
      });

      // Send the request
      var response = await request.send();

      // Check the response
      if (response.statusCode == 201) {
        print("Category Edited successfully!");
      } else {
        // Extract response body for detailed error message
        String responseBody = await response.stream.bytesToString();
        print("Failed to edit category: $responseBody");
      }
    } catch (e) {
      print("An error occurred while editing the category: $e");
    }
  }

  Future<void> addSubCategory(
      Map<String, String> fields, File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/add_sub_categories'),
      );

      // Add fields (e.g., category name)
      fields.forEach((key, value) {
        request.fields[key] = value;
      });

      // Add the image file
      request.files.add(await http.MultipartFile.fromPath(
        'image', // Key expected by your API for the image
        imageFile.path,
      ));

      // Add headers
      request.headers.addAll({
        "Authorization": "Bearer $accessKey",
        "Content-Type": "multipart/form-data",
      });

      // Send the request
      var response = await request.send();

      // Check the response
      if (response.statusCode == 201) {
        print("SubCategory added successfully!");
      } else {
        // Extract response body for detailed error message
        String responseBody = await response.stream.bytesToString();
        print("Failed to add Subcategory: $responseBody");
      }
    } catch (e) {
      print("An error occurred while adding the Subcategory: $e");
    }
  }
}
