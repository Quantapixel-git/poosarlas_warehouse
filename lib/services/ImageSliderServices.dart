import 'dart:convert';
import 'dart:io';
import 'package:e_commerce_grocery_application/Pages/models/ImageSliderModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Imagesliderservices {
  final String baseUrl =
      "https://quantapixel.in/ecommerce/grocery_app/public/api";
  // final String accessKey = "PMAT-01JDF1ZCPKHE7PXSVT9J6YG1AZ";

  Future<List<Banners>> fetchBanners() async {
    final response = await http.get(Uri.parse(
        'https://quantapixel.in/ecommerce/grocery_app/public/api/getAllBanners'));

    if (response.statusCode == 200) {
      final List banners = json.decode(response.body)['data'];
      return banners.map((data) => Banners.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> deleteBanner(int BannerId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/deleteBanner'),
        headers: {
          // "Authorization": "Bearer $accessKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "id": BannerId,
        }),
      );

      if (response.statusCode == 200) {
        print("Banner deleted successfully!");
      } else {
        print("Failed to delete Banner: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Error during deletion: $e");
    }
  }
}
