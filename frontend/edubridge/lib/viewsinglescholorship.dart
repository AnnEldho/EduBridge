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

  Future<void> changeScholarshipStatus(String id, String status) async {
    Map<String, String> allValues = await storage.readAll();
    print("applied");
    var data = jsonEncode({"id": id, "status": status});

    try {
      final response = await _userService.changeScholarshipStatus(data);
      print(response.data);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Status updated successfully"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
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
                  Center(
                    child: Text(
                      "${data['title']}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    "Description :",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${data['description']}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Amount :",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${data['amount'].toString()}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Opening Date :",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " ${DateFormat.yMd().format(DateTime.parse(data['opening_date']))}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Closing Date :",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${DateFormat.yMd().format(DateTime.parse(data['closing_date']))}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      changeScholarshipStatus(data['_id'].toString(),
                          "approved"); // Convert to String
                    },
                    child: Text("Apply"),
                  )
                ],
              ),
            ),
    );
  }
}
