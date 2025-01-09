import 'package:e_commerce_grocery_application/Pages/admin/products/add_product_page.dart';
import 'package:e_commerce_grocery_application/Pages/admin/products/edit_product_page.dart';
import 'package:e_commerce_grocery_application/Pages/model_category.dart/product_model.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  Future<List<Product>>? _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService().getAllProducts();
  }

  void _refreshCategories() {
    setState(() {
      _productsFuture = ProductService().getAllProducts();
    });
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
            height: screenHeight * 0.2,
            width: screenWidth,
            decoration: const BoxDecoration(
              color: const Color.fromARGB(255, 255, 237, 36),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.navigate_before, size: 35),
                        onPressed: () {
                          Navigator.of(context)
                              .pop(); // Navigate back to the previous screen
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
                  const SizedBox(height: 4),
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
          SizedBox(
            height: 10,
          ),

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
                                // InkWell(
                                //   onTap: () async {
                                //     bool? confirmDelete = await showDialog(
                                //       context: context,
                                //       builder: (context) => AlertDialog(
                                //         title: const Text("Update Product"),
                                //         content: Text(
                                //             "Are you sure you want to inactive ${category.productName} Product?"),
                                //         actions: [
                                //           TextButton(
                                //             onPressed: () =>
                                //                 Navigator.pop(context, false),
                                //             child: const Text("No"),
                                //           ),

                                //           TextButton(
                                //             onPressed: () =>
                                //                 Navigator.pop(context, true),
                                //             child: const Text("Yes"),

                                //           ),
                                //         ],
                                //       ),
                                //     );

                                //     if (confirmDelete == true) {
                                //       await ProductService().updateStatus(
                                //           category.id,
                                //           category.isActive
                                //               ? "INACTIVE"
                                //               : "ACTIVE");

                                //       _refreshCategories();
                                //     }
                                //   },
                                //   child: Container(
                                //     height: 30,
                                //     decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(10),
                                //         border: Border.all(
                                //             width: 1, color: Colors.green)),
                                //     alignment: Alignment.center,
                                //     child: Padding(
                                //       padding: const EdgeInsets.symmetric(
                                //           horizontal: 5.0),
                                //       child: Text(
                                //         'active',
                                //         //category.isActive?

                                //         //"Active":'In Active',
                                //         style: TextStyle(
                                //             color: Colors.black, fontSize: 12),
                                //       ),
                                //     ),
                                //   ),
                                // ),
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

      // Floating Add Button
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
