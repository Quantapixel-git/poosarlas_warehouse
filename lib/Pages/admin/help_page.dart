import 'dart:convert';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class NeedHelpAdminPage extends StatefulWidget {
  @override
  _NeedHelpAdminPageState createState() => _NeedHelpAdminPageState();
}

class _NeedHelpAdminPageState extends State<NeedHelpAdminPage> {
  List<Map<String, dynamic>> needHelpData = [];
  List<Map<String, dynamic>> _filteredHelpData = []; // List for filtered data
  bool isLoading = true;
  String errorMessage = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchNeedHelpData();
    _searchController
        .addListener(_filterHelpRequests); // Add listener for search
  }

  Future<void> _fetchNeedHelpData() async {
    final url = Uri.parse(
        'https://quantapixel.in/ecommerce/grocery_app/public/api/helps');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data'] is List) {
          setState(() {
            needHelpData = List<Map<String, dynamic>>.from(data['data']);
            _filteredHelpData = needHelpData; // Initially show all data
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'No help requests found.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load data: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  // Function to filter help requests based on ID
  void _filterHelpRequests() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredHelpData = needHelpData; // Show all data if search is empty
      } else {
        _filteredHelpData = needHelpData
            .where((item) => item['user_id']
                .toString()
                .contains(query)) // Convert ID to String for comparison
            .toList();
      }
    });
  }

  String formatDate(String? date) {
    if (date == null) return 'N/A';
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedDate);
    } catch (e) {
      return 'Invalid date';
    }
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose the controller to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text(
          'Need Help Requests',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by Help Request ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child:
                        CircularProgressIndicator()) // Show loading spinner while fetching
                : errorMessage.isNotEmpty
                    ? Center(
                        child: Text(
                            errorMessage)) // Show error message if any error occurs
                    : _filteredHelpData.isEmpty
                        ? Center(
                            child: Text(
                                'No help requests match your search criteria.'))
                        : ListView.builder(
                            itemCount: _filteredHelpData.length,
                            itemBuilder: (context, index) {
                              final helpRequest = _filteredHelpData[index];
                              final userDetails = helpRequest['user_details'];
                              return Card(
                                margin: EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'User ID: ${helpRequest['user_id'] ?? 'N/A'}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        'Request By: ${helpRequest['name'] ?? 'N/A'}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Subject: ${helpRequest['subject'] ?? 'N/A'}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                          'Description: ${helpRequest['description'] ?? 'N/A'}'),
                                      SizedBox(height: 8),
                                      if (userDetails != null) ...[
                                        Text(
                                            'User: ${userDetails['name'] ?? 'N/A'}'),
                                        Text(
                                            'Email: ${userDetails['email'] ?? 'N/A'}'),
                                        Text(
                                            'Order ID: ${userDetails['order_id'] ?? 'N/A'}'),
                                      ],
                                      SizedBox(height: 8),
                                      Text(
                                          'Created At: ${formatDate(helpRequest['created_at'])}'),
                                      Text(
                                          'Updated At: ${formatDate(helpRequest['updated_at'])}'),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
