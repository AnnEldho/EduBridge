import 'dart:convert';

import 'package:edubridge/joinedscholorship.dart';
import 'package:edubridge/viewallscholorship.dart';
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
      appBar: AppBar(title: Text('Student Dashboard')),
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
            ListTile(
              title: Text("Home"),
              leading: Icon(
                Icons.home,
                color: Colors.black,
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text("About"),
              leading: Icon(
                Icons.help,
                color: Colors.black,
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text("Phone"),
              leading: Icon(
                Icons.phone,
                color: Colors.black,
              ),
              onTap: () {},
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
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.school),
            title: const Text("Scholarship"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewAllScholorship()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.manage_search_rounded),
            title: const Text("My Scholarship"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewJoinedScholorship()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.monetization_on),
            title: const Text("Sponsorship"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewSponsorship()),
              );
            },
          ),
        ],
      ),
    );
  }
}
