import 'package:e_commerce_grocery_application/Pages/detailviewpage.dart';
import 'package:e_commerce_grocery_application/Pages/model_category.dart/product_model.dart';
import 'package:e_commerce_grocery_application/Pages/models/productmodel.dart';
import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Productslist extends StatefulWidget {
  const Productslist({super.key});

  @override
  State<Productslist> createState() => _ProductslistState();
}

class _ProductslistState extends State<Productslist> {
  Future<List<Product>>? _productFuture;
  List<Product> _GroceryItems = [];
  List<Product> _filteredGroceryItems = [];
  final TextEditingController _searchproductNameController =
      TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _fetchProductRecords();
    _searchproductNameController.addListener(_filterProductName);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _fetchProductRecords() async {
    try {
      final products = await ProductService().getAllProducts();
      setState(() {
        _productFuture =
            Future.value(products); // Assign products to the Future
        _GroceryItems = products;
        _filteredGroceryItems = products; // Initially both lists are the same
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  void _filterProductName() {
    final query = _searchproductNameController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredGroceryItems =
            _GroceryItems; // Show all items if query is empty
      } else {
        _filteredGroceryItems = _GroceryItems.where(
                (product) => product.productName.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchproductNameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          // Header and Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: screenHeight * 0.25,
            decoration: const BoxDecoration(
              color: AppColors.mainColor, // Gold for a premium feel
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40), // Space for status bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Poosarla's ",
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            'Warehouse',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                        onTap: () {
                          makePhoneCall('+91 9708070019');
                        },
                        child: Icon(
                          Icons.call_outlined,
                          size: 25,
                        )),
                  ],
                ),
                const SizedBox(height: 20),
                // Search Bar
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 15),
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          focusNode: _focusNode,
                          controller: _searchproductNameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search for groceries...',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
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
                              _productFuture =
                                  ProductService().getAllProducts();
                            });
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final groceryProducts = _filteredGroceryItems.isEmpty
                      ? snapshot.data!
                      : _filteredGroceryItems;
                  return Align(
                    alignment: Alignment.topCenter,
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      shrinkWrap: true,
                      itemCount: groceryProducts.length,
                      itemBuilder: (context, index) {
                        final category = groceryProducts[index];
                        return InkWell(
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
                                  CategoryId: category.categoryId.toString(),
                                ),
                              ),
                            );
                          },
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
                                // Product Image
                                Center(
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
                                const SizedBox(height: 12),
                                // Product Name
                                Row(
                                  children: [
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
                                  ],
                                ),
                                const Spacer(),
                                // Product Price
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ' ₹${(double.parse(category.productPrice) - (double.parse(category.productDiscount) * double.parse(category.productPrice) / 100)).toStringAsFixed(2)}',
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                    Icon(
                                      CupertinoIcons.cart,
                                      color: Colors.black,
                                    )
                                  ],
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
            ),
          ),
        ],
      ),
    );
  }
}
