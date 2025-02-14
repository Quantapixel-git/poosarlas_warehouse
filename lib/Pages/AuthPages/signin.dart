import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:e_commerce_grocery_application/provider/userIdprovider.dart';
import 'package:e_commerce_grocery_application/services/login_api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  TextEditingController phonenumcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool _isLoading = false; // Add this line to prevent the error

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true, // Allows view to adjust for the keyboard
      backgroundColor: const Color.fromARGB(255, 235, 235, 41),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          child: IntrinsicHeight(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    // Back arrow icon
                    Container(
                      height: screenHeight * 0.2,
                      child: Center(
                        child: Container(
                          height: screenHeight * 0.1,
                          width: screenWidth * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Column(
                                children: [
                                  Text(
                                    'User Login',
                                    style: GoogleFonts.oswald(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 40,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      ' Please enter the details below to continue.',
                                      style: GoogleFonts.notoSerifOttomanSiyaq(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Content Section
                    Container(
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 228, 227, 205),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(59),
                          topRight: Radius.circular(59),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: screenWidth * 0.88,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 226, 226, 226),
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
                                    controller: phonenumcontroller,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '  Phone Number',
                                      labelText:
                                          '  Enter Your Phone Number (+91)',
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
                                  color:
                                      const Color.fromARGB(255, 226, 226, 226),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: TextField(
                                    controller: passwordcontroller,
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
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Forgot Password ?',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 101, 111, 7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            InkWell(
                              onTap: () async {
                                final mobile = phonenumcontroller.text.trim();
                                final password = passwordcontroller.text.trim();

                                if (mobile.isEmpty || password.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: const Color.fromARGB(
                                          255, 226, 226, 226),
                                      content: Text(
                                        "Mobile number or password cannot be empty!",
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18),
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                setState(() {
                                  _isLoading = true;
                                });

                                try {
                                  final apiService = ApiService();
                                  final userData = await apiService.login(
                                      mobile, password, context);
                                  print(userData);

                                  // Set userId in the UserProvider
                                  Provider.of<UserProvider>(context,
                                          listen: false)
                                      .setUserId(userData['id']);
                                  userId = userData['id']
                                      .toString(); // Local userId variable
                                  // Show success message

                                  // Navigate to the home screen or other logic
                                  Navigator.pushReplacementNamed(
                                      context, '/home'); // Example
                                } catch (e) {
                                  // Show error message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: const Color.fromARGB(
                                          255, 226, 226, 226),
                                      content: Text(
                                        "Please Check Your Phone Number and Password!",
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  );
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
                                  color:
                                      _isLoading ? Colors.grey : Colors.black,
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
                            SizedBox(height: 20),
                            Text(
                              'Don\'t have an account ?',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  top: 50,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop(); // Navigate back
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
