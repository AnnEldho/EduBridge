import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:edubridge/viewmycomplaints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AddComplaintPage extends StatefulWidget {
  const AddComplaintPage({super.key});

  @override
  State<AddComplaintPage> createState() => _AddComplaintPageState();
}

class _AddComplaintPageState extends State<AddComplaintPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final storage = FlutterSecureStorage();
  UserService _userService = UserService();

  Future<void> submitComplaint() async {
    Map<String, String> allValues = await storage.readAll();
    var user = allValues['user'];
    print(user);
    var userMap = jsonDecode(user!);
    var complaintData = jsonEncode({
      "subject": _titleController.text,
      "complaint": _descriptionController.text,
      "userid": userMap['_id'],
    });
    try {
      final response = await _userService.addComplaint(complaintData);
      print(response.data);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Complaint added successfully"),
        duration: Duration(milliseconds: 3000),
        backgroundColor: Colors.green,
      ));
    } on DioException catch (e) {
      print("Error: ${e.response?.data}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred, please try again"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Complaint'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration:
                        const InputDecoration(labelText: 'Complaint Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a complaint title';
                      }
                      if (value.length < 3 || value.length > 30) {
                        return 'Title must be between 3 and 30 characters';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                        labelText: 'Complaint Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a complaint description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        submitComplaint();
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
