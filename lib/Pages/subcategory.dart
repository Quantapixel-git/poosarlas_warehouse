import 'package:e_commerce_grocery_application/Widgets/Categorieswidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Subcategory extends StatefulWidget {
  const Subcategory({super.key});

  @override
  State<Subcategory> createState() => _SubcategoryState();
}

class _SubcategoryState extends State<Subcategory> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: screenHeight * 0.15,
            width: screenWidth,
            color: const Color.fromARGB(255, 235, 235, 41),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Category Page',
                          style: GoogleFonts.notoSerifOttomanSiyaq(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Explore the Delicious!',
                          style: GoogleFonts.exo(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      CupertinoIcons.heart_circle,
                      size: 40,
                    )
                  ],
                ),
              ],
            ),
          ),
          // Header Row for 'Categories' and 'See All'

          SizedBox(
              height: screenHeight * 0.02), // Space between header and grid

          // Grid of Categories
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10, // Space between columns
                mainAxisSpacing: 10, // Space between rows
                childAspectRatio: 0.8, // Aspect ratio for each card
              ),
              itemCount: CategoryData.categories.length,
              itemBuilder: (context, index) {
                final category = CategoryData.categories[index];

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // No shadow here
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Category Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          category.Image,
                          height: screenHeight * 0.12,
                          width: screenWidth * 0.16,
                          fit: BoxFit
                              .cover, // Makes the image cover the container
                        ),
                      ),
                      SizedBox(height: 8), // Space between image and text
                      // Category Name
                      Text(
                        category.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF475269),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
