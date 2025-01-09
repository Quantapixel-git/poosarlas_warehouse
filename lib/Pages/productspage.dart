import 'package:e_commerce_grocery_application/Pages/detailviewpage.dart';
import 'package:e_commerce_grocery_application/Pages/model_category.dart/product_model.dart';
import 'package:e_commerce_grocery_application/Pages/models/cart_details.dart';
import 'package:e_commerce_grocery_application/Pages/models/place_order_request_model.dart';
import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Productspageuser extends StatefulWidget {
  final String categoryid;
  const Productspageuser({super.key, required this.categoryid});

  @override
  State<Productspageuser> createState() => _ProductspageuserState();
}

class _ProductspageuserState extends State<Productspageuser> {
  late Future<List<Product>> _productFuture;

  // Map to track product quantities
  Map<int, int> productQuantities = {};

  @override
  void initState() {
    super.initState();
    _productFuture = ProductService().getAllProducts();
  }

  // Function to update the quantity
  void updateQuantity(
      int productId, bool increment, BuildContext context) async {
    setState(() {
      if (increment) {
        productQuantities[productId] = (productQuantities[productId] ?? 0) + 1;
      } else {
        if (productQuantities[productId] != null &&
            productQuantities[productId]! > 1) {
          productQuantities[productId] = productQuantities[productId]! - 1;
        } else if (productQuantities[productId] == 1) {}
      }
    });

    // Call API to update cart
    final userService = UserService();
    String? userPassword = await userService.getUserId();

    await ProductService().addToCart(
      userPassword.toString(),
      productId.toString(),
      context,
      productQuantities[productId] ?? 0, // Pass updated quantity
    );
  }

  // Sort properties
  void sortProperties(String sortOption, List<Product> products) {
    if (sortOption == "Low to High Price") {
      products.sort((a, b) =>
          double.parse(a.productPrice).compareTo(double.parse(b.productPrice)));
    } else if (sortOption == "High to Low Price") {
      products.sort((a, b) =>
          double.parse(b.productPrice).compareTo(double.parse(a.productPrice)));
    }
  }

  Widget _productPage(double screenHeight, double screenWidth) {
    return FutureBuilder<List<Product>>(
      future: _productFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Failed to load products. Please try again.',
                  style: TextStyle(color: Colors.red),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _productFuture = ProductService().getAllProducts();
                    });
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final categories = snapshot.data!;
          final filteredCategories = categories
              .where((category) => widget.categoryid == category.categoryId)
              .toList();

          if (selectedSort != "Recently Added") {
            sortProperties(selectedSort, filteredCategories);
          }

          if (filteredCategories.isEmpty) {
            return const Center(
              child: Text(
                'No products available in this category.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return Align(
            alignment: Alignment.topCenter,
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.6,
              ),
              shrinkWrap: true,
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final category = filteredCategories[index];

                // Initialize quantity if not already set to 0
                productQuantities[category.id] ??= 0;

                return InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image and Details
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Detailviewpage(
                                  discount: category.productDiscount,
                                  Name: category.productName,
                                  Price: category.productPrice,
                                  description: category.productDescription,
                                  Image: category.productImageUrl,
                                  id: category.id.toString(),
                                  CategoryId: widget.categoryid,
                                ),
                              ),
                            );
                          },
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                category.productImageUrl,
                                height: screenHeight * 0.15,
                                width: screenWidth * 0.35,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: screenHeight * 0.035,
                              width: screenWidth * 0.23,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 5, 158, 18),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  // Decrease Quantity Button
                                  InkWell(
                                    onTap: () => updateQuantity(
                                        category.id, false, context),
                                    child: const Icon(
                                      Icons.remove,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  // Display Quantity
                                  Text(
                                    '${productQuantities[category.id]}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  // Increase Quantity Button
                                  InkWell(
                                    onTap: () => updateQuantity(
                                        category.id, true, context),
                                    child: const Icon(
                                      Icons.add,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          category.productName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF475269),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '₹${(double.parse(category.productPrice) - (double.parse(category.productDiscount) * double.parse(category.productPrice) / 100)).toStringAsFixed(2)}',
                          style: GoogleFonts.roboto(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(
            child: Text('No products available.'),
          );
        }
      },
    );
  }

  String selectedSort = "Low to High Price";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(10),
            height: screenHeight * 0.14,
            width: screenWidth,
            color: AppColors.mainColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Row(
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.black),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Products',
                          style: GoogleFonts.notoSerifOttomanSiyaq(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Align(
            alignment: Alignment.topRight,
            child: DropdownButton<String>(
              padding: EdgeInsets.symmetric(horizontal: 20),
              value: selectedSort,
              icon: const Icon(Icons.sort,
                  color: Color.fromARGB(255, 220, 34, 34)),
              dropdownColor: const Color.fromARGB(255, 255, 223, 17),
              items: [
                "Low to High Price",
                "High to Low Price",
                "Recently Added"
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child:
                      Text(value, style: const TextStyle(color: Colors.black)),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedSort = newValue;
                  });
                }
              },
            ),
          ),
          // Product List Section
          Expanded(child: _productPage(screenHeight, screenWidth)),
        ],
      ),
    );
  }
}
