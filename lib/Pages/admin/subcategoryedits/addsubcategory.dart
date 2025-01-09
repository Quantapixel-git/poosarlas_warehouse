// import 'dart:io';

// import 'package:e_commerce_grocery_application/services/subcategory_api_services.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';

// class Addsubcategory extends StatefulWidget {
//   const Addsubcategory({super.key});

//   @override
//   State<Addsubcategory> createState() => _AddsubcategoryState();
// }

// class _AddsubcategoryState extends State<Addsubcategory> {
//   final ImagePicker _picker = ImagePicker();
//   File? SelectedImage;
//   bool _isLoading = false;
//   TextEditingController productnamecontroller = new TextEditingController();

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

//   final List<String> CategoryItem = [
//     'Select a Category',
//     'Cold Drinks and Shakes',
//     'Fruits and Vegetables',
//     'Detergents and Soaps',
//     'Baby Care',
//     'Snacks',
//     'Pet Care',
//     'Atta and Rice',
//     'Tea and Coffee',
//     'Medicine',
//   ];
//   String SelectedValue = 'Select a Category';
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.all(10),
//               height: screenHeight * 0.15,
//               width: screenWidth,
//               color: const Color.fromARGB(255, 235, 235, 41),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: screenHeight * 0.05),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Add A Category',
//                             style: GoogleFonts.notoSerifOttomanSiyaq(
//                               fontSize: 22,
//                               fontWeight: FontWeight.w800,
//                             ),
//                           ),
//                           Text(
//                             '(ADMIN PANEL)',
//                             style: GoogleFonts.exo(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w800,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Icon(
//                         CupertinoIcons.heart_circle,
//                         size: 40,
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(
//                 height: screenHeight * 0.02), // Space between header and grid

//             SizedBox(
//               height: 30,
//             ),

//             SelectedImage == null
//                 ? GestureDetector(
//                     onTap: () {
//                       getImage();
//                     },
//                     child: Container(
//                       height: 155,
//                       width: 155,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           border: Border.all(
//                               color: const Color.fromARGB(255, 131, 131, 131),
//                               width: 5)),
//                       child: Column(
//                         children: [
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Icon(
//                             Icons.camera_alt_outlined,
//                             color: const Color.fromARGB(255, 106, 106, 106),
//                             size: 80,
//                           ),
//                           Text(
//                             'Click to Add Image',
//                             style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 : Material(
//                     elevation: 4.0,
//                     borderRadius: BorderRadius.circular(20),
//                     child: GestureDetector(
//                       onTap: () {
//                         SelectedImage = null;
//                         getImage();
//                       },
//                       child: Container(
//                         height: 155,
//                         width: 155,
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             border: Border.all(
//                                 color: const Color.fromARGB(255, 131, 131, 131),
//                                 width: 5)),
//                         child: Image.file(
//                           SelectedImage!,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     )),
//             SizedBox(
//               height: 30,
//             ),

//             SizedBox(
//               height: 20,
//             ),
//             Container(
//               height: 60,
//               margin: EdgeInsets.only(right: 10, left: 10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 20),
//                 child: TextField(
//                   controller: productnamecontroller,
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
//                   decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'Product Category Name',
//                       hintStyle: TextStyle(fontSize: 20),
//                       labelText: 'Enter Category Name',
//                       labelStyle: TextStyle(fontSize: 20)),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),

//             SizedBox(
//               height: 30,
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               width: screenWidth * 0.7,
//               child: Center(
//                 child: InkWell(
//                   onTap: () async {
//                     String productName = productnamecontroller.text.trim();

//                     if (SelectedImage == null || productName.isEmpty) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                             backgroundColor:
//                                 const Color.fromARGB(255, 226, 226, 226),
//                             content: Text(
//                               'Please enter a category name and select an image!',
//                               style: TextStyle(
//                                   color: Colors.redAccent,
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 18),
//                             )),
//                       );
//                       return;
//                     }
//                     setState(() {
//                       _isLoading = true;
//                     });
//                     try {
//                       final addcategoryservice = SubcategoryApiServices();
//                       final Addcategory =
//                           await addcategoryservice.addSubCategory(
//                         {
//                           "category_name": productName
//                         }, // Pass the category name as a field
//                         SelectedImage!, // Pass the selected image
//                       );
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                             backgroundColor:
//                                 const Color.fromARGB(255, 226, 226, 226),
//                             content: Text(
//                               "Product has been Added Successfully!",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.redAccent,
//                                   fontSize: 18),
//                             )),
//                       );
//                     } catch (e) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                             backgroundColor:
//                                 const Color.fromARGB(255, 226, 226, 226),
//                             content: Text(
//                               "Error : ${e}",
//                               style: TextStyle(
//                                   color: Colors.redAccent,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w500),
//                             )),
//                       );
//                     } finally {
//                       setState(() {
//                         _isLoading = false;
//                       });
//                     }
//                   },
//                   child: Container(
//                     child: _isLoading
//                         ? CircularProgressIndicator(
//                             color: Colors.white,
//                           )
//                         : Text(
//                             ' Add Category',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                   ),
//                 ),
//               ),
//               height: MediaQuery.of(context).size.height * 0.06,
//               decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                         blurRadius: 2, spreadRadius: 1, color: Colors.black)
//                   ],
//                   borderRadius: BorderRadius.circular(70),
//                   color: const Color.fromARGB(255, 211, 71, 83)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
