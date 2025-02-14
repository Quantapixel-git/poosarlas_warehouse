import 'package:e_commerce_grocery_application/Pages/bottomnavbar.dart';
import 'package:e_commerce_grocery_application/Pages/cartpage.dart';
import 'package:e_commerce_grocery_application/Pages/listbestseling.dart';
import 'package:e_commerce_grocery_application/Pages/similarproducts.dart';

import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Detailviewpage extends StatefulWidget {
  final String Name, Price, Image;
  String id, CategoryId, discount;

  Detailviewpage(
      {super.key,
      required this.Name,
      required this.Price,
      // required this.description,
      required this.Image,
      required this.id,
      required this.CategoryId,
      required this.discount});

  @override
  State<Detailviewpage> createState() => _DetailviewpageState();
}

class _DetailviewpageState extends State<Detailviewpage> {
  Map<String, dynamic> productDetails = {};
  bool isLoading = true;
  bool _isExpanded = false;

  @override
  void initState() {
    _getProductDetails();
    super.initState();
  }

  void _getProductDetails() async {
    productDetails =
        (await ProductService().fetchProductById(widget.id.toString()))!;
    setState(() {
      isLoading = false;
    });
    print(productDetails);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: screenHeight * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                              size: 22,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Bottomnavbar(),
                                ),
                              );
                            },
                            child: Icon(CupertinoIcons.house_fill),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 50.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Cartpage(),
                                  ),
                                );
                              },
                              child: Icon(CupertinoIcons.cart_fill),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        height: screenHeight * 0.30,
                        child: Image.network(widget.Image),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 1,
                        blurRadius: 2,
                        color: const Color.fromARGB(255, 244, 33, 33),
                      ),
                    ],
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(55),
                        topRight: Radius.circular(55)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: screenHeight * 0.4,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.Name,
                                        style: GoogleFonts.albertSans(
                                          color: Colors.black,
                                          wordSpacing: 6,
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth *
                                              0.06, // Adjusted font size
                                        ),
                                        overflow: TextOverflow
                                            .ellipsis, // Prevent overflow
                                      ),
                                    ),
                                    Text(
                                      ' ₹${widget.discount}', //(double.parse(widget.Price) - (double.parse(widget.discount) * double.parse(widget.Price) / 100)).toStringAsFixed(2)
                                      style: GoogleFonts.spectral(
                                        color: const Color.fromARGB(
                                            255, 229, 18, 18),
                                        wordSpacing: 6,
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth *
                                            0.08, // Adjusted font size
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    children: [
                                      LayoutBuilder(
                                          builder: (context, constraints) {
                                        // Create a TextPainter to calculate the truncated text
                                        final textPainter = TextPainter(
                                          text: TextSpan(
                                              // text: widget.description,
                                              style: GoogleFonts.exo(
                                                color: Colors.black,
                                                wordSpacing: 6,
                                                fontWeight: FontWeight.w500,
                                                fontSize: screenWidth * 0.04,
                                              )),
                                          maxLines: 2,
                                          textDirection: TextDirection.ltr,
                                        )..layout(
                                            maxWidth: constraints.maxWidth);

                                        // Check if text overflows the 3-line limit
                                        bool isOverflowing =
                                            textPainter.didExceedMaxLines;

                                        // Generate the truncated text with "Show More"
                                        // String truncatedText =
                                            // widget.description;
                                        if (isOverflowing && !_isExpanded) {
                                          // Determine visible text within 3 lines
                                          final endIndex = textPainter
                                              .getPositionForOffset(
                                                Offset(constraints.maxWidth,
                                                    textPainter.height),
                                              )
                                              .offset;

                                          // truncatedText = widget.description
                                              // .substring(0, endIndex)
                                              // .trim();
                                          // truncatedText += "… ";
                                        }

                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isExpanded =
                                                  !_isExpanded; // Toggle the expanded state
                                            });
                                          },
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                // TextSpan(
                                                //   text: _isExpanded
                                                //       // ? widget.description
                                                //       // : truncatedText, // Full or truncated text
                                                //   style: GoogleFonts.exo(
                                                //     color: Colors.black,
                                                //     wordSpacing: 6,
                                                //     fontWeight: FontWeight.w500,
                                                //     fontSize:
                                                //         screenWidth * 0.04,
                                                //   ),
                                                // ),
                                                if (!_isExpanded || _isExpanded)
                                                  TextSpan(
                                                    text: _isExpanded
                                                        ? " Show Less"
                                                        : " Show More",
                                                    style: GoogleFonts.exo(
                                                      color: Colors.black,
                                                      wordSpacing: 6,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize:
                                                          screenWidth * 0.04,
                                                    ).copyWith(
                                                        color: Colors.blue),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                      })
                                    ],
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              double.parse(widget.discount) == 0
                                  ? Container()
                                  : Center(
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        width: screenWidth * 0.6,
                                        margin: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: Colors.amberAccent,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                  spreadRadius: 1,
                                                  blurRadius: 1,
                                                  color: const Color.fromARGB(
                                                      255, 193, 162, 162))
                                            ]),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              // color:
                                              //     const Color.fromARGB(31, 255, 44, 44),
                                              height: screenHeight * 0.05,
                                              child: Center(
                                                child: Text(
                                                  "Special Offer:",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    wordSpacing: 6,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: screenWidth *
                                                        0.04, // Adjusted font size
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              // color: const Color.fromARGB(
                                              //     255, 230, 232, 132),
                                              height: screenHeight * 0.05,
                                              child: Center(
                                                child: Text(
                                                  "${((((double.parse(widget.Price)) - (double.parse(widget.discount))) / (double.parse(widget.Price))) * 100).toStringAsFixed(0)}% OFF",
                                                  style: GoogleFonts.exo(
                                                    color: const Color.fromARGB(
                                                        255, 44, 135, 42),
                                                    wordSpacing: 6,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: screenWidth *
                                                        0.04, // Adjusted font size
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              SizedBox(height: screenHeight * 0.01),
                              Container(
                                color: const Color.fromARGB(77, 125, 125, 125),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Similar Products',
                                            style: GoogleFonts.exo(
                                              color: Colors.black,
                                              wordSpacing: 6,
                                              fontWeight: FontWeight.bold,
                                              fontSize: screenWidth *
                                                  0.06, // Adjusted font size
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Similarproducts(
                                        CategoryId:
                                            widget.CategoryId.toString())
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: isLoading
          ? SizedBox()
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    // Create a new CartItem
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  ' ₹${(double.parse(widget.discount)).toStringAsFixed(2)}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: screenWidth *
                                        0.06, // Adjusted font size
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  ' ₹${double.parse(widget.Price)} MRP',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.black,
                                    fontSize: screenWidth *
                                        0.04, // Adjusted font size
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Inclusive of all Taxes',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    screenWidth * 0.035, // Adjusted font size
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () async {
                            final userService =
                                UserService(); // Use the singleton instance

                            String? userpassword =
                                await userService.getUserId();
                            print(
                                '$userpassword'); // Correctly access the instance method

                            await ProductService().addToCart(
                                userpassword.toString(),
                                widget.id.toString(),
                                context,
                                1);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color.fromARGB(255, 255, 237, 36),
                            ),
                            height: screenHeight * 0.07,
                            width: screenWidth * 0.3,
                            child: Center(
                              child: Text(
                                "Add to Cart",
                                style: GoogleFonts.exo(
                                  color: Colors.black,
                                  wordSpacing: 6,
                                  fontWeight: FontWeight.w600,
                                  fontSize:
                                      screenWidth * 0.04, // Adjusted font size
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              height: screenHeight * 0.085,
              width: screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
    );
  }
}
