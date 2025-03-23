import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:edubridge/singlescholorship.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ViewScholorship extends StatefulWidget {
  const ViewScholorship({super.key});

  @override
  State<ViewScholorship> createState() => _ViewScholorshipState();
}

class _ViewScholorshipState extends State<ViewScholorship> {
  UserService _userService = UserService();
  final storage = FlutterSecureStorage();
  List<dynamic> scholarships = [];

  Future<void> getScholarship() async {
    Map<String, String> allValues = await storage.readAll();
    var user = allValues['user'];
    var userMap = jsonDecode(user!);
    try {
      final response = await _userService.viewScholarship(userMap['_id']);
      setState(() {
        scholarships = response.data;
      });
    } on DioException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error occurred, please try again"),
          duration: Duration(milliseconds: 300),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getScholarship();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Scholarships',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: scholarships.isEmpty
          ? const Center(
              child: Text(
                "No scholarships available",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: scholarships.length,
              itemBuilder: (context, index) {
                var openingDate =
                    DateTime.parse(scholarships[index]['opening_date']);
                var closingDate =
                    DateTime.parse(scholarships[index]['closing_date']);
                var formattedOpeningDate =
                    "${openingDate.day}/${openingDate.month}/${openingDate.year}";
                var formattedClosingDate =
                    "${closingDate.day}/${closingDate.month}/${closingDate.year}";

                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 4,
                  color: const Color.fromARGB(255, 255, 180, 68),
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SingleScholarShip(
                            id: scholarships[index]['_id'],
                          ),
                        ),
                      );
                    },
                    title: Text(
                      scholarships[index]['title'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        "${scholarships[index]['description']}\nDuration: $formattedOpeningDate - $formattedClosingDate",
                        style: const TextStyle(
                            fontSize: 14, color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "₹${scholarships[index]['amount'].toString()}",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
