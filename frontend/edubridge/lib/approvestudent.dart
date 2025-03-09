import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApproveStudents extends StatefulWidget {
  const ApproveStudents({super.key});

  @override
  State<ApproveStudents> createState() => _ApproveStudentsState();
}

class _ApproveStudentsState extends State<ApproveStudents> {
  UserService userService = UserService();
  final storage = FlutterSecureStorage();
  List<dynamic> students = [];
  String name = "";
  String email = "";
  getUser() async {
    print("Getting User");
    Map<String, String> allValues = await storage.readAll();
    var user = allValues['user'];
    print(user);
    var userMap = jsonDecode(user!);
    print(userMap);
    setState(() {
      name = userMap['name'];
      email = userMap['email'];
    });
  }

  Future<void> getStudents() async {
    Map<String, String> allValues = await storage.readAll();
    var user = allValues['user'];
    print(user);
    var userMap = jsonDecode(user!);
    var jsonData = jsonEncode({
      "collegeid": userMap['_id'],
    });
    try {
      final response = await userService.getStudentsByInstitution(jsonData);
      print(response.data);
      setState(() {
        students = response.data;
      });
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred,please try again"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  Future<void> updateStatus(String id, String status) async {
    var jsonData = jsonEncode({
      "studentid": id,
      "status": status,
    });
    try {
      final response = await userService.approveStudent(jsonData);
      print(response.data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Student ${status} successfully"),
        duration: Duration(milliseconds: 3000),
        backgroundColor: Colors.green,
      ));
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
    getStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Approve Students')),
      body: students.length == 0
          ? Center(
              child: Text("No Students to approve"),
            )
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                var student = students[index];
                if (student['user_id'] != null) {
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: student['user_id'] != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Name: ${student['user_id']['name']}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text('Email: ${student['user_id']['email']}'),
                                Text(
                                    'Phone Number: ${student['user_id']['phone_number']}'),
                                Text('Taluk: ${student['user_id']['taluk']}'),
                                Text(
                                    'District: ${student['user_id']['district']}'),
                                Text('State: ${student['user_id']['state']}'),
                                Text(
                                    'Pincode: ${student['user_id']['pincode']}'),
                                Text('House Name: ${student['house_name']}'),
                                Text('DOB: ${student['dob']}'),
                                Text('Gender: ${student['gender']}'),
                                Text('Nationality: ${student['nationality']}'),
                                Text(
                                    'Aadhar Number: ${student['aadhar_number']}'),
                                Text('Course: ${student['course']}'),
                                Text(
                                    'Academic Year: ${student['academic_year']}'),
                                Text(
                                    'Account Number: ${student['account_number']}'),
                                Text('Bank Name: ${student['bank_name']}'),
                                Text('Branch Name: ${student['branch_name']}'),
                                Text('IFSC Code: ${student['ifsc_code']}'),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // Approve student logic here
                                        updateStatus(student['user_id']['_id'],
                                            'Approved');
                                        getStudents();
                                      },
                                      child: Text('Approve'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Reject student logic here
                                        updateStatus(student['user_id']['_id'],
                                            'Rejected');
                                        getStudents();
                                      },
                                      child: Text('Reject'),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                    ),
                  );
                }
              },
            ),
    );
  }
}
