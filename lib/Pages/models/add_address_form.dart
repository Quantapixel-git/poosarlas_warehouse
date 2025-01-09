import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AddAddressPage extends StatefulWidget {
  final Map<String, String>? initialData; // Optional initial data for editing

  AddAddressPage({this.initialData});

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers to manage user input
  late TextEditingController nameController;
  late TextEditingController mobileController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController pincodeController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial data or empty strings
    nameController =
        TextEditingController(text: widget.initialData?['name'] ?? '');
    mobileController =
        TextEditingController(text: widget.initialData?['mobile'] ?? '');
    emailController =
        TextEditingController(text: widget.initialData?['email'] ?? '');
    addressController =
        TextEditingController(text: widget.initialData?['address'] ?? '');
    pincodeController =
        TextEditingController(text: widget.initialData?['pincode'] ?? '');
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    addressController.dispose();
    pincodeController.dispose();

    super.dispose();
  }

  void saveDetails() async {
    final userService = UserService(); // Use the singleton instance

    String? userpassword = await userService.getUserId();
    print('$userpassword');
    final emailoptional =
        emailController.text.isEmpty ? "null@null.null" : emailController.text;

    if (_formKey.currentState!.validate()) {
      // Perform save or edit operations
      final userDetails = {
        "user_id": userpassword.toString(),
        "name": nameController.text,
        "mobile": mobileController.text,
        "email": emailoptional,
        "address": addressController.text,
        "pincode": pincodeController.text,
      };
      print('User Details Saved: $userDetails');

      await ProductService().store_address(userDetails);

      // Navigate back or display success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Details Saved Successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text('Add Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name Field
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),
              // Mobile Field
              TextFormField(
                controller: mobileController,
                decoration: InputDecoration(labelText: 'Mobile Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mobile number';
                  } else if (value.length != 10) {
                    return 'Mobile number must be 10 digits';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),
              // Email Field
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  // if (value == null || value.isEmpty) {
                  //   return 'Please enter your email';
                  // } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  //   return 'Enter a valid email address';
                  // }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Address Field
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Pincode Field
              TextFormField(
                controller: pincodeController,
                decoration: InputDecoration(labelText: 'Pincode'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your pincode';
                  } else if (value.length != 6) {
                    return 'Pincode must be 6 digits';
                  }
                  return null;
                },
              ),

              SizedBox(height: 32),
              // Save Button
              ElevatedButton(
                onPressed: saveDetails,
                child: Text('Save Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
