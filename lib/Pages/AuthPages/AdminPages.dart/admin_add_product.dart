import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

class AdminAddProduct extends StatefulWidget {
  const AdminAddProduct({super.key});

  @override
  State<AdminAddProduct> createState() => _AdminAddProductState();
}

class _AdminAddProductState extends State<AdminAddProduct> {
  final ImagePicker _picker = ImagePicker();
  File? SelectedImage;
  TextEditingController productnamecontroller = new TextEditingController();
  TextEditingController productdescriptioncontroller =
      new TextEditingController();
  TextEditingController productpricecontroller = new TextEditingController();
  Future getImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      SelectedImage = File(image.path);
      setState(() {});
    } else {
      // Handle the case where no image is selected
      print('No image selected');
    }
  }

  final List<String> CategoryItem = [
    'Select a Category',
    'Cold Drinks and Shakes',
    'Fruits and Vegetables',
    'Detergents and Soaps',
    'Baby Care',
    'Snacks',
    'Pet Care',
    'Atta and Rice',
    'Tea and Coffee',
    'Medicine',
  ];
  String SelectedValue = 'Select a Category';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  // borderRadius: BorderRadius.circular(15),
                ),
                width: double.infinity,
                child: Text(
                  'ADD PRODUCT',
                  style: GoogleFonts.exo(
                      fontSize: 30, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                  child: SelectedImage == null
                      ? GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Container(
                            height: 155,
                            width: 155,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 131, 131, 131),
                                    width: 5)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Icon(
                                  Icons.camera_alt_outlined,
                                  color:
                                      const Color.fromARGB(255, 106, 106, 106),
                                  size: 80,
                                ),
                                Text(
                                  'Click to Add Image',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(20),
                          child: GestureDetector(
                            onTap: () {
                              SelectedImage = null;
                              getImage();
                            },
                            child: Container(
                              height: 155,
                              width: 155,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 131, 131, 131),
                                      width: 5)),
                              child: Image.file(
                                SelectedImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ))),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: EdgeInsets.only(left: 10, right: 10),
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    DropdownButtonHideUnderline(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: DropdownButton<String>(
                          iconSize: 50,
                          menuWidth: double.infinity,
                          dropdownColor: Colors.white,
                          iconEnabledColor: Colors.grey,
                          iconDisabledColor: Colors.white,
                          value:
                              SelectedValue, // selectedValue should be a state variable
                          onChanged: (String? newValue) {
                            setState(() {
                              SelectedValue =
                                  newValue!; // Update the selected value
                            });
                          },
                          items: CategoryItem.map((String categoryItem) {
                            return DropdownMenuItem<String>(
                              value: categoryItem, // Assign the correct value
                              child: Text(
                                categoryItem,
                                style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        const Color.fromARGB(255, 75, 75, 75)),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 60,
                margin: EdgeInsets.only(right: 10, left: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextField(
                    controller: productnamecontroller,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Product Name',
                        hintStyle: TextStyle(fontSize: 20),
                        labelText: 'Enter Product Name',
                        labelStyle: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 100,
                margin: EdgeInsets.only(right: 10, left: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextField(
                    controller: productdescriptioncontroller,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Product Description',
                        hintStyle: TextStyle(fontSize: 20),
                        labelText: 'Enter Product Description',
                        labelStyle: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 60,
                margin: EdgeInsets.only(right: 10, left: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextField(
                    controller: productpricecontroller,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Product Price (in \$)',
                        hintStyle: TextStyle(fontSize: 20),
                        labelText: 'Enter Product Price (in \$)',
                        labelStyle: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      child: Text(
                        ' Add Product',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                margin: EdgeInsets.symmetric(horizontal: 100),
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 2, spreadRadius: 1, color: Colors.black)
                    ],
                    borderRadius: BorderRadius.circular(70),
                    color: const Color.fromARGB(255, 211, 71, 83)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
