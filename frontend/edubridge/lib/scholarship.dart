import 'dart:convert';
import 'package:edubridge/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ScholarshipPage extends StatefulWidget {
  const ScholarshipPage({super.key});

  @override
  State<ScholarshipPage> createState() => ScholarshipPageState();
}

class ScholarshipPageState extends State<ScholarshipPage> {
    final _formKey = GlobalKey<FormState>();
    final _scholarshipnameController = TextEditingController();
    final _amountController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _eligibilityController = TextEditingController();
    final _deadlineController = TextEditingController();
  

    UserService userService=UserService();
    Future<void> submitForm() async {
    var userdata = jsonEncode({
      "scholarshipname":_scholarshipnameController.text,
      "amount": _amountController.text,
      "description":_descriptionController.text,
      "eligibility":_eligibilityController.text,
      "due_date": _deadlineController.text,
    });
    print(userdata);
    try {
      final response = await userService.registerUser(userdata);
      print(response.data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Successful!')),
      );
    } on DioException catch (e) {
      print(e.response!.data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Registering User!')),
      );
    }
  }

  @override
  void dispose() {
    _scholarshipnameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _eligibilityController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scholarship Page'),
      ),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _scholarshipnameController,
                label: 'Scholarship Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _amountController,
                label: 'Amount',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _eligibilityController,
                label: 'Eligibility',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the eligibility';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _deadlineController,
                label: 'Deadline',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the deadline';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    submitForm();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}