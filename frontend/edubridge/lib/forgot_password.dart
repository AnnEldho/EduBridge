import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:edubridge/widgets/textbox_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ForgotpasswordPage extends StatefulWidget {
  const ForgotpasswordPage({super.key});

  @override
  State<ForgotpasswordPage> createState() => _ForgotpasswordPageState();
}

class _ForgotpasswordPageState extends State<ForgotpasswordPage> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();
  final _emailController = TextEditingController();
  bool _hidePassword1 = true;
  bool _hidePassword2 = true;
  final UserService _userService = UserService();

  String? validateEmail(String? value) {
    String pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Email is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Invalid email';
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
    String pattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Password must have at least one uppercase, one lowercase, one number and one special character, and minimum 8 characters long.';
    } else {
      return null;
    }
  }

  String? validateConfirmPassword(String? value) {
    if (value != password.text) {
      return 'Passwords do not match';
    } else {
      return null;
    }
  }

  Future<void> forgotPassword(String email, String newPassword) async {
    try {
      final response = await _userService.resetPassword(email, newPassword);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset successful')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to reset password')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reset password: $e')),
      );
    }
  }

  Future<bool> checkEmailExists(String email) async {
    try {
      final response = await _userService.checkEmail(email);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey1.currentState!.validate()) {
      bool emailExists = await checkEmailExists(_emailController.text);
      if (emailExists) {
        if (_formKey2.currentState!.validate()) {
          await forgotPassword(_emailController.text, password.text);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email does not exist')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 250),
          const Center(
            child: Text(
              "Forgot Password",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextBox(
                    controller: _emailController,
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email,
                    validator: validateEmail,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey1.currentState!.validate()) {
                          _submitForm();
                        }
                      },
                      child: const Text("Submit"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey2,
              child: Column(
                children: [
                  TextFormField(
                    controller: password,
                    decoration: InputDecoration(
                      errorMaxLines: 200,
                      labelText: 'New Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hidePassword1
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _hidePassword1 = !_hidePassword1;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: validatePassword,
                    obscureText: _hidePassword1,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: confirmpassword,
                    decoration: InputDecoration(
                      errorMaxLines: 200,
                      labelText: 'Confirm New Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hidePassword2
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _hidePassword2 = !_hidePassword2;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: validateConfirmPassword,
                    obscureText: _hidePassword2,
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey2.currentState!.validate()) {
                          _submitForm();
                        }
                      },
                      child: const Text("Submit"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}