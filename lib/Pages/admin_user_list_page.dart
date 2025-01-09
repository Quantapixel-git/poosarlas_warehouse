import 'package:flutter/material.dart';

class AdminUserListPage extends StatefulWidget {
  @override
  _AdminUserListPageState createState() => _AdminUserListPageState();
}

class _AdminUserListPageState extends State<AdminUserListPage> {
  // Sample data for customer details
  List<Map<String, String>> customerList = [
    {
      'name': 'John Doe',
      'mobile': '9876543210',
      'address': '123 Elm Street, NY',
      'createdAt': '2023-12-01 10:30 AM',
    },
    {
      'name': 'Jane Smith',
      'mobile': '8765432109',
      'address': '456 Oak Avenue, CA',
      'createdAt': '2023-12-02 03:45 PM',
    },
    {
      'name': 'Alice Johnson',
      'mobile': '7654321098',
      'address': '789 Maple Lane, TX',
      'createdAt': '2023-12-03 08:15 AM',
    },
    // Add more entries as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: customerList.length,
        itemBuilder: (context, index) {
          final customer = customerList[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${customer['name'] ?? ''}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 6.0),
                  Text('Mobile: ${customer['mobile'] ?? ''}'),
                  SizedBox(height: 6.0),
                  Text('Address: ${customer['address'] ?? ''}'),
                  SizedBox(height: 6.0),
                  Text(
                    'Created At: ${customer['createdAt'] ?? ''}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      home: AdminUserListPage(),
    ));
