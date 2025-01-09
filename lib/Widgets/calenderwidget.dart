import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // For date formatting

class CalendarTextField extends StatefulWidget {
  @override
  _CalendarTextFieldState createState() => _CalendarTextFieldState();
}

class _CalendarTextFieldState extends State<CalendarTextField> {
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
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
                  controller: _dateController, // Controller for the TextField
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Select Date',
                    labelStyle: GoogleFonts.aBeeZee(color: Colors.grey),
                    prefixIcon: Icon(Icons.calendar_today), // Calendar icon
                    // Open calendar when pressed
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
