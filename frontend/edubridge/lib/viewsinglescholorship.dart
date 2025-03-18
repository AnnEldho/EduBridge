import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class ViewScholorShipSingle extends StatefulWidget {
  const ViewScholorShipSingle({super.key, required this.id});
  final String id;

  @override
  State<ViewScholorShipSingle> createState() => _ViewScholorShipSingleState();
}

class _ViewScholorShipSingleState extends State<ViewScholorShipSingle> {
  UserService _userService = UserService();
  dynamic data;
  final storage = FlutterSecureStorage();

  Future<void> joinScholorship() async {
    Map<String, String> allValues = await storage.readAll();
    var user = allValues['user'];
    print(user);
    var userMap = jsonDecode(user!);
    var jsonData = jsonEncode({
      "scholorshipid": widget.id,
      "userid": userMap["_id"],
      "providerid": data['userid']
    });
    try {
      final response = await _userService.joinScholarship(jsonData);
      print(response.data);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Scholarship applied successfully"),
        duration: Duration(milliseconds: 3000),
        backgroundColor: Colors.green,
      ));
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.response?.data["message"]),
        duration: Duration(milliseconds: 3000),
      ));
    }
  }

  Future<void> getScholarship() async {
    try {
      final response = await _userService.viewScholarshipById(widget.id);
      print(response.data);
      setState(() {
        data = response.data;
      });
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
        title: const Text("Scholarship Details"),
      ),
      body: data == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Title: ${data['title']}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Description: ${data['description']}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Amount: ${data['amount'].toString()}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Opening Date: ${DateFormat.yMd().format(DateTime.parse(data['opening_date']))}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Closing Date: ${DateFormat.yMd().format(DateTime.parse(data['closing_date']))}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        joinScholorship();
                      },
                      child: Text("Apply"))
                ],
              ),
            ),
    );
  }
}
