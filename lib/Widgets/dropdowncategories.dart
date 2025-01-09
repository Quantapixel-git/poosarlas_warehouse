import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:e_commerce_grocery_application/Pages/model_category.dart/model_category.dart';
import 'package:e_commerce_grocery_application/services/category_api_services.dart';
import 'package:flutter/material.dart';

class Addproducts extends StatefulWidget {
  const Addproducts({super.key});

  @override
  State<Addproducts> createState() => _AddproductsState();
}

class _AddproductsState extends State<Addproducts> {
  ModelCategory? selectedCategory; // Holds the selected category
  List<ModelCategory> categories = []; // Replace with your category data

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    // Fetch categories from the API or other sources
    try {
      final fetchedCategories = await CategoryApiServices().fetchCategories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildDropdown(),
          // Add other widgets here
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField2<ModelCategory>(
      decoration: InputDecoration(
        labelText: 'Select Category',
        border: OutlineInputBorder(),
      ),
      isExpanded: true,
      value: selectedCategory,
      items: categories.map((category) {
        return DropdownMenuItem<ModelCategory>(
          value: category,
          child: Text(category.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCategory = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select a category';
        }
        return null;
      },
    );
  }
}
