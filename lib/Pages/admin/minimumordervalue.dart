import 'package:e_commerce_grocery_application/services/login_api_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Minimumordervalue extends StatefulWidget {
  const Minimumordervalue({super.key});

  @override
  State<Minimumordervalue> createState() => _MinimumordervalueState();
}

class _MinimumordervalueState extends State<Minimumordervalue> {
  final TextEditingController minorderController = TextEditingController();

  void updateMinOrderValue() async {
    final String minOrder = minorderController.text;

    if (minOrder.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a Minimum Order Value."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await ApiService().updateMinOrder("1", minOrder);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Minimum Order Value updated successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void fetchMinOrderValue() async {
    try {
      final response = await ApiService().getMinOrder();
      if (response['status'] == 1) {
        final minOrder =
            double.parse(response['data'][0]['min_order'].toString());
        //

        setState(() {
          minorderController.text = minOrder.toString();
        });
      } else {
        throw Exception(
            response['message'] ?? 'Failed to fetch minimum order value');
      }
    } catch (e) {
      print('Error fetching minimum order value: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to fetch minimum order value.')),
      );
      return;
    }
  }

  @override
  void initState() {
    fetchMinOrderValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          // Header Section
          Container(
            height: screenHeight * 0.2,
            width: screenWidth,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 237, 36),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                          size: 22,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Navigate back
                        },
                      ),
                      Text(
                        'Set Minimum Order',
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 48.0),
                    child: Text(
                      'Admin Panel',
                      style: GoogleFonts.poppins(
                        color: const Color.fromARGB(179, 0, 0, 0),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Input Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              width: screenWidth * 0.88,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: TextField(
                  controller: minorderController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Minimum Order Value',
                    labelStyle: GoogleFonts.aBeeZee(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Submit Button
          Center(
            child: SizedBox(
              width: screenWidth * 0.8,
              height: screenHeight * 0.07,
              child: ElevatedButton(
                onPressed: updateMinOrderValue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 237, 36),
                  foregroundColor: Colors.black,
                ),
                child: Text(
                  'Set Minimum Order Value',
                  style: GoogleFonts.exo(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
