import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ViewJoinedScholorship extends StatefulWidget {
  const ViewJoinedScholorship({super.key});

  @override
  State<ViewJoinedScholorship> createState() => _ViewJoinedScholorshipState();
}

class _ViewJoinedScholorshipState extends State<ViewJoinedScholorship> {
  UserService _userService = UserService();
  final storage = FlutterSecureStorage();
  List<dynamic> scholarships = [];

  Future<void> getScholarship() async {
    Map<String, String> allValues = await storage.readAll();
    var user = allValues['user'];
    print(user);
    var userMap = jsonDecode(user!);
    try {
      final response = await _userService.viewJoinedScholarship(userMap['_id']);
      print(response.data);
      setState(() {
        scholarships = response.data;
      });
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred,please try again"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getScholarship();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applied Scholarships'),
      ),
      body: scholarships.isEmpty
          ? const Center(child: Text("No applied scholarships found."))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: scholarships.length,
              itemBuilder: (context, index) {
                var scholarship = scholarships[index]["scholorshipid"];
                var provider = scholarships[index]["providerid"];

                var openingDate = DateTime.parse(scholarship['opening_date']);
                var closingDate = DateTime.parse(scholarship['closing_date']);

                var formattedOpeningDate =
                    "${openingDate.day}/${openingDate.month}/${openingDate.year}";
                var formattedClosingDate =
                    "${closingDate.day}/${closingDate.month}/${closingDate.year}";

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Color(0xFFFFBB55),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 🎓 Scholarship Title
                        Text(
                          scholarship["title"],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        /// 📆 Dates & Amount
                        Text("Opening Date: $formattedOpeningDate"),
                        Text("Closing Date: $formattedClosingDate"),
                        Text(
                          "Amount: ₹${scholarship['amount']}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.blue),
                        ),
                        const Divider(height: 20, color: Colors.black),

                        /// 👤 Provider Info
                        Text(
                          "Provided by: ${provider["name"]} (${provider["usertype"]})",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("Contact: ${provider["phone_number"]}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
