import 'dart:io';
import 'package:e_commerce_grocery_application/services/category_api_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddCategoryPage extends StatefulWidget {
  const AddCategoryPage({super.key});

  @override
  State<AddCategoryPage> createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  bool _isLoading = false;
  TextEditingController categoryNameController = TextEditingController();

  Future<void> getImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void _refreshCategories() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              height: screenHeight * 0.15,
              width: screenWidth,
              color: const Color.fromARGB(255, 255, 237, 36),
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
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black,
                                  size: 22,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(); // Navigate back
                                },
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Add A Category',
                                    style: GoogleFonts.notoSerifOttomanSiyaq(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    '(ADMIN PANEL)',
                                    style: GoogleFonts.exo(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(
                height: screenHeight * 0.02), // Space between header and grid

            const SizedBox(height: 30),

            // Image Selector
            GestureDetector(
              onTap: getImage,
              child: Container(
                height: 170,
                width: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color.fromARGB(255, 131, 131, 131),
                    width: 3,
                  ),
                  color: Colors.grey[100],
                ),
                child: selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.camera_alt_outlined,
                            size: 70,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Tap to Add Image',
                            style: GoogleFonts.exo(
                              fontSize: 16,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 30),

            // Category Name Input
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: categoryNameController,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter Category Name',
                  hintStyle: GoogleFonts.lato(fontSize: 16, color: Colors.grey),
                  labelText: 'Category Name',
                  labelStyle: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50),

            // Add Button
            InkWell(
              onTap: () async {
                final categoryName = categoryNameController.text.trim();
                if (selectedImage == null || categoryName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.redAccent,
                      content: const Text(
                        'Please provide a category name and select an image!',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                  return;
                }

                setState(() => _isLoading = true);

                try {
                  final AddCategoryPageService = CategoryApiServices();
                  await AddCategoryPageService.addCategory(
                    {"category_name": categoryName},
                    selectedImage!,
                  );
                  _refreshCategories();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                        '$categoryName added successfully!',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );

                  categoryNameController.clear();
                  setState(() => selectedImage = null);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        'Error: $e',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                } finally {
                  setState(() => _isLoading = false);
                }
              },
              child: Container(
                height: 55,
                width: screenWidth * 0.8,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 235, 87, 87),
                      Color.fromARGB(255, 197, 36, 62),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        'Add Category',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
