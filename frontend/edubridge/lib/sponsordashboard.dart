import 'dart:convert';
import 'package:edubridge/approvesponsorrequest.dart';
import 'package:edubridge/addcomplaint.dart';
import 'package:edubridge/editprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SponsorDashboard extends StatefulWidget {
  const SponsorDashboard({super.key});

  @override
  State<SponsorDashboard> createState() => _SponsorDashboardState();
}

class _SponsorDashboardState extends State<SponsorDashboard> {
  final storage = FlutterSecureStorage();
  String name = "";
  String email = "";
  String approvalStatus =
      'Approved'; // Add this if you're doing conditional rendering

  getUser() async {
    Map<String, String> allValues = await storage.readAll();
    var user = allValues['user'];
    var userMap = jsonDecode(user!);
    setState(() {
      name = userMap['name'];
      email = userMap['email'];
      approvalStatus = userMap['status'] ?? 'Approved'; // Optional field
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
        title: const Text('Sponsor Dashboard'),
        backgroundColor: const Color.fromARGB(255, 101, 121, 220),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                email,
                style: const TextStyle(fontSize: 14),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  name.isNotEmpty ? name[0] : "",
                  style: const TextStyle(
                    fontSize: 40,
                    color: Color.fromARGB(255, 101, 121, 220),
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 101, 121, 220),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  if (approvalStatus == 'Approved') ...[
                    _buildDrawerItem(Icons.school_sharp, "Edit Profile", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditSponsorProfile()),
                      );
                    }),
                    _buildDrawerItem(Icons.report_problem, "Complaints", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddComplaintPage()),
                      );
                    }),
                    _buildDrawerItem(Icons.question_answer, "View Requests",
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ApproveSponsorRequest()),
                      );
                    }),
                  ] else ...[
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "You are not approved yet. Please wait for admin approval.",
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
