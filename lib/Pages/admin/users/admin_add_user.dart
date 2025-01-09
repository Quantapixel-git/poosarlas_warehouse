import 'package:e_commerce_grocery_application/Pages/admin/users/users_list_page.dart';
import 'package:e_commerce_grocery_application/services/login_api_services.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminAddUser extends StatefulWidget {
  bool flag;
  AdminAddUser({required this.flag});

  @override
  State<AdminAddUser> createState() => _AdminAddUserState();
}

class _AdminAddUserState extends State<AdminAddUser> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool isLoading = false; // Add this flag to track loading state

  void _createUser() async {
    if (_formKey.currentState!.validate()) {
      // Check if passwords match
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match!')),
        );
        return; // Stop execution
      }

      // Check password length
      if (_passwordController.text.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Password must be at least 6 characters long!')),
        );
        return; // Stop execution
      }

      final address = _addressController.text.isEmpty
          ? 'Not Specified'
          : _addressController.text;

      setState(() {
        isLoading = true; // Start loading
      });

      try {
        final apiService = ApiService();
        final userData = await apiService.register(
          name: _nameController.text,
          mobile: _phoneNumberController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          address: address,
          context: context,
        );
        print(userData);

        // Clear the controllers
        _nameController.clear();
        _phoneNumberController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
        _addressController.clear();

        // Navigation logic based on flag
        if (widget.flag) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return UsersListPage();
          }));
        } else {
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create user: $e')),
        );
      } finally {
        setState(() {
          isLoading = false; // Stop loading
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide valid credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Header Section
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            Text(
                              'Create User',
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
                    const SizedBox(height: 50),
                    // Content Section
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.bgColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(59),
                          topRight: Radius.circular(59),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 20),
                            _buildTextField(
                              labelText: 'Enter Your Name',
                              hintText: 'Name',
                              controller: _nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Name cannot be empty';
                                }
                                return null;
                              },
                            ),
                            _buildTextField(
                              labelText: 'Enter Your Phone Number (+91)',
                              hintText: 'Phone Number',
                              prefix: const Text(
                                '+91 ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              keyboardType: TextInputType.phone,
                              controller: _phoneNumberController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Phone number cannot be empty';
                                }
                                return null;
                              },
                            ),
                            _buildTextField(
                              labelText: 'Enter Your Password',
                              hintText: 'Enter Password ',
                              obscureText: true,
                              controller: _passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Confirm Password cannot be empty';
                                }
                                return null;
                              },
                            ),
                            _buildTextField(
                              labelText: 'Confirm Your Password',
                              hintText: 'Confirm Password',
                              obscureText: true,
                              controller: _confirmPasswordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Confirm Password cannot be empty';
                                }
                                return null;
                              },
                            ),
                            _buildTextField(
                              labelText: 'Enter Your Address',
                              hintText: 'Your Address',
                              controller: _addressController,
                              validator: (value) {
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            if (isLoading)
                              const Center(child: CircularProgressIndicator())
                            else
                              InkWell(
                                onTap: _createUser,
                                child: _buildButton(
                                  screenWidth,
                                  'Create User',
                                  const Color.fromARGB(255, 0, 0, 0),
                                  Colors.white,
                                ),
                              ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 15.0,
              left: 15.0,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable TextField Widget
Widget _buildTextField({
  required String labelText,
  required String hintText,
  Widget? prefix,
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
  TextEditingController? controller,
  String? Function(String?)? validator,
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
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefix: prefix,
            labelText: labelText,
            hintText: hintText,
            border: InputBorder.none,
          ),
          validator: validator,
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
