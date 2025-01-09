import 'dart:async';

import 'package:e_commerce_grocery_application/Pages/Homescreen.dart';
import 'package:e_commerce_grocery_application/Pages/UserType.dart';
import 'package:e_commerce_grocery_application/Pages/admin/admin_home.dart';
import 'package:e_commerce_grocery_application/Pages/bottomnavbar.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:e_commerce_grocery_application/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () async {
      bool isAdmin = await SharedPref().isAdminLoggedIn() ?? false;
      bool isUser = await SharedPref().isUserLoggedIn();
      if (isAdmin == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHome()),
        );
      } else if (isUser == true) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Bottomnavbar()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Usertype()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: AppColors.mainColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Container(
                height: screenHeight * 0.25,
                child: Image.asset('assets/7.png')),
            Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 228, 227, 205),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Container(
                    child: Image.asset(
                      'assets/app_logo.jpeg',
                    ),
                    width: screenWidth * 0.80,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    '"Celebrating 30+ Years Together"',
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Thank You for Being Part of Our Journey!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.adamina(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            SpinKitCircle(
              color: const Color.fromARGB(255, 0, 0, 0),
              size: 50,
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              height: screenHeight * 0.04,
              width: screenWidth * 0.4,
              child: Image.asset(
                'assets/1.png',
                fit: BoxFit.contain,
              ),
            )
          ],
        ));
  }
}
