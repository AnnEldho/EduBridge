import 'dart:convert';
import 'package:edubridge/addscholorship.dart';
import 'package:edubridge/addsponsorshiprequest.dart';
import 'package:edubridge/addcomplaint.dart';
import 'package:edubridge/mysponsorshiprequest.dart';
import 'package:edubridge/viewmycomplaints.dart';
import 'package:edubridge/viewscholorship.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NGODashboard extends StatefulWidget {
  const NGODashboard({super.key});

  @override
  State<NGODashboard> createState() => _NGODashboardState();
}

class _NGODashboardState extends State<NGODashboard> {
  final storage = FlutterSecureStorage();
  String name = "";
  String email = "";
  String approvalStatus = "Approved"; // Default status

  getUser() async {
    Map<String, String> allValues = await storage.readAll();
    var user = allValues['user'];
    var userMap = jsonDecode(user!);
    setState(() {
      name = userMap['name'];
      email = userMap['email'];
      approvalStatus = userMap['status'] ?? 'Approved';
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
        title: const Text('NGO Dashboard'),
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
                  name.isNotEmpty ? name[0].toUpperCase() : "",
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
                  _buildDrawerItem(Icons.school, "Add Scholarship", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddScholorshipPage()),
                    );
                  }),
                  _buildDrawerItem(Icons.visibility, "View Scholarship", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ViewScholorship()),
                    );
                  }),
                  _buildDrawerItem(Icons.send, "Send Sponsorship Request", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SponsorShipRequest()),
                    );
                  }),
                  _buildDrawerItem(Icons.inbox, "My Sponsorship Request", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MySponsorshipRequest()),
                    );
                  }),
                  _buildDrawerItem(Icons.report_problem, "Complaints", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddComplaintPage()),
                    );
                  }),
                  _buildDrawerItem(Icons.report_problem, " My Complaints", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ViewMyComplaint()),
                    );
                  }),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                  ),
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
      body: const Center(
        child: Text(
          "Welcome to the NGO Dashboard!",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
