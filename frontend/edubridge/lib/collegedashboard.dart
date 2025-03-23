import 'dart:convert';
import 'package:edubridge/addscholorship.dart';
import 'package:edubridge/approvestudent.dart';
import 'package:edubridge/addcomplaint.dart';
import 'package:edubridge/college_profile.dart';
import 'package:edubridge/viewscholorship.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Collegedashboard extends StatefulWidget {
  const Collegedashboard({super.key});

  @override
  State<Collegedashboard> createState() => _CollegedashboardState();
}

class _CollegedashboardState extends State<Collegedashboard> {
  final storage = FlutterSecureStorage();
  String name = "";
  String email = "";
  bool isApproved = false;

  getUser() async {
    Map<String, String> allValues = await storage.readAll();
    var user = allValues['user'];
    if (user != null) {
      var userMap = jsonDecode(user);
      setState(() {
        name = userMap['name'];
        email = userMap['email'];
        isApproved = userMap['status'] == 'Approved';
      });
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('College Dashboard'),
        backgroundColor: const Color.fromARGB(
            255, 101, 121, 220), // Change this to your desired color
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                email,
                style: TextStyle(fontSize: 14),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  name.isNotEmpty ? name[0] : "",
                  style: TextStyle(
                    fontSize: 40,
                    color: Color.fromARGB(255, 101, 121, 220),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 101, 121, 220),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  if (isApproved) ...[
                    _buildDrawerItem(Icons.school_sharp, "Edit Profile", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    }),
                    _buildDrawerItem(Icons.school_sharp, "Scholarship", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddScholorshipPage()),
                      );
                    }),
                    _buildDrawerItem(Icons.people, "Approve Students", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ApproveStudents()),
                      );
                    }),
                    _buildDrawerItem(Icons.report_problem, "Complaints", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddComplaintPage()),
                      );
                    }),
                    _buildDrawerItem(Icons.view_list_sharp, "View Scholarship",
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewScholorship()),
                      );
                    }),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Your college is not approved yet. Please wait for approval.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Divider(),
            _buildDrawerItem(Icons.logout, "Logout", () async {
              await storage.delete(key: "user");
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login', (Route<dynamic> route) => false);
            }, iconColor: Colors.red),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap,
      {Color iconColor = Colors.black}) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
