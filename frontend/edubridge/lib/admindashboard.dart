import 'package:edubridge/addnotification.dart';
import 'package:edubridge/college_list.dart';
import 'package:edubridge/ngo-register.dart';
import 'package:edubridge/sponsor_list.dart';
import 'package:edubridge/viewallcomplaint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Admindashboard extends StatefulWidget {
  const Admindashboard({super.key});

  @override
  State<Admindashboard> createState() => _Admindashboard();
}

class _Admindashboard extends State<Admindashboard> {
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Color.fromARGB(255, 101, 121, 220),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("Admin",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              accountEmail:
                  const Text("admin@gmail.com", style: TextStyle(fontSize: 14)),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Text("A",
                    style: TextStyle(
                        fontSize: 40,
                        color: Color.fromARGB(255, 101, 121, 220))),
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 101, 121, 220),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildDrawerItem(Icons.home, "Home", () {}),
                  _buildDrawerItem(Icons.info, "About", () {}),
                  _buildDrawerItem(Icons.people, "Sponsors",
                      () => _navigateTo(context, SponsorList())),
                  _buildDrawerItem(Icons.notifications, "Add Notifications",
                      () => _navigateTo(context, AddNotificationPage())),
                  _buildDrawerItem(Icons.business, "Add NGO",
                      () => _navigateTo(context, NGORegistrationForm())),
                  _buildDrawerItem(Icons.report, "View Complaints",
                      () => _navigateTo(context, ViewAllComplaint())),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Admin Dashboard!',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 101, 121, 220)),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: const Color.fromARGB(255, 255, 180, 68),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () => _navigateTo(context, CollegeList()),
                    child: Container(
                      width: 150,
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.school, size: 50, color: Colors.black),
                          SizedBox(height: 10),
                          Text(
                            "College",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Card(
                  color: const Color.fromARGB(255, 255, 180, 68),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () => _navigateTo(context, SponsorList()),
                    child: Container(
                      width: 150,
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people, size: 50, color: Colors.black),
                          SizedBox(height: 10),
                          Text(
                            "Sponsors",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateTo(context, AddNotificationPage()),
              child: Text('Add Notification'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 101, 121, 220),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
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
