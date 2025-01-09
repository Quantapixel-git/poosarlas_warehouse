//import 'dart:math';

import 'package:e_commerce_grocery_application/Pages/bottomnavbar.dart';
import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:e_commerce_grocery_application/provider/userIdprovider.dart';
import 'package:e_commerce_grocery_application/services/login_api_services.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:e_commerce_grocery_application/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import 'admin/admin_login.dart';

class Usertype extends StatefulWidget {
  const Usertype({super.key});

  @override
  State<Usertype> createState() => _UsertypeState();
}

class _UsertypeState extends State<Usertype> {
  bool _isLoading = false;

  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.mainColor,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // const SizedBox(
              //   height: 80.0,
              // ),
              _upperContainer(),
              // const SizedBox(
              //   height: 50.0,
              // ),
              _userLoginForm(),
              const SizedBox(
                height: 50.0,
              ),
              _lowerContainer(),
            ],
          ),
        ));
  }

  _upperContainer() {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Center(
        child: Image.asset(
          'assets/app_logo.jpeg',
          height: 350,
          width: 300,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  _userLoginForm() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: screenWidth * 0.88,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 226, 226, 226),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(
                            10) // Restrict to numbers
                      ],
                      controller: phoneController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '  Phone Number',
                        labelText: '  Enter Your Phone Number (+91)',
                        prefix: Text('+91 '),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: screenWidth * 0.88,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 226, 226, 226),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '  Password',
                        labelText: '  Enter Your Password',
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15),
              InkWell(
                onTap: () async {
                  final mobile = phoneController.text.trim();
                  final password = passwordController.text.trim();

                  if (mobile.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor:
                              const Color.fromARGB(255, 226, 226, 226),
                          content: Text(
                            "Mobile number or password cannot be empty!",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          )),
                    );
                    return;
                  }

                  setState(() {
                    _isLoading = true;
                  });

                  // try {
                  //   final apiService = ApiService();
                  //   final userData =
                  //       apiService.login(mobile, password, context);
                  //   //  var userIddd = userData['data']['id'];
                  //   // log('user id 1 = ${userIddd}');
                  //   // final userIdd = userData['id'].toString();
                  //   // Provider.of<UserProvider>(context, listen: false)
                  //   //     .setUserId(userId);
                  //   // print(userIdd);
                  //   print("use 123 = ${userData['data']}");

                  //   //  userId = userData['id'].toString();

                  //   //userId='1';//coment this.
                  //   Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => Bottomnavbar()),
                  //   );
                  //   SharedPref().setUserLogin(true);
                  // } catch (e) {
                  //   // Show error message
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //         backgroundColor:
                  //             const Color.fromARGB(255, 226, 226, 226),
                  //         content: Text(
                  //           "Please Check Your Phone Number and Password !",
                  //           style: TextStyle(
                  //               color: Colors.redAccent,
                  //               fontSize: 18,
                  //               fontWeight: FontWeight.w500),
                  //         )),
                  //   );
                  // } finally {
                  //   setState(() {
                  //     _isLoading = false;
                  //   });
                  // }
                  try {
                    setState(() {
                      _isLoading = true;
                    });

                    final apiService = ApiService();

                    // Await the resolution of the Future
                    final userData =
                        await apiService.login(mobile, password, context);

                    // Debugging to confirm userData contains the expected data
                    print("User data = ${userData['data']}");
                    var userIdd = userData['data']['id'];

                    // Perform navigation after successful login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Bottomnavbar()),
                    );

                    // Save login status in shared preferences
                    await SharedPref().setUserLogin(true);
                  } catch (e) {
                    // Handle errors
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor:
                            const Color.fromARGB(255, 226, 226, 226),
                        content: Text(
                          "Please check your phone number and password!",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                    print("Error during login: $e");
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  height: screenHeight * 0.06,
                  width: screenWidth * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: _isLoading ? Colors.grey : Colors.black,
                  ),
                  child: Center(
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          )
                        : Text(
                            'LOGIN',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
              // SizedBox(height: 20),
              // Text(
              //   'Don\'t have an account ?',
              //   style: TextStyle(
              //     fontSize: 16,
              //     color: Color.fromARGB(255, 0, 0, 0),
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  _lowerContainer() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 1,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 228, 227, 205),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(59), topRight: Radius.circular(59))),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Welcome',
                  style: GoogleFonts.notoSerifOttomanSiyaq(
                      fontSize: 34, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Welcome to Poosarla's Warehouse, where Foodie Meets Food Creators, Get all the delicious food from your nearest store, on just One Tap.",
                  style: GoogleFonts.notoSerifOttomanSiyaq(
                      fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminLogin()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        height: 55,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Center(
                            child: Text(
                              'Admin Login',
                              style: GoogleFonts.exo(
                                  fontSize: 19, fontWeight: FontWeight.w800),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
