import 'package:e_commerce_grocery_application/Pages/UserType.dart';
import 'package:e_commerce_grocery_application/Pages/admin/ImageSlider/ImageSliderHome.dart';
import 'package:e_commerce_grocery_application/Pages/admin/exportdata/export_HP.dart';
import 'package:e_commerce_grocery_application/Pages/admin/help_page.dart';
import 'package:e_commerce_grocery_application/Pages/admin/categories/category_page.dart';
import 'package:e_commerce_grocery_application/Pages/admin/minimumordervalue.dart';
import 'package:e_commerce_grocery_application/Pages/admin/users/admin_add_user.dart';
import 'package:e_commerce_grocery_application/Pages/admin/orders/orders_admin.dart';
import 'package:e_commerce_grocery_application/Pages/admin/products/product_list_page.dart';
import 'package:e_commerce_grocery_application/Pages/admin/users/users_list_page.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:e_commerce_grocery_application/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _appBarView(),
            SizedBox(height: screenHeight * 0.02),

            // Add User Card
            _addUserCardView(),

            // Options Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  _buildRowOptions(
                    context: context,
                    options: [
                      {'label': 'Export Data', 'page': ExportHp()},
                      {
                        'label': 'Minimum Order Value',
                        'page': Minimumordervalue(),
                      },
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildRowOptions(
                    context: context,
                    options: [
                      {'label': 'Categories', 'page': CategoryPage()},
                      {'label': 'Products', 'page': ProductListPage()},
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildRowOptions(
                    context: context,
                    options: [
                      {
                        'label': 'Orders',
                        'page': MakeOrderPage(
                          isAdmin: true,
                        )
                      },
                      {'label': 'Users', 'page': const UsersListPage()},
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildRowOptions(
                    context: context,
                    options: [
                      {
                        'label': 'Image Slider',
                        'page': Imagesliderhome(),
                      },
                      {'label': 'Need Help ?', 'page': NeedHelpAdminPage()},
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 110),
                  //   child: _buildRowOptions(
                  //     context: context,
                  //     options: [
                  //       {'label': 'Need Help ?', 'page': NeedHelpAdminPage()},
                  //       //{'label': 'Trending', 'page': const Placeholder()},
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowOptions(
      {required BuildContext context,
      required List<Map<String, dynamic>> options}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: options.map((option) {
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => option['page']),
          ),
          child: Container(
            padding: const EdgeInsets.all(15),
            alignment: Alignment.center,
            height: 100,
            width: MediaQuery.of(context).size.width * 0.42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              option['label'],
              style: GoogleFonts.exo(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }).toList(),
    );
  }

  _appBarView() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.mainColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1 - 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // IconButton(
                        //   icon: const Icon(Icons.navigate_before, size: 35),
                        //   onPressed: () {
                        //     Navigator.of(context)
                        //         .pop(); // Navigate back to the previous screen
                        //   },
                        // ),
                        Text('Admin Grocery',
                            style: GoogleFonts.notoSerif(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            )),
                        IconButton(
                          icon: const Icon(Icons.logout, size: 30),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Usertype()), // Replace with your target page
                              (Route<dynamic> route) =>
                                  false, // This removes all routes
                            );
                            SharedPref().setAdminLogin(false);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Text(
                      '(Admin Panel)',
                      style: GoogleFonts.exo(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _addUserCardView() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AdminAddUser(
                        flag: true,
                      )));
        },
        child: Container(
          width: screenWidth * 0.65,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                    'https://i.pinimg.com/564x/4e/22/be/4e22beef6d94640c45a1b15f4a158b23.jpg'),
              ),
              const SizedBox(height: 15),
              Text(
                'Add a User',
                style: GoogleFonts.exo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '(Click to add a User)',
                style: GoogleFonts.exo(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
