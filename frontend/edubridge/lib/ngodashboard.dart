import 'dart:convert';

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
              leading: Icon(Icons.people, color: Colors.black),
              title: Text("Beneficiaries"),
              onTap: () {
                // Handle beneficiaries tap
              },
            ),
            ListTile(
              leading: Icon(Icons.event, color: Colors.black),
              title: Text("Events"),
              onTap: () {
                // Handle events tap
              },
            ),
            ListTile(
              leading: Icon(Icons.volunteer_activism, color: Colors.black),
              title: Text("Volunteers"),
              onTap: () {
                // Handle volunteers tap
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.black),
              title: Text("Settings"),
              onTap: () {
                // Handle settings tap
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
      body: Center(
        child: Text('Welcome to the NGO Dashboard!'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NGODashboard(),
  ));
}