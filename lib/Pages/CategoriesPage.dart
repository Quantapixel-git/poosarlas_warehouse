// import 'package:e_commerce_grocery_application/Pages/model_category.dart/model_category.dart';
// import 'package:e_commerce_grocery_application/Pages/productspage.dart';
// import 'package:e_commerce_grocery_application/Widgets/Categorieswidget.dart';
// import 'package:e_commerce_grocery_application/services/category_api_services.dart';
// import 'package:flutter/material.dart';

// class CategoryPage extends StatefulWidget {
//   @override
//   _CategoryPageState createState() => _CategoryPageState();
// }

// class _CategoryPageState extends State<CategoryPage> {
//   List<ModelCategory> categories = []; // Cached categories data
//   bool isLoading = true; // Loading state to show a spinner while fetching data

//   @override
//   void initState() {
//     super.initState();
//     _fetchCategories(); // Fetch categories on initialization
//   }

//   // Fetch categories from the API and cache them
//   Future<void> _fetchCategories() async {
//     try {
//       // Fetch categories from API
//       var fetchedCategories = await CategoryApiServices().fetchCategories();
//       setState(() {
//         categories = fetchedCategories; // Store fetched data
//         isLoading = false; // Set loading to false once data is fetched
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false; // Stop loading if there's an error
//       });
//       // Handle error (you can show an error message if needed)
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : categories.isEmpty
//               ? const Center(
//                   child: Text(
//                     'No categories available.',
//                     style: TextStyle(color: Colors.black54),
//                   ),
//                 )
//               : GridView.builder(
//                   padding: EdgeInsets.zero,
//                   physics: const NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: screenWidth > 600 ? 4 : 3,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 15,
//                     childAspectRatio: screenWidth > 600 ? 5 / 6 : 6 / 6,
//                   ),
//                   itemCount: categories.length > 12 ? 12 : categories.length,
//                   itemBuilder: (context, index) {
//                     final category = categories[index];

//                     return InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => Productspageuser(
//                                 categoryid: category.id.toString()),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         margin: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 10),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: category.imageUrl.isNotEmpty
//                                   ? Image.network(
//                                       category.imageUrl,
//                                       height: screenHeight * 0.07,
//                                       width: screenWidth * 0.12,
//                                       fit: BoxFit.cover,
//                                       errorBuilder:
//                                           (context, error, stackTrace) {
//                                         return const Icon(
//                                           Icons.error,
//                                           size: 50,
//                                           color: Colors.red,
//                                         );
//                                       },
//                                     )
//                                   : const Icon(
//                                       Icons.image_not_supported,
//                                       size: 50,
//                                       color: Colors.grey,
//                                     ),
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Text(
//                               category.name,
//                               style: const TextStyle(
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w800,
//                                 color: Color(0xFF475269),
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }
