import 'dart:io';
import 'package:e_commerce_grocery_application/services/category_api_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditCategoryPage extends StatefulWidget {
  final int id;

  const EditCategoryPage({super.key, required this.id});

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  bool _isLoading = false; // For submission
  bool _isFetching = true; // For fetching details
  TextEditingController categoryNameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  String? imageUrl; // For fetched image URL

  @override
  void initState() {
    super.initState();
    _fetchCategoryDetails();
  }

  Future<void> _fetchCategoryDetails() async {
    try {
      final categoryResponse =
          await CategoryApiServices().fetchSpecificCategory(widget.id);
      print(categoryResponse);

      if (categoryResponse != null && categoryResponse['status'] == 1) {
        final categoryData = categoryResponse['data'];
        setState(() {
          categoryNameController.text = categoryData['category_name'] ?? "";
          imageUrl = categoryData['image_url'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(categoryResponse?['message'] ??
                "Failed to fetch category details."),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching category details: $e")),
      );
    } finally {
      setState(() {
        _isFetching = false;
      });
    }
  }

  Future<void> getImage() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error selecting image: $e")),
      );
    }
  }

  Future<void> editCategory() async {
    String categoryName = categoryNameController.text;

    if (categoryName.isEmpty || (selectedImage == null && imageUrl == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all details.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await CategoryApiServices().editCategory(
        CategoryName: categoryNameController.text,
        CategoryId: widget.id.toString(),
        CategoryImage: selectedImage ?? File(''),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Category updated successfully!")),
      );

      Navigator.pop(context); // Navigate back after success
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating category: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (_isFetching) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: screenHeight * 0.2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.redAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.navigate_before,
                        size: 40,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Navigate back to the previous screen
                      },
                    ),
                    Text(
                      'Edit Category',
                      style: GoogleFonts.notoSerifOttomanSiyaq(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Image Selector
            GestureDetector(
              onTap: getImage,
              child: Container(
                height: screenHeight * 0.2,
                width: screenWidth * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: selectedImage == null && imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.error,
                              color: Colors.red,
                            );
                          },
                        ),
                      )
                    : selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Center(child: Text('No Image Found')),
              ),
            ),
            const SizedBox(height: 20),

            // Category Name Input
            // Category Name Input
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: TextField(
                controller: categoryNameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  suffixIcon: categoryNameController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            // Action on tick icon tap

                            // Update the state to reflect the new category name
                            setState(() {
                              String updatedCategoryName =
                                  categoryNameController.text;
                              // Optionally, you can save the value or call any method here
                              print(
                                  'Updated category name: $updatedCategoryName');
                            });
                          },
                          child: const Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                        )
                      : null, // Only show tick icon if there's text
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Submit Button
            InkWell(
              onTap: _isLoading ? null : editCategory,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                margin: const EdgeInsets.symmetric(horizontal: 40),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.orange, Colors.red],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Update Category",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
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
