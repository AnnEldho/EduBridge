import 'dart:convert';

import 'package:edubridge/addscholorship.dart';
import 'package:edubridge/addsponsorshiprequest.dart';
import 'package:edubridge/addcomplaint.dart';
import 'package:edubridge/mysponsorshiprequest.dart';
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
        appBar: AppBar(title: Text('NGO Dashboard')),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
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
              ListTile(
                leading: Icon(Icons.home, color: Colors.black),
                title: Text("Home"),
                onTap: () {
                  // Handle home tap
                },
              ),
              ListTile(
                leading: Icon(Icons.school, color: Colors.black),
                title: Text("Add Scholarship"),
                onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddScholorshipPage()),
                );
              },
              ),
              ListTile(
                leading: Icon(Icons.visibility, color: Colors.black),
                title: Text("View Scholarship"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewScholorship()),
                  );
                },
                
              ),
              ListTile(
                leading: Icon(Icons.send, color: Colors.black),
              title: const Text("Send Sponsorship Request"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SponsorShipRequest()),
                );
              },
            ),
              
              ListTile(
                leading: Icon(Icons.inbox, color: Colors.black),
              title: const Text("My Sponsorship Request"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MySponsorshipRequest()),
                );
              },
              ),
              ListTile(
            leading: Icon(
              Icons.report_problem,
              color: Colors.black,
            ),
            title: const Text("Complaints "),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddComplaintPage()),
              );
            },
          ),
              ListTile(
                title: Text("Logout"),
                leading: Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
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

void main() {
  runApp(MaterialApp(
    home: NGODashboard(),
  ));
}
