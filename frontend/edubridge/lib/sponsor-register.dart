import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:flutter/material.dart';

class SponsorRegistrationForm extends StatefulWidget {
  const SponsorRegistrationForm({super.key});

  @override
  State<SponsorRegistrationForm> createState() =>
      _SponsorRegistrationFormState();
}

class _SponsorRegistrationFormState extends State<SponsorRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _placeController = TextEditingController();
  final _talukController = TextEditingController();
  final _districtController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  UserService userService = UserService();

  Future<void> submitForm() async {
    var userdata = jsonEncode({
      "name": _nameController.text,
      "email": _emailController.text,
      "phone_number": _phoneNumberController.text,
      "place": _placeController.text,
      "taluk": _talukController.text,
      "district": _districtController.text,
      "state": _stateController.text,
      "pincode": _pincodeController.text,
      "password": _passwordController.text,
      "confirm_password": _confirmPasswordController.text,
      "usertype": "Sponsor"
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
    _nameController.dispose();
    _placeController.dispose();
    _talukController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sponsor Registration'),
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
                  _buildTextField(
                    controller: _nameController,
                    label: 'Name',
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter the sponsor name' : null,
                  ),
                  _buildTextField(
                    controller: _placeController,
                    label: 'Place',
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter the place' : null,
                  ),
                  _buildTextField(
                    controller: _talukController,
                    label: 'Taluk',
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter the taluk' : null,
                  ),
                  _buildTextField(
                    controller: _districtController,
                    label: 'District',
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter the district' : null,
                  ),
                  _buildTextField(
                    controller: _stateController,
                    label: 'State',
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter the state' : null,
                  ),
                  _buildTextField(
                    controller: _pincodeController,
                    label: 'Pincode',
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty || value.length != 6
                        ? 'Please enter a valid 6-digit pincode'
                        : null,
                  ),
                  _buildTextField(
                    controller: _phoneNumberController,
                    label: 'Phone Number',
                    keyboardType: TextInputType.phone,
                    validator: (value) => value!.isEmpty || value.length != 10
                        ? 'Please enter a valid 10-digit phone number'
                        : null,
                  ),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value!.isEmpty || !value.contains('@')
                        ? 'Please enter a valid email address'
                        : null,
                  ),
                  _buildTextField(
                    controller: _passwordController,
                    label: 'Password',
                    obscureText: true,
                    validator: (value) => value!.isEmpty || value.length < 6
                        ? 'Password must be at least 6 characters long'
                        : null,
                  ),
                  _buildTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    obscureText: true,
                    validator: (value) => value != _passwordController.text
                        ? 'Passwords do not match'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        submitForm();
                      }
                    },
                    child: const Text('Register'),
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
