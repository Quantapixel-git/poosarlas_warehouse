import 'dart:convert';
import 'dart:io';
import 'package:e_commerce_grocery_application/Pages/model_category.dart/model_category.dart';
import 'package:e_commerce_grocery_application/Widgets/Categorieswidget.dart';

import 'package:http/http.dart' as http;

class CategoryApiServices {
  final String baseUrl =
      "https://quantapixel.in/ecommerce/grocery_app/public/api";
  final String accessKey = "PMAT-01JDF1ZCPKHE7PXSVT9J6YG1AZ";

  Future<void> addCategory(Map<String, String> fields, File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/add_categories'),
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
        print("Category added successfully!");
      } else {
        // Extract response body for detailed error message
        String responseBody = await response.stream.bytesToString();
        print("Failed to add category: $responseBody");
      }
    } catch (e) {
      print("An error occurred while adding the category: $e");
    }
  }

  Future<Map<String, dynamic>> updateCategoryPriority(
      int categoryId, int priorityNumber) async {
    final url = Uri.parse(
        'https://quantapixel.in/ecommerce/grocery_app/public/api/updateCategoryPriority');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'category_id': categoryId,
          'priority_number': priorityNumber,
        }),
      );

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        // Parse and return the response as a Map
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 1) {
          print('Category priority updated successfully');
          return responseData;
        } else {
          print(
              'Failed to update category priority: ${responseData['message']}');
          return responseData;
        }
      } else {
        print(
            'Failed to update category priority. Status Code: ${response.statusCode}');
        return {
          'status': 0,
          'message': 'Request failed with status: ${response.statusCode}'
        };
      }
    } catch (e) {
      print('Error updating category priority: $e');
      return {'status': 0, 'message': 'An error occurred: $e'};
    }
  }

  Future<List<ModelCategory>> fetchCategories() async {
    final response = await http.get(Uri.parse(
        'https://quantapixel.in/ecommerce/grocery_app/public/api/get_categories'));

    if (response.statusCode == 200) {
      final List categories = json.decode(response.body)['data'];
      return categories.map((data) => ModelCategory.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> deleteCategory(int categoryId, String accessKey) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/delete_category'),
        headers: {
          "Authorization": "Bearer $accessKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "category_id": categoryId,
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

  Future<http.Response?> editCategory({
    required String CategoryName,
    File? CategoryImage,
    required String CategoryId,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/edit_categories'),
      );
      request.fields['category_name'] = CategoryName;
      request.fields['category_id'] = CategoryId;
      if (CategoryImage != null && CategoryImage.path.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          CategoryImage.path,
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

  // Add headers

  Future<Map<String, dynamic>?> fetchSpecificCategory(int categoryId) async {
    try {
      final url = Uri.parse("$baseUrl/get_category");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "category_id": categoryId,
        }),
      );

      if (response.statusCode == 200) {
        print(CategoryData.categories);
        print('yessss');
        return jsonDecode(response.body);
      } else {
        print("Failed to fetch category. Status Code: ${response.statusCode}");
        print("Response: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error while fetching category: $e");
      return null;
    }
  }
}
