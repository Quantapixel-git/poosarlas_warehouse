import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:e_commerce_grocery_application/Pages/CategoryNav.dart';
import 'package:e_commerce_grocery_application/Pages/Homescreen.dart';
import 'package:e_commerce_grocery_application/Pages/account_page.dart';
import 'package:e_commerce_grocery_application/Pages/cartpage.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({super.key});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  int _currentIndex = 0;
  DateTime? lastPressed;

  final List<Widget> _pages = [
    Homescreen(),
    CategoryNav(),
    Cartpage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (lastPressed == null ||
            now.difference(lastPressed!) > Duration(seconds: 2)) {
          lastPressed = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Press back again to exit"),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: CurvedNavigationBar(
          height: MediaQuery.of(context).size.height * 0.075,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: AppColors.mainColor,
          color: Colors.white,
          animationDuration: Duration(milliseconds: 300),
          items: [
            Icon(Icons.home),
            Icon(CupertinoIcons.cube_box),
            Icon(Icons.shopping_cart_checkout_outlined),
            Icon(CupertinoIcons.profile_circled),
          ],
        ),
      ),
    );
  }
}
