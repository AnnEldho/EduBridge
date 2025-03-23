import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  XFile? _imageFile;
  bool isloading = false;
  Future<void> getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image;
    });
  }

  Future<void> submitForm() async {
    setState(() {
      isloading = true;
    });
    List<String>? s = _imageFile?.path.toString().split("/");
    final bytes = await File(_imageFile!.path).readAsBytes();
    final base64 = base64Encode(bytes);
    var pic = "data:image/${s![s.length - 1].split(".")[1]};base64,$base64";
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
      "usertype": "Sponsor",
      "idproof": pic
    });

    try {
      final response = await userService.registerUser(userdata);
      print(response.data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Successful!')),
      );
      setState(() {
        isloading = false;
      });
    } on DioException catch (e) {
      setState(() {
        isloading = false;
      });
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
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: const Color.fromARGB(
                  255, 101, 121, 220)), // Change label color
          border: OutlineInputBorder(),
          suffixIcon: suffixIcon,
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        style: TextStyle(
            color: const Color.fromARGB(255, 12, 12, 12)), // Change text color
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
          child: isloading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          label: 'Name',
                          validator: (value) => value!.isEmpty
                              ? 'Please enter the sponsor name'
                              : null,
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
                          validator: (value) => value!.isEmpty
                              ? 'Please enter the district'
                              : null,
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
                          validator: (value) =>
                              value!.isEmpty || value.length != 6
                                  ? 'Please enter a valid 6-digit pincode'
                                  : null,
                        ),
                        _buildTextField(
                          controller: _phoneNumberController,
                          label: 'Phone Number',
                          keyboardType: TextInputType.phone,
                          validator: (value) =>
                              value!.isEmpty || value.length != 10
                                  ? 'Please enter a valid 10-digit phone number'
                                  : null,
                        ),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) =>
                              value!.isEmpty || !value.contains('@')
                                  ? 'Please enter a valid email address'
                                  : null,
                        ),
                        GestureDetector(
                            onTap: getImageFromGallery,
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: const Color.fromARGB(255, 101, 121,
                                        220), // Changed color to blue
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.image,
                                    color: Color.fromARGB(255, 101, 121,
                                        220), // Changed color to blue
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Upload ID Proof",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 101, 121,
                                            220)), // Changed color to blue
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: _imageFile == null
                              ? const Text('No image selected ')
                              : Image.file(
                                  File(_imageFile!.path),
                                  width: 360,
                                  height: 240,
                                ),
                        ),
                        _buildTextField(
                          controller: _passwordController,
                          label: 'Password',
                          obscureText: true,
                          validator: (value) => value!.isEmpty ||
                                  value.length < 6
                              ? 'Password must be at least 6 characters long'
                              : null,
                        ),
                        _buildTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password',
                          obscureText: true,
                          validator: (value) =>
                              value != _passwordController.text
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
