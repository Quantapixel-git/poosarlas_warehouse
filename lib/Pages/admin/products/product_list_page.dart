import 'dart:convert';

import 'package:e_commerce_grocery_application/Pages/admin/products/add_product_page.dart';
import 'package:e_commerce_grocery_application/Pages/admin/products/edit_product_page.dart';
import 'package:e_commerce_grocery_application/Pages/model_category.dart/product_model.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  Future<List<Product>>? _productsFuture;
  String _filterName = "No Filter";
  String _selectedFilter = '1'; // Default filter: Low to High

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService().getAllProducts();
    fetchFilter().then((filterValue) {
      setState(() {
        _selectedFilter = filterValue.toString();
      });
    });
  }

  // Function to refresh product list
  void _refreshCategories() {
    setState(() {
      _productsFuture = ProductService().getAllProducts();
    });
  }

  // Function to update the filter via POST API
  Future<void> _updateFilter(String filter) async {
    const String apiUrl =
        "https://quantapixel.in/ecommerce/grocery_app/public/api/updateFilter";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": "1", "filter": filter}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Filter updated successfully!"),
          ));
        } else {
          print("Failed to update filter: ${data['message']}");
        }
      } else {
        print("Error updating filter: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // Function to fetch the saved filter value from API
  Future<int> fetchFilter() async {
    final response = await http.get(
      Uri.parse(
          'https://quantapixel.in/ecommerce/grocery_app/public/api/getFilter'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      if (jsonResponse['status'] == 1) {
        final filterValue = int.parse(jsonResponse['data'][0]['filter']);

        setState(() {
          if (filterValue == 1) {
            _filterName = "Price: Low to High";
          } else if (filterValue == 2) {
            _filterName = "Price: High to Low";
          } else {
            _filterName = "Recently Added";
          }
        });

        return filterValue;
      } else {
        throw Exception(jsonResponse['message'] ?? 'Failed to fetch filter');
      }
    } else {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate a network call
    setState(() {
      _refreshCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Header Section
          Container(
            height: screenHeight * 0.22,
            width: screenWidth,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 237, 36),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.navigate_before, size: 35),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Text(
                        'Edit Products',
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50.0),
                    child: Text(
                      'Admin Panel',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButton<String>(
                        value: _selectedFilter,
                        items: [
                          DropdownMenuItem(
                              value: '1', child: Text("Price: Low to High")),
                          DropdownMenuItem(
                              value: '2', child: Text("Price: High to Low")),
                          DropdownMenuItem(
                              value: '3', child: Text("Recently Added")),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedFilter = value;
                              _filterName = value == '1'
                                  ? "Price: Low to High"
                                  : value == '2'
                                      ? "Price: High to Low"
                                      : "Recently Added";
                            });
                            _updateFilter(value);
                            _refreshCategories();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Scroll Down to refresh the Products',
            style: GoogleFonts.poppins(
              color: const Color.fromARGB(179, 0, 0, 0),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final categories = snapshot.data!;
                  return RefreshIndicator(
                    onRefresh: _refreshData,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(15),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                category.productImageUrl,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              category.productName,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF212121),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    CupertinoIcons.pencil_circle,
                                    color: Color(0xFF1A73E8),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditProductPage(
                                            id: category.id.toString()),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    CupertinoIcons.delete_solid,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    bool? confirmDelete = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Delete Product"),
                                        content: Text(
                                            "Are you sure you want to delete ${category.productName}?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text("Delete"),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirmDelete == true) {
                                      await ProductService().deleteProduct(
                                        category.id,
                                        "PMAT-01JDF1ZCPKHE7PXSVT9J6YG1AZ",
                                      );
                                      _refreshCategories();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const Center(
                  child: Text('No categories found'),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height * 0.1,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductPage()),
              ).then((val) {
                _productsFuture = ProductService().getAllProducts();
              });
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromARGB(255, 255, 237, 36),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Add a Product",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.merriweather(
                      color: Colors.black,
                      wordSpacing: 6,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(CupertinoIcons.add_circled_solid),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
