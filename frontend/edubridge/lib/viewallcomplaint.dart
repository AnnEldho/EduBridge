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
      appBar: AppBar(
        title: const Text(
          "My Complaints",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color.fromARGB(255, 101, 121, 220),
        elevation: 4,
      ),
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _data.isEmpty
              ? const Center(
                  child: Text(
                    "No Complaints Added",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: _data.length,
                  itemBuilder: (context, index) {
                    final complaint = _data[index];
                    final statusColor = complaint["status"] == "Pending"
                        ? Colors.red
                        : Colors.green;

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      color: Colors.white,
                      shadowColor: Colors.black12,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        title: Text(
                          complaint["subject"],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 101, 121, 220),
                          ),
                        ),
                        trailing: Chip(
                          label: Text(
                            complaint["status"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: statusColor,
                          labelStyle: const TextStyle(fontSize: 12),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewComplaintsSingle(
                                complaintid: complaint["_id"],
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
