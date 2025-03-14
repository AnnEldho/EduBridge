import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:edubridge/viewcomplaintsingle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ViewAllComplaint extends StatefulWidget {
  const ViewAllComplaint({super.key});

  @override
  State<ViewAllComplaint> createState() => _ViewAllComplaintState();
}

class _ViewAllComplaintState extends State<ViewAllComplaint> {
  UserService _userService = UserService();
  List<dynamic> _data = [];
  final storage = const FlutterSecureStorage();
  bool isloading = false;

  getComplaints() async {
    if (mounted) {
      setState(() {
        isloading = true;
      });
    }
    // Map<String, String> allValues = await storage.readAll();
    // var user = allValues['user'];
    // print(user);
    // var userMap = jsonDecode(user!);
    try {
      final res = await _userService.getAllComplaint();

      print(res.data);
      if (mounted) {
        setState(() {
          _data = res.data;
          isloading = false;
        });
      }
    } on DioException catch (e) {
      setState(() {
        isloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred,please try again"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getComplaints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("My Complaints")),
        body: isloading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _data.length == 0
                ? const Center(
                    child: Text("No Complaints Added"),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: _data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_data[index]["subject"]),
                        subtitle: Text(_data[index]["status"]),
                        trailing: _data[index]["status"] == "Pending"
                            ? Icon(
                                Icons.verified,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.verified,
                                color: Colors.green,
                              ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewComplaintsSingle(
                                      complaintid: _data[index]["_id"],
                                    )),
                          );
                        },
                      );
                    }));
  }
}
