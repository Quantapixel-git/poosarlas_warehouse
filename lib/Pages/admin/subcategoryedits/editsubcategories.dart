// import 'dart:io';

// import 'package:e_commerce_grocery_application/Pages/AuthPages/AdminPages.dart/subcategoryedits/addsubcategory.dart';
// import 'package:e_commerce_grocery_application/Pages/model_category.dart/model_subcategory.dart';
// import 'package:e_commerce_grocery_application/Widgets/Categorieswidget.dart';
// import 'package:e_commerce_grocery_application/services/subcategory_api_services.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';

// class Editsubcategories extends StatefulWidget {
//   const Editsubcategories({super.key});

//   @override
//   State<Editsubcategories> createState() => _EditsubcategoriesState();
// }

// class _EditsubcategoriesState extends State<Editsubcategories> {
//   bool _isloading = false;
//   Future<List<ModelSubCategory>>? _categoriesFuture;
//   @override
//   void initState() {
//     super.initState();
//     _categoriesFuture = SubcategoryApiServices().fetchsubCategories();
//   }

//   void _refreshCategories() {
//     setState(() {
//       _categoriesFuture = SubcategoryApiServices().fetchsubCategories();
//     });
//   }

//   final ImagePicker _picker = ImagePicker();
//   File? SelectedImage;

//   Future getImage() async {
//     final image = await _picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       SelectedImage = File(image.path);
//       setState(() {});
//     } else {
//       // Handle the case where no image is selected
//       ('No image selected');
//     }
//   }

//   TextEditingController categorynamecontroller = new TextEditingController();
//   File? imageFile;
//   Future EditCategoryDetails(String id) => showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//             backgroundColor: Colors.yellow,
//             content: SingleChildScrollView(
//               child: Container(
//                 color: Colors.yellow,
//                 child: Column(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Icon(
//                         Icons.cancel,
//                         size: MediaQuery.of(context).size.height * 0.04,
//                       ),
//                     ),
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.03,
//                     ),
//                     Text(
//                       'Edit Category',
//                       style: GoogleFonts.notoSerifOttomanSiyaq(
//                           fontSize: 24, fontWeight: FontWeight.w800),
//                     ),
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.03,
//                     ),
//                     SelectedImage == null
//                         ? GestureDetector(
//                             onTap: () {
//                               getImage();
//                             },
//                             child: Container(
//                               height: 155,
//                               width: 155,
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   border: Border.all(
//                                       color: const Color.fromARGB(
//                                           255, 131, 131, 131),
//                                       width: 5)),
//                               child: Column(
//                                 children: [
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Icon(
//                                     Icons.camera_alt_outlined,
//                                     color: const Color.fromARGB(
//                                         255, 106, 106, 106),
//                                     size: 80,
//                                   ),
//                                   Text(
//                                     'Click to Add Image',
//                                     style: TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.grey),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                         : Material(
//                             elevation: 4.0,
//                             borderRadius: BorderRadius.circular(20),
//                             child: GestureDetector(
//                               onTap: () {
//                                 SelectedImage = null;
//                                 getImage();
//                               },
//                               child: Container(
//                                 height: 155,
//                                 width: 155,
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     border: Border.all(
//                                         color: const Color.fromARGB(
//                                             255, 131, 131, 131),
//                                         width: 5)),
//                                 child: Image.file(
//                                   SelectedImage!,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             )),
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.03,
//                     ),
//                     Container(
//                       height: 60,
//                       margin: EdgeInsets.only(right: 10, left: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 20),
//                         child: TextField(
//                           controller: categorynamecontroller,
//                           style: TextStyle(
//                               fontSize: 20, fontWeight: FontWeight.w500),
//                           decoration: InputDecoration(
//                               border: InputBorder.none,
//                               hintText: 'Category Name',
//                               hintStyle: TextStyle(fontSize: 20),
//                               labelText: 'Enter Category Name',
//                               labelStyle: TextStyle(fontSize: 20)),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.03,
//                     ),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 20),
//                       width: MediaQuery.of(context).size.width * 0.7,
//                       child: Center(
//                         child: InkWell(
//                           onTap: () async {
//                             String productName =
//                                 categorynamecontroller.text.trim();

//                             setState(() {
//                               _isloading = true;
//                             });
//                             try {
//                               final editcategoryservice =
//                                   SubcategoryApiServices();
//                               final editcategory =
//                                   await editcategoryservice.editsubCategory(
//                                 {
//                                   "category_name": productName.toString(),
//                                   "category_id": id,
//                                 },
//                                 // Pass the category name as a field

//                                 SelectedImage!,

//                                 // Pass the selected image
//                               );
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                     backgroundColor: const Color.fromARGB(
//                                         255, 226, 226, 226),
//                                     content: Text(
//                                       "Subcategory has been Edited Successfully!",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w500,
//                                           color: Colors.redAccent,
//                                           fontSize: 18),
//                                     )),
//                               );
//                             } catch (e) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                     backgroundColor: const Color.fromARGB(
//                                         255, 226, 226, 226),
//                                     content: Text(
//                                       "Error : ${e}",
//                                       style: TextStyle(
//                                           color: Colors.redAccent,
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w500),
//                                     )),
//                               );
//                             } finally {
//                               setState(() {
//                                 _isloading = false;
//                               });
//                               categorynamecontroller
//                                   .clear(); // Clear the text field

//                               imageFile = File('');
//                             }
//                           },
//                           child: Container(
//                             child: _isloading
//                                 ? CircularProgressIndicator(
//                                     color: Colors.white,
//                                   )
//                                 : Text(
//                                     ' Edit Subcategory',
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                           ),
//                         ),
//                       ),
//                       height: MediaQuery.of(context).size.height * 0.06,
//                       decoration: BoxDecoration(
//                           boxShadow: [
//                             BoxShadow(
//                                 blurRadius: 2,
//                                 spreadRadius: 1,
//                                 color: Colors.black)
//                           ],
//                           borderRadius: BorderRadius.circular(70),
//                           color: const Color.fromARGB(255, 211, 71, 83)),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ));
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: Column(
//         children: [
//           // Header Section
//           Container(
//             padding: EdgeInsets.all(10),
//             height: screenHeight * 0.15,
//             width: screenWidth,
//             color: const Color.fromARGB(255, 235, 235, 41),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: screenHeight * 0.05),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Edit SubCategories',
//                           style: GoogleFonts.notoSerifOttomanSiyaq(
//                             fontSize: 22,
//                             fontWeight: FontWeight.w800,
//                           ),
//                         ),
//                         Text(
//                           '(ADMIN PANEL)',
//                           style: GoogleFonts.exo(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w800,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Icon(
//                       CupertinoIcons.heart_circle,
//                       size: 40,
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           SizedBox(
//               height: screenHeight * 0.02), // Space between header and grid

//           // Categories List
//           Expanded(
//             child: FutureBuilder(
//               future: SubcategoryApiServices().fetchsubCategories(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(
//                     child: Text(
//                       'Error: ${snapshot.error}',
//                       style: const TextStyle(color: Colors.red),
//                     ),
//                   );
//                 } else if (snapshot.hasData) {
//                   final categories = snapshot.data!;
//                   return ListView.builder(
//                     padding: EdgeInsets.symmetric(horizontal: 10),
//                     itemCount: categories.length,
//                     itemBuilder: (context, index) {
//                       final category = categories[index];

//                       return Column(
//                         children: [
//                           Container(
//                             height: screenHeight * 0.15,
//                             decoration: BoxDecoration(
//                               color: const Color.fromARGB(255, 255, 255, 255),
//                             ),
//                             child: Row(
//                               children: [
//                                 SizedBox(
//                                   width: screenWidth * 0.2,
//                                   child: Center(
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(10),
//                                       child: Image.network(
//                                         category.imageUrl,
//                                         fit: BoxFit.contain,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(width: 10),
//                                 Container(
//                                   width: screenWidth * 0.2,
//                                   child: Expanded(
//                                     child: Text(
//                                       category.name,
//                                       textAlign: TextAlign.center,
//                                       style: GoogleFonts.exo(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w600,
//                                         color: Color.fromARGB(255, 20, 27, 42),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   width: screenWidth * 0.2,
//                                   child: Expanded(
//                                     child: Text(
//                                       "CategoryName",
//                                       textAlign: TextAlign.center,
//                                       style: GoogleFonts.exo(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w600,
//                                         color: Color.fromARGB(255, 20, 27, 42),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: screenWidth * 0.05,
//                                 ),
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 12),
//                                   child: InkWell(
//                                     onTap: () {
//                                       EditCategoryDetails(
//                                           category.id.toString());
//                                     },
//                                     child: Container(
//                                       width: screenWidth * 0.15,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(20),
//                                         color: Colors.white,
//                                         // boxShadow: [
//                                         //   BoxShadow(
//                                         //     color: Color.fromARGB(
//                                         //         255, 90, 101, 126),
//                                         //     blurRadius: 0,
//                                         //     spreadRadius: 1,
//                                         //   ),
//                                         // ],
//                                       ),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Icon(
//                                             CupertinoIcons
//                                                 .pencil_ellipsis_rectangle,
//                                             color: Colors.red,
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 23),
//                                   child: InkWell(
//                                     onTap: () async {
//                                       print(
//                                           "Deleting category with ID: ${category.id}");

//                                       bool? confirmDelete = await showDialog(
//                                         context: context,
//                                         builder: (context) => AlertDialog(
//                                           title: Text("Delete Category"),
//                                           content: Text(
//                                               "Are you sure you want to delete ${category.name}?"),
//                                           actions: [
//                                             TextButton(
//                                               onPressed: () =>
//                                                   Navigator.pop(context, false),
//                                               child: const Text("Cancel"),
//                                             ),
//                                             TextButton(
//                                               onPressed: () =>
//                                                   Navigator.pop(context, true),
//                                               child: const Text("Delete"),
//                                             ),
//                                           ],
//                                         ),
//                                       );

//                                       if (confirmDelete == true) {
//                                         setState(() {
//                                           _isloading = true;
//                                         });

//                                         try {
//                                           final deletesubcategoryservice =
//                                               SubcategoryApiServices();
//                                           final success =
//                                               await deletesubcategoryservice
//                                                   .deletesubCategory(
//                                                       category.id,
//                                                       "PMAT-01JDF1ZCPKHE7PXSVT9J6YG1AZ");

//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(SnackBar(
//                                             content: Text(
//                                                 '${category.name} deleted successfully'),
//                                           ));
//                                           _refreshCategories();
//                                         } catch (e) {
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(SnackBar(
//                                             content: Text("Error: ${e}"),
//                                           ));
//                                         } finally {
//                                           setState(() {
//                                             _isloading = false;
//                                           });
//                                         }
//                                       }
//                                     },
//                                     child: Container(
//                                       width: screenWidth * 0.1,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(30),
//                                         color: Colors.white,
//                                         //boxShadow: [
//                                         //   BoxShadow(
//                                         //     color: Color.fromARGB(
//                                         //         255, 249, 10, 10),
//                                         //     blurRadius: 0,
//                                         //     spreadRadius: 1,
//                                         //   ),
//                                         // ],
//                                       ),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           // Text(
//                                           //   'Remove',
//                                           //   style: TextStyle(
//                                           //       fontSize: 14,
//                                           //       fontWeight: FontWeight.w700),
//                                           // ),
//                                           Icon(
//                                             CupertinoIcons.bin_xmark_fill,
//                                             color: Colors.red,
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 10),
//                         ],
//                       );
//                     },
//                   );
//                 }
//                 return const SizedBox(); // If no data or error, show nothing
//               },
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         child: Center(
//           child: GestureDetector(
//             onTap: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => Addsubcategory()));
//             },
//             child: Container(
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 5,
//                         ),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15),
//                             color: const Color.fromARGB(255, 255, 237, 36),
//                           ),
//                           height: MediaQuery.of(context).size.height * 0.07,
//                           width: screenWidth * 0.85,
//                           child: Center(
//                             child: Row(
//                               children: [
//                                 Container(
//                                   margin: EdgeInsets.symmetric(
//                                       horizontal: screenWidth * 0.05),
//                                   child: Text("Add a New SubCategory",
//                                       style: GoogleFonts.merriweather(
//                                           color: Colors.black,
//                                           wordSpacing: 6,
//                                           fontWeight: FontWeight.w800,
//                                           fontSize: 18)),
//                                 ),
//                                 Icon(CupertinoIcons.add_circled_solid)
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         height: MediaQuery.of(context).size.height * 0.1,
//         width: MediaQuery.of(context).size.width * 0.1,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: const Color.fromARGB(255, 255, 255, 255),
//         ),
//       ),
//     );
//   }
// }
