import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:edubridge/admindashboard.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:edubridge/viewallnotification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AddNotificationPage extends StatefulWidget {
  const AddNotificationPage({super.key});

  @override
  State<AddNotificationPage> createState() => _AddNotificationPageState();
}

class _AddNotificationPageState extends State<AddNotificationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final storage = FlutterSecureStorage();
  UserService _userService = UserService();

  Future<void> submitNotification() async {
    var notificationData = jsonEncode({
      "title": _titleController.text,
      "description": _descriptionController.text,
    });
    try {
      final response = await _userService.addNotification(notificationData);
      print(response.data);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Notification added successfully"),
        duration: Duration(milliseconds: 3000),
        backgroundColor: Colors.green,
      ));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ViewAllNotification()),
      );
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
        title: const Text(
          'Add Notification',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 101, 121, 220), // Blue
        elevation: 5,
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: const Color.fromARGB(255, 255, 187, 85),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'New Notification',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 11, 11, 11), // Blue
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: TextStyle(
                              color: const Color.fromARGB(
                                  255, 18, 18, 18)), // Change label color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color.fromRGBO(
                                    10, 10, 10, 1)), // Change border color
                            borderRadius: BorderRadius.circular(10),
                          ),

                          prefixIcon: const Icon(Icons.title,
                              color: Color.fromARGB(
                                  255, 0, 0, 0)), // Change icon color
                        ),
                        style: TextStyle(
                            color: const Color.fromARGB(
                                255, 2, 2, 2)), // Change text color
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          if (value.length < 3 || value.length > 30) {
                            return 'Title must be between 3 and 30 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(
                              color: const Color.fromARGB(
                                  255, 18, 18, 18)), // Change label color
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color.fromRGBO(
                                    10, 10, 10, 1)), // Change border color
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.description,
                              color: Color.fromARGB(
                                  255, 0, 0, 0)), // Change icon color
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              submitNotification();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            backgroundColor: const Color.fromARGB(
                                255, 101, 121, 220), // Blue
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 13, 13, 13), // Orange
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
