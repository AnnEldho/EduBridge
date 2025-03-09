import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class SingleScholarShip extends StatefulWidget {
  const SingleScholarShip({super.key, required this.id});
  final String id;

  @override
  State<SingleScholarShip> createState() => _SingleScholarShipState();
}

class _SingleScholarShipState extends State<SingleScholarShip> {
  UserService _userService = UserService();
  dynamic data;
  final storage = FlutterSecureStorage();
  List<dynamic> joinedScholarship = [];

  Future<void> joinScholorship() async {
    Map<String, String> allValues = await storage.readAll();
    var user = allValues['user'];
    print(user);
    var userMap = jsonDecode(user!);
    var jsonData = jsonEncode({
      "scholorshipid": widget.id,
      "userid": userMap["_id"],
      "ngoid": data['userid']
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

  Future<void> getJoinedScholorShip() async {
    try {
      final response = await _userService.viewScholarshipJoinById(widget.id);
      print("joined");
      print(response.data);
      setState(() {
        joinedScholarship = response.data;
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
    getJoinedScholorShip();
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
          : SingleChildScrollView(
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
                  Text(
                    "Status: ${data['status']}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       joinScholorship();
                  //     },
                  //     child: Text("Apply"))
                  const SizedBox(height: 20),
                  const Text(
                    "Joined Users",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: joinedScholarship.length,
                    itemBuilder: (context, index) {
                      var scholarship = joinedScholarship[index];
                      return Card(
                        child: ListTile(
                          title: Text("User: ${scholarship['userid']['name']}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Email: ${scholarship['userid']['email']}"),
                              Text(
                                  "Phone: ${scholarship['userid']['phone_number'].toString()}"),
                              Text(
                                  "District: ${scholarship['userid']['district']}"),
                              Text("Taluk: ${scholarship['userid']['taluk']}"),
                              Text("Status: ${scholarship['status']}"),
                              Text(
                                  "Date: ${DateFormat.yMd().add_jm().format(DateTime.parse(scholarship['datetime']))}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
