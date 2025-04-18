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
  List<dynamic> upcomingScholarships = [];
  List<dynamic> activeScholarships = [];
  List<dynamic> expiredScholarships = [];

  Future<void> getScholarship() async {
    Map<String, String> allValues = await storage.readAll();
    var user = allValues['user'];
    var userMap = jsonDecode(user!);
    try {
      final response = await _userService.viewScholarship(userMap['_id']);
      setState(() {
        scholarships = response.data;
      });

      DateTime today = DateTime.now();

      // Filter scholarships based on today's date
      upcomingScholarships = scholarships.where((scholarship) {
        DateTime opening = DateTime.parse(scholarship['opening_date']);
        return today.isBefore(opening);
      }).toList();

      activeScholarships = scholarships.where((scholarship) {
        DateTime opening = DateTime.parse(scholarship['opening_date']);
        DateTime closing = DateTime.parse(scholarship['closing_date']);
        return today.isAfter(opening.subtract(Duration(days: 1))) &&
            today.isBefore(closing.add(Duration(days: 1)));
      }).toList();

      expiredScholarships = scholarships.where((scholarship) {
        DateTime closing = DateTime.parse(scholarship['closing_date']);
        return today.isAfter(closing);
      }).toList();
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
          : ListView(
              padding: const EdgeInsets.all(10),
              children: [
                // Upcoming Scholarships Section
                if (upcomingScholarships.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Upcoming Scholarships",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: upcomingScholarships.length,
                    itemBuilder: (context, index) {
                      var openingDate = DateTime.parse(
                          upcomingScholarships[index]['opening_date']);
                      var formattedOpeningDate =
                          "${openingDate.day}/${openingDate.month}/${openingDate.year}";

                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 4,
                        color: const Color.fromARGB(255, 255, 180, 68),
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 5),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingleScholarShip(
                                  id: upcomingScholarships[index]['_id'],
                                ),
                              ),
                            );
                          },
                          title: Text(
                            upcomingScholarships[index]['title'],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              "${upcomingScholarships[index]['description']}\nOpening Date: $formattedOpeningDate",
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "Upcoming",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],

                // Active Scholarships Section
                if (activeScholarships.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Active Scholarships",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: activeScholarships.length,
                    itemBuilder: (context, index) {
                      var openingDate = DateTime.parse(
                          activeScholarships[index]['opening_date']);
                      var closingDate = DateTime.parse(
                          activeScholarships[index]['closing_date']);
                      var formattedOpeningDate =
                          "${openingDate.day}/${openingDate.month}/${openingDate.year}";
                      var formattedClosingDate =
                          "${closingDate.day}/${closingDate.month}/${closingDate.year}";

                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 4,
                        color: const Color.fromARGB(255, 255, 180, 68),
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 5),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingleScholarShip(
                                  id: activeScholarships[index]['_id'],
                                ),
                              ),
                            );
                          },
                          title: Text(
                            activeScholarships[index]['title'],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              "${activeScholarships[index]['description']}\nDuration: $formattedOpeningDate - $formattedClosingDate",
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "Active",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],

                // Expired Scholarships Section
                if (expiredScholarships.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Expired Scholarships",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: expiredScholarships.length,
                    itemBuilder: (context, index) {
                      var openingDate = DateTime.parse(
                          expiredScholarships[index]['opening_date']);
                      var closingDate = DateTime.parse(
                          expiredScholarships[index]['closing_date']);
                      var formattedOpeningDate =
                          "${openingDate.day}/${openingDate.month}/${openingDate.year}";
                      var formattedClosingDate =
                          "${closingDate.day}/${closingDate.month}/${closingDate.year}";

                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 4,
                        color: const Color.fromARGB(255, 255, 180, 68),
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 5),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SingleScholarShip(
                                  id: expiredScholarships[index]['_id'],
                                ),
                              ),
                            );
                          },
                          title: Text(
                            expiredScholarships[index]['title'],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              "${expiredScholarships[index]['description']}\nDuration: $formattedOpeningDate - $formattedClosingDate",
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "Expired",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
    );
  }
}
