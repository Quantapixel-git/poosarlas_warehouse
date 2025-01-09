import 'package:e_commerce_grocery_application/Pages/admin/categories/add_category_page.dart';
import 'package:e_commerce_grocery_application/Pages/admin/categories/edit_category_page.dart';
import 'package:e_commerce_grocery_application/Pages/model_category.dart/model_category.dart';
import 'package:e_commerce_grocery_application/services/category_api_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  Future<List<ModelCategory>>? _categoriesFuture;
  List<ModelCategory> _categories = []; // List to hold the category data.

  @override
  void initState() {
    super.initState();
    _categoriesFuture = CategoryApiServices().fetchCategories();
  }

  void _refreshCategories() {
    setState(() {
      _categoriesFuture = CategoryApiServices().fetchCategories();
    });
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate a network call
    setState(() {
      _refreshCategories();
    });
  }

  // Method to update category priority on the server
  Future<void> _updateCategoryPriority(
      List<ModelCategory> updatedCategories) async {
    try {
      for (int i = 0; i < updatedCategories.length; i++) {
        final category = updatedCategories[i];
        final priorityId =
            i + 1; // New priority is based on the index (1-based)

        // Call the API service to update category priority
        final response = await CategoryApiServices().updateCategoryPriority(
          category.id, // category_id
          priorityId, // priority_number
        );

        // Check the response status and handle accordingly
        if (response['status'] == 1) {
          print('Category priority updated successfully for ${category.name}');
        } else {
          print(
              'Failed to update category priority for ${category.name}. Error: ${response['message']}');
        }
      }
    } catch (e) {
      print('Error updating category priority: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Header Section
          Container(
            height: screenHeight * 0.2,
            width: screenWidth,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 237, 36),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                      Text(
                        'Edit Categories',
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 48.0),
                    child: Text(
                      'Admin Panel',
                      style: GoogleFonts.poppins(
                        color: const Color.fromARGB(179, 0, 0, 0),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Scroll Down to refresh the Products',
            style: GoogleFonts.poppins(
              color: const Color.fromARGB(179, 0, 0, 0),
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 10,
          ),

          // Categories List
          Expanded(
            child: FutureBuilder<List<ModelCategory>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final categories = snapshot.data!;
                  return RefreshIndicator(
                    onRefresh: _refreshData,
                    child: ReorderableListView.builder(
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final item = categories.removeAt(oldIndex);
                          categories.insert(newIndex, item);

                          // After reordering, update the category priorities
                          _updateCategoryPriority(
                              categories); // Send updated order to the server
                        });
                      },
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];

                        // Each item in the list needs a unique key
                        return Container(
                          key: ValueKey(
                              category.id), // Assign a key to each item
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(15),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                category.imageUrl,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              category.name,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF212121),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    CupertinoIcons.pencil_circle,
                                    color: Color(0xFF1A73E8),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditCategoryPage(id: category.id),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    CupertinoIcons.delete_solid,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    bool? confirmDelete = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Delete Category"),
                                        content: Text(
                                            "Are you sure you want to delete ${category.name}?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text("Delete"),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirmDelete == true) {
                                      await CategoryApiServices()
                                          .deleteCategory(
                                        category.id,
                                        "PMAT-01JDF1ZCPKHE7PXSVT9J6YG1AZ",
                                      );
                                      _refreshCategories();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const Center(
                  child: Text('No categories found'),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height * 0.1,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCategoryPage()),
              );
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromARGB(255, 255, 237, 36),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Add a Category",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.merriweather(
                      color: Colors.black,
                      wordSpacing: 6,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(CupertinoIcons.add_circled_solid),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
