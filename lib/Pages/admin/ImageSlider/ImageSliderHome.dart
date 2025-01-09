import 'package:e_commerce_grocery_application/Pages/admin/ImageSlider/AddImage.dart';
import 'package:e_commerce_grocery_application/Pages/admin/ImageSlider/editBannerImage.dart';
import 'package:e_commerce_grocery_application/Pages/models/ImageSliderModel.dart';
import 'package:e_commerce_grocery_application/services/ImageSliderServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Imagesliderhome extends StatefulWidget {
  const Imagesliderhome({super.key});

  @override
  State<Imagesliderhome> createState() => _ImagesliderhomeState();
}

class _ImagesliderhomeState extends State<Imagesliderhome> {
  Future<List<Banners>>? _BannerFuture;
  @override
  void initState() {
    super.initState();
    _BannerFuture = Imagesliderservices().fetchBanners();
  }

  void _refreshCategories() {
    setState(() {
      _BannerFuture = Imagesliderservices().fetchBanners();
    });
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate a network call
    setState(() {
      _refreshCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
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
                        'Edit Banner Image',
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
          Expanded(
            child: FutureBuilder<List<Banners>>(
              future: _BannerFuture,
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
                  final bann = snapshot.data!;

                  return RefreshIndicator(
                    onRefresh: _refreshData,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: bann.length,
                      itemBuilder: (context, index) {
                        final bannrs = bann[index];
                        return Container(
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
                                bannrs.imageUrl,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Show the index + 1 for serial numbers
                            title: Text(
                              'Banner ${index + 1}', // Serial number (1-based index)
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
                                        builder: (context) => UpdateBanner(
                                          bannerId: bannrs.id.toString(),
                                        ),
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
                                        title: const Text("Delete Banner"),
                                        content: Text(
                                            "Are you sure you want to delete Banner ${index + 1}?"),
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
                                      await Imagesliderservices()
                                          .deleteBanner(bannrs.id);
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
                MaterialPageRoute(builder: (context) => AddImage()),
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
                    "Add Image",
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
