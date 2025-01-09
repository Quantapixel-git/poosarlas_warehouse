import 'package:e_commerce_grocery_application/Pages/admin/users/admin_add_user.dart';
import 'package:e_commerce_grocery_application/Pages/admin/users/edit_user_page.dart';
import 'package:e_commerce_grocery_application/Pages/models/user_details_model.dart';
import 'package:e_commerce_grocery_application/Pages/models/user_model.dart';
import 'package:e_commerce_grocery_application/Widgets/bottom_with_icon_title_widget.dart';
import 'package:e_commerce_grocery_application/global_variable.dart';
import 'package:e_commerce_grocery_application/services/product_api_services.dart';
import 'package:e_commerce_grocery_application/utils/app_colors.dart';
import 'package:e_commerce_grocery_application/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UsersListPage extends StatefulWidget {
  const UsersListPage({super.key});

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  bool _isLoading = false;
  List<User> _allUsers = [];
  List<User> _filteredUsers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUsersList();
    _searchController.addListener(_filterUsers);
  }

  void _getUsersList() async {
    try {
      final usersearch = await ProductService().fetchUsersList();
      setState(() {
        _allUsers = usersearch;
        _filteredUsers = usersearch; // Initially display all users
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
    }
  }

  void _filterUsers() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredUsers = _allUsers;
      } else {
        _filteredUsers = _allUsers
            .where((item) => item.id.toString().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          _appBarView(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by User ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _filteredUsers.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: EdgeInsets.all(0),
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: screenHeight * 0.21,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Username: ${user.name}',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'ID: ${user.id}',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Address: ${user.address}',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Mobile: ${user.mobile}',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          'Updated at: ${formatDate(user.createdAt)}',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 10,
                                  right: 50,
                                  child: InkWell(
                                    onTap: () async {
                                      bool? confirmblock = await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title:
                                              const Text("Update User Status"),
                                          content: Text(
                                              "Are you sure you want to change the Status of ${user.name}?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: const Text("ACTIVE"),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: const Text("INACTIVE"),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirmblock == true) {
                                        await ProductService().updateUserStatus(
                                            user.id, 'INACTIVE');

                                        // ? "INACTIVE"
                                        // : "ACTIVE");

                                        setState(() {
                                          _getUsersList();
                                        });
                                      }
                                      if (confirmblock == false) {
                                        await ProductService().updateUserStatus(
                                            user.id, 'ACTIVE');

                                        // ? "INACTIVE"
                                        // : "ACTIVE");

                                        setState(() {
                                          _getUsersList();
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: 30,
                                      width: screenWidth * 0.2,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              width: 1,
                                              color: user.status == "ACTIVE"
                                                  ? Colors.green
                                                  : const Color.fromARGB(
                                                      255, 255, 0, 0))),
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Text(
                                          user.status,

                                          //category.isActive?

                                          //"Active":'In Active',
                                          style: TextStyle(
                                              color: user.status == "ACTIVE"
                                                  ? Colors.green
                                                  : const Color.fromARGB(
                                                      255, 255, 0, 0),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: InkWell(
                                    onTap: () {
                                      _showBottomOptions(context, user);
                                    },
                                    child: Icon(Icons.more_horiz_rounded),
                                  ),
                                ),
                              ],
                            ),
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

  _appBarView() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.mainColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.navigate_before,
                      size: 35, color: Color.fromARGB(255, 0, 0, 0)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Text(
                  'Users List',
                  style: GoogleFonts.notoSerif(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.add_circle_sharp,
                  size: 36, color: const Color.fromARGB(255, 0, 0, 0)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminAddUser(flag: false),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomOptions(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Wrap(
            children: [
              buildBottomWithTitleIconWidget(
                context: context,
                Imageicon: 'assets/edit.png',
                title: 'Edit User',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditUserPage(
                          id: user.id.toString(),
                          address: user.address,
                          mobile: user.mobile,
                          name: user.name),
                    ),
                  ).then((val) {
                    _getUsersList();
                  });
                },
              ),
              buildBottomWithTitleIconWidget(
                context: context,
                Imageicon: 'assets/delete_user.png',
                title: 'Delete User',
                onTap: () async {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Are you sure?'),
                        content: Text('Do you want to delete this user?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await ProductService()
                                  .deleteUser(context, user.id.toString());
                              _getUsersList();
                              Navigator.of(context).pop();
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
