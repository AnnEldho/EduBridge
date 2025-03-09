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
        title: const Text('View Scholarship'),
      ),
      body: ListView.builder(
        itemCount: scholarships.length,
        itemBuilder: (context, index) {
          var openingDate = DateTime.parse(
              scholarships[index]["scholorshipid"]['opening_date']);
          var closingDate = DateTime.parse(
              scholarships[index]["scholorshipid"]['closing_date']);
          var formattedOpeningDate =
              "${openingDate.day}/${openingDate.month}/${openingDate.year}";
          var formattedClosingDate =
              "${closingDate.day}/${closingDate.month}/${closingDate.year}";

          return Card(
            child: Column(
              children: [
                ListTile(
                  trailing:
                      Text(scholarships[index]["scholorshipid"]["status"]),
                  title: Text(scholarships[index]["scholorshipid"]["title"]),
                  subtitle: Text(
                      "Opening Date: $formattedOpeningDate\nClosing Date: $formattedClosingDate\nAmount: ${scholarships[index]["scholorshipid"]["amount"]}"),
                ),
                ListTile(
                  title: Text(scholarships[index]["providerid"]["name"] +
                      "\n" +
                      "Provided By:" +
                      scholarships[index]["providerid"]["usertype"]),
                  subtitle: Text(
                      "Contact: ${scholarships[index]["providerid"]["phone_number"].toString()}"),
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     // joinScholorship();
                //   },
                //   child: const Text("Leave Scholarship"),
                // )
              ],
            ),
          );
        },
      ),
    );
  }
}
