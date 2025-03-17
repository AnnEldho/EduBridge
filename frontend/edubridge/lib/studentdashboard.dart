import 'dart:convert';
import 'package:edubridge/addcomplaint.dart';
import 'package:edubridge/joinedscholorship.dart';
import 'package:edubridge/viewallnotification.dart';
import 'package:edubridge/viewallscholorship.dart';
import 'package:edubridge/viewmycomplaints.dart';
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
        actions: [
          IconButton(
            icon: Icon(Icons.notifications), // Bell icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewAllNotification()),
              );
              // Add your notification handling logic here
              print("Notifications Clicked");
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(name),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                child: Text(
                  name.length > 0 ? name[0] : "",
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            if (approvalStatus == 'Approved') ...[
              // Show full dashboard only if student is approved
              ListTile(
                title: Text("Scholarship"),
                leading: Icon(Icons.school, color: Colors.black),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewAllScholorship()),
                  );
                },
              ),
              ListTile(
                title: Text("My Scholarship"),
                leading: Icon(Icons.manage_search_rounded, color: Colors.black),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewJoinedScholorship()),
                  );
                },
              ),
              ListTile(
                title: Text("Sponsorship"),
                leading: Icon(Icons.monetization_on, color: Colors.black),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewSponsorship()),
                  );
                },
              ),
              ListTile(
                title: Text("Complaints"),
                leading: Icon(Icons.report_problem, color: Colors.black),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddComplaintPage()),
                  );
                },
              ),
              ListTile(
                title: Text("My Complaints"),
                leading: Icon(Icons.report_problem, color: Colors.black),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewMyComplaint()),
                  );
                },
              ),
            ] else ...[
              // Show a restricted message if student is NOT approved
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Your account is not yet approved by the college.\nPlease wait for approval.",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            Divider(),
            ListTile(
              title: Text("Logout"),
              leading: Icon(Icons.logout, color: Colors.black),
              onTap: () async {
                await storage.delete(key: "user");
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
