import 'package:e_commerce_grocery_application/Pages/AuthPages/signin.dart';
import 'package:e_commerce_grocery_application/Pages/bottomnavbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.yellow,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Back Icon
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 15,),
              child: Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios, color: Colors.black),
                ),
              ),
            ),
            // Header Section
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Text(
                      'User Registration',
                      style: GoogleFonts.oswald(
                        fontWeight: FontWeight.w600,
                        fontSize: 35,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Please enter the details below to continue.',
                      style: GoogleFonts.notoSerifOttomanSiyaq(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            // Content Section
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 228, 227, 205),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(59),
                  topRight: Radius.circular(59),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 200,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTextField(
                          labelText: 'Enter Your Name',
                          hintText: 'Name',
                        ),
                        _buildTextField(
                          labelText: 'Enter Your Phone Number (+91)',
                          hintText: 'Phone Number',
                          prefix: const Text(
                            '+91 ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        _buildTextField(
                          labelText: 'Enter Your Email',
                          hintText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        _buildTextField(
                          labelText: 'Enter Your Password',
                          hintText: 'Password',
                          obscureText: true,
                        ),
                        _buildTextField(
                          labelText: 'Confirm Your Password',
                          hintText: 'Confirm Password',
                          obscureText: true,
                        ),
                        _buildTextField(
                          labelText: 'Enter Your Address',
                          hintText: 'Your Address',
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Bottomnavbar()));
                          },
                          child: _buildButton(
                            screenWidth,
                            'Sign Up',
                            const Color.fromARGB(255, 0, 0, 0),
                            Colors.white,
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Footer Section
                        Column(
                          children: [
                            Text(
                              'Already have an account?',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Signin(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 101, 111, 7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
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

  // Reusable TextField Widget
  Widget _buildTextField({
    required String labelText,
    required String hintText,
    Widget? prefix,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 226, 226, 226),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            obscureText: obscureText,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              prefix: prefix,
              labelText: labelText,
              hintText: hintText,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  // Reusable Button Widget
  Widget _buildButton(
      double screenWidth, String text, Color bgColor, Color textColor) {
    return Container(
      height: 55,
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.exo(
            color: textColor,
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
