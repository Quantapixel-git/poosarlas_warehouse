import 'package:e_commerce_grocery_application/Pages/detailviewpage.dart';
import 'package:e_commerce_grocery_application/Pages/model_category.dart/product_model.dart';
import 'package:e_commerce_grocery_application/Pages/productspage.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Similarproducts extends StatefulWidget {
  String CategoryId;
  Similarproducts({super.key, required this.CategoryId});

  @override
  State<Similarproducts> createState() => _SimilarproductsState();
}

class _SimilarproductsState extends State<Similarproducts> {
  late Future<List<Product>> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = ProductService().getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: MediaQuery.of(context).size.height * 0.15,
        child: FutureBuilder<List<Product>>(
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
                  .where((category) => widget.CategoryId == category.categoryId)
                  .toList();

              if (filteredCategories.isEmpty) {
                return const Center(
                  child: Text(
                    'No products available in this category.',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: screenHeight * 0.15,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      final category = filteredCategories[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Detailviewpage(
                                  discount: category.productDiscount,
                                  Name: category.productName,
                                  Price: category.productPrice,
                                  // description: category.productDescription,
                                  Image: category.productImageUrl,
                                  id: category.id.toString(),
                                  CategoryId: widget.CategoryId),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  category.productImageUrl,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  category.productName,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF475269)),
                                ),
                              ),
                              Text(
                                ' ₹${(double.parse(category.productDiscount)).toStringAsFixed(2)}',
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text('No products available.'),
              );
            }
          },
        ));
  }
}
