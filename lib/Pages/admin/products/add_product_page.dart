import 'dart:io';
import 'package:e_commerce_grocery_application/Pages/model_category.dart/model_category.dart';
import 'package:e_commerce_grocery_application/services/category_api_services.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:flutter_quill/flutter_quill.dart' as quill;

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  File? additionalImage1;
  File? additionalImage2;

  bool _isLoading = false;
  ModelCategory? selectedValue;
  Future<List<ModelCategory>>? _categoriesFuture;

  // Controllers for the fields
  TextEditingController categoryIdController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productDiscountController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController Deliverycharge = TextEditingController();

  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController productshortDescriptionController =
      TextEditingController();
  //final quillController = quill.QuillController.basic();
  // Function to pick an image
  Future<void> pickImage({required int imageIndex}) async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 25,
      );

      if (image != null) {
        final File selectedFile = File(image.path);
        final int fileSizeInBytes = await selectedFile.length();
        const int maxFileSizeInBytes = 2048 * 1024; // 2 MB

        if (fileSizeInBytes <= maxFileSizeInBytes) {
          setState(() {
            if (imageIndex == 0) {
              selectedImage = selectedFile;
            } else if (imageIndex == 1) {
              additionalImage1 = selectedFile;
            } else if (imageIndex == 2) {
              additionalImage2 = selectedFile;
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'File size exceeds 2 MB! Please select a smaller image.')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  @override
  void initState() {
    _categoriesFuture = CategoryApiServices().fetchCategories();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 235, 235, 41),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<ModelCategory>>(
          future: _categoriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (snapshot.hasData) {
              final categories = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDropdown<ModelCategory>(
                      items: categories,
                      selectedValue: selectedValue,
                      hintText: "Select a Category",
                      lable: "Category",
                      itemDisplay: (product) =>
                          product.name, // Display product name
                      onChanged: (newProduct) {
                        setState(() {
                          selectedValue = newProduct;
                        });
                      },
                    ),

                    _buildTextField(
                      controller: productNameController,
                      label: "Product Name",
                      hintText: "Enter Product Name",
                    ),
                    _buildTextField(
                        controller: productPriceController,
                        label: "Product Price",
                        inputRegex: r'^\d*\.?\d*$',
                        hintText: "Enter Product Price",
                        textInputType: TextInputType.number),
                    _buildTextField(
                        controller: productDiscountController,
                        label: "Product Discount in %",
                        inputRegex: r'^\d*\.?\d*$',
                        hintText: "Enter Discount (if any %)",
                        textInputType: TextInputType.number),
                    _buildTextField(
                      controller: stockController,
                      label: "Stock Quantity",
                      textInputType: TextInputType.text,
                      hintText: "Enter Stock Quantity",
                    ),
                    _buildTextField(
                      controller: Deliverycharge,
                      label: "Delivery Charge",
                      textInputType: TextInputType.text,
                      hintText: "Enter Delivery Charge",
                    ),
                    _buildTextField(
                      controller: productshortDescriptionController,
                      label: "Short Description",
                      textInputType: TextInputType.text,
                      hintText: "Enter Short Description",
                    ),

                    // RichTextEditor(
                    //   controller: quillController,
                    //   label: 'Product Description',
                    // ),
                     _buildTextField(
                      maxLine: 4,
                      controller: productDescriptionController,
                      label: "Product Description",
                      hintText: "Enter Dcription",
                      textInputType: TextInputType.multiline
                     ),
                    const SizedBox(height: 20),
                    _buildImagePicker(
                      onRemoveImage: () => setState(() => selectedImage = null),
                      label: "Main Product Image (Required)",
                      selectedFile: selectedImage,
                      onPickImage: () => pickImage(imageIndex: 0),
                      isRequired: true,
                    ),
                    _buildImagePicker(
                      onRemoveImage: () =>
                          setState(() => additionalImage1 = null),
                      label: "Additional Image 1 (Optional)",
                      selectedFile: additionalImage1,
                      onPickImage: () => pickImage(imageIndex: 1),
                      isRequired: false,
                    ),
                    _buildImagePicker(
                      onRemoveImage: () =>
                          setState(() => additionalImage2 = null),
                      label: "Additional Image 2 (Optional)",
                      selectedFile: additionalImage2,
                      onPickImage: () => pickImage(imageIndex: 2),
                      isRequired: false,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            } else {
              // Add a default return widget for unhandled cases
              return const Center(
                child: Text(
                  'No data available',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GestureDetector(
          onTap: _isLoading ? null : _addProduct,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.07,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color.fromARGB(255, 255, 237, 36),
            ),
            child: Center(
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : Text(
                      "Add Product",
                      style: GoogleFonts.merriweather(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    int maxLine=1,
    String inputRegex = r'.*',
    TextInputType textInputType = TextInputType.name,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        maxLines: maxLine,
        keyboardType: textInputType,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
              RegExp(inputRegex)), // Use regex to filter input
        ],
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required List<T> items, // List of dropdown items
    required T? selectedValue, // Currently selected value
    required ValueChanged<T?> onChanged, // Callback for value changes
    required String hintText, // Placeholder text
    required String lable, // Label text
    String Function(T)? itemDisplay, // Optional function to display item text
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<T>(
        value: selectedValue,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: lable,
          border: OutlineInputBorder(),
        ),
        items: items.map((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(
              itemDisplay != null ? itemDisplay(value) : value.toString(),
            ), // Display customized or default text
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildImagePicker({
    required String label,
    required File? selectedFile,
    required VoidCallback onPickImage,
    required VoidCallback onRemoveImage,
    required bool isRequired,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color:
                isRequired && selectedFile == null ? Colors.red : Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onPickImage,
          child: Stack(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isRequired && selectedFile == null
                        ? Colors.red
                        : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: selectedFile == null
                    ? const Center(
                        child: Icon(
                          Icons.add_a_photo,
                          size: 50,
                          color: Colors.grey,
                        ),
                      )
                    : Image.file(
                        selectedFile,
                        fit: BoxFit.cover,
                      ),
              ),
              if (selectedFile != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: onRemoveImage,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Future<void> _addProduct() async {
    if (selectedValue == null ||
        productNameController.text.isEmpty ||
        productPriceController.text.isEmpty ||
        //productshortDescriptionController.text.isEmpty ||
        Deliverycharge.text.isEmpty ||
        stockController.text.isEmpty ||
        selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Parse numeric values
      final productPrice = double.tryParse(productPriceController.text) ?? 0.0;
      final productDiscount =
          double.tryParse(productDiscountController.text) ?? 0.0;
      final stock = int.tryParse(stockController.text) ?? 0;

      final response = await ProductService().addProduct(
        productImage: selectedImage!,
        additionalImage1: additionalImage1,
        additionalImage2: additionalImage2,
        categoryId: selectedValue!.id.toString(),
        productName: productNameController.text,
        Deliverycharge: Deliverycharge.text,
        productPrice: productPrice.toString(), // Ensure it's a valid number
        productDiscount:
            productDiscount.toString(), // Ensure it's a valid number
        stock: stock.toString(), // Ensure it's a valid integer
        productShortDescription:
            productshortDescriptionController.text.toString(),
productDescription:productDescriptionController.text
       // productDescription:
          //  jsonEncode(quillController.document.toDelta().toJson()),
      );

      if (response != null) {
        print("Response Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
      }

      if (response?.statusCode == 200 || response?.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to add product. Status: ${response?.statusCode}')),
        );
      }
    } catch (e) {
      print("Error in adding product: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
