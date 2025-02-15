import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:edubridge/usertypes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  UserService userService = UserService();
  final storage = FlutterSecureStorage();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      var userdata = jsonEncode({
        "email": _emailController.text,
        "password": _passwordController.text,
      });
      print(userdata);
      if (_emailController.text == "admin@gmail.com" &&
          _passwordController.text == "admin123") {
        Navigator.pushNamedAndRemoveUntil(context, "/admin", (route) => false);
      } else {
        try {
          final response = await userService.loginUser(userdata);
          print(response.data);
          await storage.write(
              key: "user", value: jsonEncode(response.data['exist']));
          if (response.data['exist']['usertype'] == "Student") {
            Navigator.pushNamedAndRemoveUntil(
                context, "/student", (route) => false);
          }
          else if (response.data['exist']['usertype'] == "College") {
            Navigator.pushNamedAndRemoveUntil(
                context, "/college", (route) => false);
          }
          else if (response.data['exist']['usertype'] == "Sponsor") {
            Navigator.pushNamedAndRemoveUntil(
                context, "/sponsor", (route) => false);
          }
          else if (response.data['exist']['usertype'] == "Ngo") {
            Navigator.pushNamedAndRemoveUntil(
                context, "/ngo", (route) => false);
          }
        } on DioException catch (e) {
          print(e.response!.data);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error Logging User!')),
          );
        }

      }

      //  if (_emailController.text == "admin@gmail.com") {
      //    Navigator.pushNamedAndRemoveUntil(context, "/admin", (route) => false);
      //  } else if (_emailController.text == "college@gmail.com") {
      //    Navigator.pushNamedAndRemoveUntil(context, "/college", (route) => false);
      //  } else if (_emailController.text == "student@gmail.com") {
      //    Navigator.pushNamedAndRemoveUntil(context, "/student", (route) => false);
      //  } else if (_emailController.text == "sponsor@gmail.com") {
      //    Navigator.pushNamedAndRemoveUntil(context, "/sponsor", (route) => false);
      //  } else if (_emailController.text == "ngo@gmail.com") {
      //    Navigator.pushNamedAndRemoveUntil(context, "/ngo", (route) => false);
      //  }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserTypeSelection()),
                  );
                },
                child: const Text('Don\'t have an account? Register here'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
