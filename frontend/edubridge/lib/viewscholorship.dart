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
    print(user);
    var userMap = jsonDecode(user!);
    try {
      final response = await _userService.viewScholarship(userMap['_id']);
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
          var openingDate = DateTime.parse(scholarships[index]['opening_date']);
          var closingDate = DateTime.parse(scholarships[index]['closing_date']);
          var formattedOpeningDate =
              "${openingDate.day}/${openingDate.month}/${openingDate.year}";
          var formattedClosingDate =
              "${closingDate.day}/${closingDate.month}/${closingDate.year}";

          return ListTile(
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
            title: Text(scholarships[index]['title']),
            subtitle: Text(scholarships[index]['description'] +
                "\n" +
                formattedOpeningDate +
                " to " +
                formattedClosingDate),
            trailing: Text(scholarships[index]['amount'].toString()),
          );
        },
      ),
    );
  }
}
