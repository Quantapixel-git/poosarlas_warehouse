import 'package:e_commerce_grocery_application/Pages/model_category.dart/model_category.dart';
import 'package:e_commerce_grocery_application/services/category_api_services.dart';
import 'package:flutter/material.dart';

class testProduct extends StatefulWidget {
  final String id;

  const testProduct({Key? key, required this.id}) : super(key: key);

  @override
  State<testProduct> createState() => _EditProductState();
}

class _EditProductState extends State<testProduct> {
  final CategoryApiServices _categoryService = CategoryApiServices();

  // Selected Category ID
  int? selectedCategoryId;

  // List of Categories
  List<ModelCategory> categories = [];
  bool _isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final fetchedCategories = await _categoryService.fetchCategories();
      setState(() {
        categories = fetchedCategories;
        _isLoadingCategories = false;
      });
    } catch (e) {
      print("Error fetching categories: $e");
      setState(() {
        _isLoadingCategories = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching categories: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 235, 235, 41),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Dropdown
            _isLoadingCategories
                ? Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<int>(
                    value: selectedCategoryId,
                    items: categories
                        .map((category) => DropdownMenuItem<int>(
                              value: category.id,
                              child: Text(category.name),
                            ))
                        .toList(),
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedCategoryId = value!;
                      });
                    },
                  ),
            const SizedBox(height: 20),
            // Other fields (e.g., product name, description, etc.)
            // ...
            ElevatedButton(
              onPressed: () {
                print('Selected Category ID: $selectedCategoryId');
              },
              child: const Text('Update Product'),
            ),
          ],
        ),
      ),
    );
  }
}
