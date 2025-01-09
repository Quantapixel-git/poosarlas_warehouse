import 'package:e_commerce_grocery_application/services/login_api_services.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditUserPage extends StatefulWidget {
  // final Map<String, dynamic> userData;
  String name, mobile, address, id;
  EditUserPage(
      {super.key,
      required this.address,
      required this.mobile,
      required this.name,
      required this.id});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void _createUser() async {
    if (_formKey.currentState!.validate()) {
      final apiService = ApiService();
      final userData = await apiService.editUser(
          name: _nameController.text,
          mobile: _phoneNumberController.text,
          userid: widget.id,
          address: _addressController.text,
          context: context);
      print(userData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              userData['message'].toString(),
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 18),
            )),
      );
      _nameController.clear();
      _phoneNumberController.clear();

      _addressController.clear();
      // Navigator.pop(context);
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Please provide valid credentials')),
      // );
    }
  }

  @override
  void initState() {
    //print(widget.userData);
    _nameController.text = widget.name;
    _phoneNumberController.text = widget.mobile;
    _addressController.text = widget.address;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Attach the form key
            child: Stack(
              children: [
                Column(
                  children: [
                    // Header Section
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            Text(
                              'Update User',
                              style: GoogleFonts.oswald(
                                fontWeight: FontWeight.w600,
                                fontSize: 35,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Edit Users Detail.',
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
                    const SizedBox(
                      height: 50,
                    ),
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
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height),
                          child: IntrinsicHeight(
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                  labelText: 'Enter Your Address',
                                  hintText: 'Your Address',
                                  controller: _addressController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Address cannot be empty';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),

                                InkWell(
                                  onTap: () {
                                    _createUser();
                                  },
                                  child: _buildButton(
                                    screenWidth,
                                    'Update  User',
                                    const Color.fromARGB(255, 0, 0, 0),
                                    Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                // Footer Section
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 15.0,
                  left: 15.0,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child:
                        const Icon(Icons.arrow_back_ios, color: Colors.black),
                  ),
                )
              ],
            ),
          ),
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
}
