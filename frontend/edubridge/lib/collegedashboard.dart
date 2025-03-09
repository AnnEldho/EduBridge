import 'dart:convert';
import 'package:edubridge/addscholorship.dart';
import 'package:edubridge/approvestudent.dart';
import 'package:edubridge/complaint.dart';
import 'package:edubridge/scholarship.dart';
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
      appBar: AppBar(title: Text('College Dashboard')),
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
              title: Text("Scholarship"),
              leading: Icon(
                Icons.school_sharp,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScholarshipPage()),
                );
              },
            ),
            ListTile(
                title: Text("Complaints"),
                leading: Icon(
                  Icons.phone,
                  color: Colors.black,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ComplaintPage()),
                  );
                }),
            ListTile(
                title: Text("Students"),
                leading: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ComplaintPage()),
                  );
                }),
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
            title: Text("Approve Students"),
            leading: Icon(
              Icons.people,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ApproveStudents()),
              );
            },
          ),
          ListTile(
            title: Text("Scholarship"),
            leading: Icon(
              Icons.school_sharp,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddScholorshipPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.view_list_sharp,
              color: Colors.black,
            ),
            title: const Text("View Scholarship"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewScholorship()),
              );
            },
          ),
        ],
      ),
    );
  }
}
