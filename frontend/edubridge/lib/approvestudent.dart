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
  bool isLoading = true; // Added for loading state

  Future<void> getStudents() async {
    setState(() => isLoading = true); // Show loading indicator
    try {
      Map<String, String> allValues = await storage.readAll();
      var user = jsonDecode(allValues['user']!);
      var jsonData = jsonEncode({"collegeid": user['_id']});

      final response = await userService.getStudentsByInstitution(jsonData);
      setState(() {
        students = response.data;
        isLoading = false; // Hide loading indicator
      });
    } on DioException {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred, please try again"),
        duration: Duration(milliseconds: 1000),
      ));
      setState(() => isLoading = false);
    }
  }

  Future<void> updateStatus(String id, String status) async {
    var jsonData = jsonEncode({"studentid": id, "status": status});
    try {
      await userService.approveStudent(jsonData);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Student $status successfully"),
        duration: Duration(milliseconds: 3000),
        backgroundColor: Colors.green,
      ));
      getStudents(); // Refresh the list after update
    } on DioException {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred, please try again"),
        duration: Duration(milliseconds: 1000),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    getStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Approve Students')),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading spinner
          : students.isEmpty
              ? const Center(child: Text("No Students to approve"))
              : ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    var student = students[index];
                    return student['user_id'] != null
                        ? Card(
                            margin: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 4, // Added shadow effect
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
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
                                  Text(
                                      'Nationality: ${student['nationality']}'),
                                  Text(
                                      'Aadhar Number: ${student['aadhar_number']}'),
                                  Text('Course: ${student['course']}'),
                                  Text(
                                      'Academic Year: ${student['academic_year']}'),
                                  Text(
                                      'Account Number: ${student['account_number']}'),
                                  Text('Bank Name: ${student['bank_name']}'),
                                  Text(
                                      'Branch Name: ${student['branch_name']}'),
                                  Text('IFSC Code: ${student['ifsc_code']}'),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              child: Image.memory(
                                                base64Decode(student['idproof']
                                                    .split(',')[1]),
                                                fit: BoxFit.contain,
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                                  return const Icon(Icons.image,
                                                      size: 100);
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Image.memory(
                                      base64Decode(
                                          student['idproof'].split(',')[1]),
                                      fit: BoxFit.contain,
                                      height: 200,
                                      width: 200,
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return const Icon(Icons.image,
                                            size: 100);
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          updateStatus(
                                              student['user_id']['_id'],
                                              'Approved');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                        ),
                                        icon: const Icon(Icons.check,
                                            color: Color.fromARGB(
                                                255, 10, 10, 10)),
                                        label: const Text("Approve"),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          updateStatus(
                                              student['user_id']['_id'],
                                              'Rejected');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                        ),
                                        icon: const Icon(
                                          Icons.close,
                                          color: Color.fromRGBO(2, 2, 2, 0.965),
                                        ),
                                        label: const Text("Reject"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
    );
  }
}
