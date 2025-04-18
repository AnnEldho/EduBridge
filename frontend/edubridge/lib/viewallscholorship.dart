import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:edubridge/viewsinglescholorship.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ViewAllScholorship extends StatefulWidget {
  const ViewAllScholorship({super.key});

  @override
  State<ViewAllScholorship> createState() => _ViewAllScholorshipState();
}

class _ViewAllScholorshipState extends State<ViewAllScholorship> {
  UserService _userService = UserService();
  final storage = FlutterSecureStorage();
  List<dynamic> scholarships = [];
  bool isLoading = true;
  bool isError = false;

  Future<void> getScholarship() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      final response = await _userService.viewAllScholarships();
      List<dynamic> allScholarships = response.data;

      DateTime today = DateTime.now();

      // Filter scholarships where opening_date has started and closing_date is not finished
      List<dynamic> filteredScholarships = allScholarships.where((scholarship) {
        DateTime openingDate = DateTime.parse(scholarship['opening_date']);
        DateTime closingDate = DateTime.parse(scholarship['closing_date']);
        return openingDate.isBefore(today) ||
            openingDate.isAtSameMomentAs(today);
      }).toList();

      setState(() {
        scholarships = filteredScholarships;
        isLoading = false;
      });
    } on DioException catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
      });
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
        title: const Text('Available Scholarships'),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Failed to load scholarships. Please try again.",
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: getScholarship,
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                )
              : scholarships.isEmpty
                  ? const Center(
                      child: Text(
                        "No active scholarships available.",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
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
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(15),
                            leading: const Icon(Icons.school,
                                size: 40, color: Colors.blue),
                            title: Text(
                              scholarships[index]['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    scholarships[index]['description'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "$formattedOpeningDate - $formattedClosingDate",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "₹${scholarships[index]['amount']}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewScholorShipSingle(
                                    id: scholarships[index]['_id'],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}
