import 'dart:convert';
import 'package:e_commerce_grocery_application/Pages/cartpage.dart';
import 'package:e_commerce_grocery_application/Pages/detailviewpage.dart';
// import 'package:e_commerce_grocery_application/Pages/models/cart_details.dart';
import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ProductId {
  int? id;
  int? categoryId; // Change to int?
  String? productName;
  double? productPrice;
  double? productDiscount;
  int? stock;
  int? deliveryCharge;
  String? productShortDescription;
  String? productDescription;
  int? cartQuantity;
  String? productImageUrl;
  String? additionalImage1Url;
  String? additionalImage2Url;

  ProductId({
    this.id,
    this.categoryId,
    this.productName,
    this.productPrice,
    this.productDiscount,
    this.stock,
    this.deliveryCharge,
    this.productShortDescription,
    this.productDescription,
    this.cartQuantity,
    this.productImageUrl,
    this.additionalImage1Url,
    this.additionalImage2Url,
  });

  ProductId.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id'].toString());
    categoryId = json['category_id'] is int
        ? json['category_id']
        : int.tryParse(json['category_id'].toString());
    productName = json['product_name'];
    productPrice = double.tryParse(json['product_price'].toString()) ?? 0.0;
    productDiscount =
        double.tryParse(json['product_discount'].toString()) ?? 0.0;
    stock = json['stock'] is int
        ? json['stock']
        : int.tryParse(json['stock'].toString());
    deliveryCharge = json['delivery_charge'] is int
        ? json['delivery_charge']
        : int.tryParse(json['delivery_charge'].toString());
    productShortDescription = json['product_short_description'];
    productDescription = json['product_description'];
    cartQuantity = json['cart_quantity'] is int
        ? json['cart_quantity']
        : int.tryParse(json['cart_quantity'].toString());
    productImageUrl =
        json['product_image_url'] ?? 'https://via.placeholder.com/150';
    additionalImage1Url = json['additional_image_1_url'];
    additionalImage2Url = json['additional_image_2_url'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'product_name': productName,
      'product_price': productPrice,
      'product_discount': productDiscount,
      'stock': stock,
      'delivery_charge': deliveryCharge,
      'product_short_description': productShortDescription,
      'product_description': productDescription,
      'cart_quantity': cartQuantity,
      'product_image_url': productImageUrl,
      'additional_image_1_url': additionalImage1Url,
      'additional_image_2_url': additionalImage2Url,
    };
  }
}

class Productspageuser extends StatefulWidget {
  final String categoryId;

  const Productspageuser({Key? key, required this.categoryId})
      : super(key: key);

  @override
  _ProductspageuserState createState() => _ProductspageuserState();
}

class _ProductspageuserState extends State<Productspageuser> {
  late Future<List<ProductId>> _productFuture;
  String _filterName = "No Filter";

  @override
  void initState() {
    super.initState();
    _productFuture = fetchProducts();
  }

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

        // Update filter name based on the filter value
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

  Future<List<ProductId>> fetchProducts() async {
    final userService = UserService();
    String? userpassword = await userService.getUserId();
    print('User  ID: $userpassword'); // Log the user ID

    if (userpassword == null) {
      throw Exception('User  ID is null');
    }

    final response = await http.post(
      Uri.parse(
          'https://quantapixel.in/ecommerce/grocery_app/public/api/getAllProductsByUserId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userpassword}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      print('Response: $jsonResponse'); // Log the response

      if (jsonResponse['status'] == 1) {
        final List<dynamic> data = jsonResponse['data'];
        final products = data.map((e) => ProductId.fromJson(e)).toList();

        // Fetch filter and apply sorting
        // Fetch filter and apply sorting
        final filter = await fetchFilter();
        if (filter == 1) {
          products.sort(
              (a, b) => (a.productPrice ?? 0).compareTo(b.productPrice ?? 0));
        } else if (filter == 2) {
          products.sort(
              (a, b) => (b.productPrice ?? 0).compareTo(a.productPrice ?? 0));
        }

        return products;
      } else {
        throw Exception(jsonResponse['message'] ?? 'Failed to fetch products');
      }
    } else {
      print('Error: ${response.statusCode} - ${response.body}'); // Log error
      throw Exception(
          'Failed to connect to the server: ${response.statusCode}');
    }
  }

  Map<int, int> productQuantities = {};

  void updateQuantity(
      int productId, bool increment, BuildContext context) async {
    // setState(() {
      // Update cartQuantity for the specific product
      final product = _productFuture.then((products) => products.firstWhere(
          (prod) => prod.id == productId)); // Get the product object
      product.then((prod) {
        if (increment) {
          // Increase the quantity if possible
          if (prod.cartQuantity != null) {
            prod.cartQuantity = prod.cartQuantity! + 1;
            setState(() {
              _productFuture;
            }); // Increment quantity
          } else {
            prod.cartQuantity = 1;
            // Navigator.pop(context); // Initialize if it was null
          }
        } else {
          if (prod.cartQuantity != null && prod.cartQuantity! > 1) {
            prod.cartQuantity = prod.cartQuantity! - 1;
            setState(() {
              _productFuture;
            }); // Decrease quantity
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.orange,
                content: Text('You can Remove an Item from Cart Only!'),
              ),
            );
          }
        }

        // Call the API to update the cart
        final userService = UserService();
        userService.getUserId().then((userpassword) async {
          if (userpassword != null) {
            await ProductService().addToCart(
              userpassword.toString(),
              productId.toString(),
              context,
              prod.cartQuantity ?? 0, // Use the updated quantity
              openCartPage: false,
            );
            // Navigator.pop(context);
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) =>
            //         Productspageuser(categoryId: widget.categoryId),
            //   ),
            // );
          }
        });
      });
    // });
  }

  Future<void> _quantityUpdateApi(
      {required int quantity, required int cartId}) async {
    await ProductService().cartQuantityUpdate(context, cartId, quantity);
    setState(() {
      _productFuture = fetchProducts(); // Refresh products after update
    });
  }

  Widget _productPage(double screenHeight, double screenWidth) {
    return FutureBuilder<List<ProductId>>(
      future: _productFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return const Center(
            child: Text(
              'Failed to load products. Please try again.',
              style: TextStyle(color: Colors.red),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final categories = snapshot.data!;
          final filteredCategories = categories
              .where((product) =>
                  product.categoryId == int.tryParse(widget.categoryId))
              .toList();

          if (filteredCategories.isEmpty) {
            return const Center(
              child: Text(
                'No products available in this category.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.6,
            ),
            itemCount: filteredCategories.length,
            itemBuilder: (context, index) {
              final product = filteredCategories[index];
              return InkWell(
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
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Detailviewpage(
                                  discount: (product.productDiscount ?? 0)
                                      .toString(), // Convert to String
                                  Name: product.productName ?? 'Unknown',
                                  Price: (product.productPrice ?? 0)
                                      .toString(), // Convert to String
                                  Image: product.productImageUrl ?? '',
                                  id: product.id.toString(),
                                  CategoryId: widget.categoryId,
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              product.productImageUrl ??
                                  'https://via.placeholder.com/150',
                              height: screenHeight * 0.15,
                              width: screenWidth * 0.35,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // Decrease Quantity Button
                                InkWell(
                                  onTap: () => updateQuantity(
                                      product.id!, false, context),
                                  child: const Icon(
                                    Icons.remove,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                // Display Quantity
                                Text(
                                  '${product.cartQuantity}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                // Increase Quantity Button
                                InkWell(
                                  onTap: () => updateQuantity(
                                      product.id!, true, context),
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
                      const SizedBox(height: 12),
                      Text(
                        product.productName ?? 'Unknown Product',
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
                        '₹${(double.parse(product.productDiscount.toString())).toStringAsFixed(2)}',
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
          );
        } else {
          return const Center(
            child: Text('No products available.'),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.black),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Text(
                      'Products',
                      style: GoogleFonts.notoSerifOttomanSiyaq(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Cartpage()));
                        },
                        child: Icon(CupertinoIcons.cart_fill))
                  ],
                ),
                //  _filterContainer()
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Expanded(child: _productPage(screenHeight, screenWidth)),
        ],
      ),
    );
  }
}
