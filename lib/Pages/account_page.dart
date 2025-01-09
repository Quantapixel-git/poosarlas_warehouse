import 'dart:convert';

import 'package:e_commerce_grocery_application/Pages/UserType.dart';
import 'package:e_commerce_grocery_application/Pages/models/user_details_model.dart';
import 'package:e_commerce_grocery_application/Pages/users_OrdersPage.dart';
import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:e_commerce_grocery_application/provider/userIdprovider.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:e_commerce_grocery_application/utils/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  String? userIdd;
  UserDetailsModel? userDetailsModel;
  String? getUserId(BuildContext context, {bool listen = false}) {
    userIdd = Provider.of<UserProvider>(context, listen: false).userId;
    return userIdd?.toString();
  }

  /// USER DETAIL FETCH
  Future<void> fetchUserDetail(BuildContext context) async {
    final userService = UserService(); // Use the singleton instance

    String? userpassword = await userService.getUserId();
    print('hiii$userpassword'); // Correctly access the instance method

    userDetailsModel = (await ProductService()
        .getUserDetails(userpassword.toString(), context));
    print('123 $userDetailsModel');
    setData();
    setState(() {});
  }

  setData() {
    if (userDetailsModel != null) {
      nameController.text = userDetailsModel?.data?.name ?? '';
      mobileController.text = userDetailsModel?.data?.mobile ?? '';
      addressController.text = userDetailsModel?.data?.address ?? '';
    }
  }

  /// USER DETAIL FETCH
  Future<void> updateUserDetail() async {
    userDetailsModel = (await ProductService().updateUserDetails(
        context,
        nameController.text,
        mobileController.text,
        addressController.text,
        userDetailsModel?.data?.id?.toString()));

    print(jsonEncode(userDetailsModel));
    setState(() {});
  }

  @override
  void initState() {
    fetchUserDetail(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              height: screenHeight * 0.15,
              width: screenWidth,
              color: AppColors.mainColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 22),
                                child: Text(
                                  "POOSARLA'S WAREHOUSE",
                                  style: GoogleFonts.notoSerifOttomanSiyaq(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 22),
                            child: Text(
                              'At Your Doorstep',
                              style: GoogleFonts.exo(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      //Icon(
                      //CupertinoIcons.settings_solid,
                      //size: 40,
                      //)
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Container(
              width: screenWidth * 0.65,
              // height: screenHeight * 0.35,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 90, 101, 126),
                    blurRadius: 0,
                    spreadRadius: 1,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        _showUpdateDialog(context, nameController,
                            mobileController, addressController, callBack: () {
                          updateUserDetail();
                        });
                      },
                      child: Icon(
                        CupertinoIcons.square_pencil_fill,
                        color: Color(0xFF475296),
                        size: 38,
                      ),
                    ),
                  ),
                  Container(
                    height: screenHeight * 0.13,
                    width: screenWidth * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Image.network(
                      'https://i.pinimg.com/564x/4e/22/be/4e22beef6d94640c45a1b15f4a158b23.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    userDetailsModel?.data?.name ?? "",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    userDetailsModel?.data?.mobile ?? "",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    userDetailsModel?.data?.address ?? "",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return OrdersPage();
                      }));
                    },
                    child: _buildOptionCard(
                      icon: Icons.shopping_bag_outlined,
                      label: 'Your Orders',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _showHelpDialog(context);
                    },
                    child: _buildOptionCard(
                      icon: Icons.help_outlined,
                      label: 'Need Help',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //_buildOptionCard(
                  //icon: Icons.card_giftcard,
                  //label: 'Coupons',
                  //),
                  //_buildOptionCard(
                  //icon: Icons.list_alt_sharp,
                  //label: 'Wishlist',
                  //),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  // Add logout functionality here
                },
                child: InkWell(
                  onTap: () {
                    // Navigate to the next page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Usertype()),
                    );

                    SharedPref().setUserLogin(false);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    height: screenHeight * 0.07,
                    width: screenWidth * 0.75,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 90, 101, 126),
                          blurRadius: 0,
                          spreadRadius: 1,
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 10),
                        Text(
                          'TAP HERE TO LOGOUT',
                          style: GoogleFonts.exo(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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

  Widget _buildOptionCard({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 90, 101, 126),
            blurRadius: 0,
            spreadRadius: 1,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.exo(
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    final TextEditingController subjectEditingController =
        TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Need Help?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 3),
              TextField(
                controller: subjectEditingController,
                maxLines: 1,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(),
                  hintText: "Enter subject.... ",
                ),
              ),
              SizedBox(height: 10),
              Text("Enter your issue or description below:"),
              SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Describe your issue here...",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final subject = subjectEditingController.text.trim();
                final description = descriptionController.text.trim();

                if (subject.isEmpty || description.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please fill in all fields."),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                try {
                  final userService =
                      UserService(); // Use the singleton instance

                  String? userpassword = await userService.getUserId();
                  print('$userpassword');
                  await ProductService().submitIssue(
                      userpassword.toString(), subject, description);

                  Navigator.of(context).pop(); // Close the dialog

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Issue submitted successfully!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text("Failed to submit the issue. Try again later."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }
}

void _showUpdateDialog(
    BuildContext context, nameController, mobileController, addressController,
    {Function()? callBack}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Update Details"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: mobileController,
                readOnly: true,
                decoration: InputDecoration(labelText: "Mobile"),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: "Address"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // Perform the update action
              print("Name: ${nameController.text}");
              print("Mobile: ${mobileController.text}");
              // print("Password: ${passwordController.text}");
              print("Address: ${addressController.text}");
              Navigator.of(context).pop();
              if (callBack != null) {
                callBack();
              }
            },
            child: Text("Update"),
          ),
        ],
      );
    },
  );
}
