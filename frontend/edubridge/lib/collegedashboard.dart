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
      appBar: AppBar(title: Text('College Dashboard')),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(name),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                child: Text(
                  name.isNotEmpty ? name[0] : "",
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            if (isApproved) ...[
              ListTile(
                title: Text("Edit Profile"),
                leading: Icon(Icons.school_sharp),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
              ),
              ListTile(
                title: Text("Scholarship"),
                leading: Icon(Icons.school_sharp),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddScholorshipPage()),
                  );
                },
              ),
              ListTile(
                title: Text("Approve Students"),
                leading: Icon(Icons.people),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ApproveStudents()),
                  );
                },
              ),
              ListTile(
                title: Text("Complaints"),
                leading: Icon(Icons.report_problem),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddComplaintPage()),
                  );
                },
              ),
              ListTile(
                title: Text("View Scholarship"),
                leading: Icon(Icons.view_list_sharp),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewScholorship()),
                  );
                },
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Your college is not approved yet. Please wait for approval .",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
            ],
            ListTile(
              title: Text("Logout"),
              leading: Icon(Icons.logout),
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
