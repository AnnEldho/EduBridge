import 'dart:convert';
import 'package:edubridge/addcomplaint.dart';
import 'package:edubridge/addscholorship.dart';
import 'package:edubridge/addsponsorshiprequest.dart';
import 'package:edubridge/approvestudent.dart';
import 'package:edubridge/change_password.dart';
import 'package:edubridge/joinedscholorship.dart';
import 'package:edubridge/mysponsorshiprequest.dart';
import 'package:edubridge/viewallnotification.dart';
import 'package:edubridge/viewallscholorship.dart';
import 'package:edubridge/viewmycomplaints.dart';
import 'package:edubridge/viewscholorship.dart';
import 'package:edubridge/viewsponsorships.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Studentdashboard extends StatefulWidget {
  const Studentdashboard({super.key});

  @override
  State<Studentdashboard> createState() => _StudentdashboardState();
}

class _StudentdashboardState extends State<Studentdashboard> {
  final storage = FlutterSecureStorage();
  String name = "";
  String email = "";
  String approvalStatus = "";

  getUser() async {
    print("Getting User");
    Map<String, String> allValues = await storage.readAll();
    var user = allValues['user'];
    print(user);

    var userMap = jsonDecode(user!);
    print(userMap);

    setState(() {
      name = userMap['name'];
      email = userMap['email'];
      approvalStatus = userMap['status']; // Fetch approval status
    });
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
        title: Text('Student Dashboard'),
        backgroundColor: const Color.fromARGB(255, 101, 121, 220),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Color.fromARGB(255, 11, 11, 11),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewAllNotification()),
              );
            },
          ),
        ],
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
                  if (approvalStatus == 'Approved') ...[
                    _buildDrawerItem(Icons.school_sharp, "Edit Profile", () {}),
                    _buildDrawerItem(Icons.school_sharp, "Scholarship", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewAllScholorship()),
                      );
                    }),
                    _buildDrawerItem(Icons.people, "My Scholarship", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewJoinedScholorship()),
                      );
                    }),
                    _buildDrawerItem(Icons.people, "Send Sponsorship Request",
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SponsorShipRequest()),
                      );
                    }),
                    _buildDrawerItem(Icons.people, "My Sponsorship Request",
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MySponsorshipRequest()),
                      );
                    }),
                    _buildDrawerItem(Icons.report_problem, "Complaints", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddComplaintPage()),
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
      title: Text(title),
      onTap: onTap,
    );
  }
}
