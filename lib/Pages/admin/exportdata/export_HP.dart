import 'package:e_commerce_grocery_application/Widgets/calenderwidget.dart';
import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ExportHp extends StatefulWidget {
  const ExportHp({super.key});

  @override
  State<ExportHp> createState() => _ExportHpState();
}

class _ExportHpState extends State<ExportHp> {
  TextEditingController _dateController = TextEditingController();

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    // If a date is selected, format it and update the TextField
    if (selectedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      _dateController.text = formattedDate; // Update the TextField
    }
  }

  String getFormattedDate() {
    final now = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(now);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
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
                        'Export Data',
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
          SizedBox(
            height: screenHeight * 0.03,
          ),
          Center(
            child: Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.07,
                child: ElevatedButton(
                    onPressed: () {
                      // 2025-01-02
                      launch(
                          'https://quantapixel.in/ecommerce/grocery_app/public/export?date=${getFormattedDate().toString()}');
                      print(DateTime.now());
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 0, 255, 30),
                        foregroundColor: Colors.black),
                    child: Text(
                      'Export Today\'s Data',
                      style: GoogleFonts.exo(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w600),
                    ))),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '(Click to Generate PDF)',
            style: GoogleFonts.exo(
                fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: screenHeight * 0.03,
          ),
          const Divider(),
          SizedBox(
            height: screenHeight * 0.05,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15), // Increased horizontal padding
              child: Container(
                width: screenWidth * 0.88,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextField(
                        readOnly: true,
                        controller:
                            _dateController, // Controller for the TextField
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Select Date',
                          labelStyle: GoogleFonts.aBeeZee(color: Colors.grey),
                          prefixIcon:
                              Icon(Icons.calendar_today), // Calendar icon
                          // Open calendar when pressed
                        ),
                      ),
                    ),
                  ),
                ),
              )),
          SizedBox(
            height: screenHeight * 0.03,
          ),
          Center(
            child: Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.07,
                child: ElevatedButton(
                    onPressed: () {
                      _dateController.text == null
                          ? ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Please Select Date First"),
                                backgroundColor: Colors.red,
                              ),
                            )
                          : launch(
                              'https://quantapixel.in/ecommerce/grocery_app/public/export?date=${_dateController.text.trim().toString()}');
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 237, 36),
                        foregroundColor: Colors.black),
                    child: Text(
                      'Export Data for this date',
                      style: GoogleFonts.exo(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w600),
                    ))),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '(Click to Generate PDF)',
            style: GoogleFonts.exo(
                fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
