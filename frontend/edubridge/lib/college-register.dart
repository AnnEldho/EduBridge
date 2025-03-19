import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CollegeRegistrationForm extends StatefulWidget {
  const CollegeRegistrationForm({super.key});

  @override
  State<CollegeRegistrationForm> createState() =>
      _CollegeRegistrationFormState();
}

class _CollegeRegistrationFormState extends State<CollegeRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _collegeNameController = TextEditingController();
  final _placeController = TextEditingController();
  final _talukController = TextEditingController();
  final _districtController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _inchargeNameController = TextEditingController();
  final _inchargeEmailController = TextEditingController();
  final _inchargePhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

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
      "name": _collegeNameController.text,
      "email": _emailController.text,
      "phone_number": _phoneNumberController.text,
      "place": _placeController.text,
      "taluk": _talukController.text,
      "district": _districtController.text,
      "state": _stateController.text,
      "pincode": _pincodeController.text,
      "password": _passwordController.text,
      "confirm_password": _confirmPasswordController.text,
      "usertype": "College",
      "incharge_name": _inchargeNameController.text,
      "incharge_email": _inchargeEmailController.text,
      "incharge_phone": _inchargePhoneController.text,
      "idproof": pic
    });

    //print(userdata);

    try {
      final response = await userService.registerUser(userdata);
      print(response.data);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful!')),
      );
      setState(() {
        isloading = false;
      });
    } on DioException catch (e) {
      setState(() {
        isloading = false;
      });
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error Registering User!')),
      );
    }
  }

  @override
  void dispose() {
    _collegeNameController.dispose();
    _placeController.dispose();
    _talukController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _inchargeNameController.dispose();
    _inchargeEmailController.dispose();
    _inchargePhoneController.dispose();
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
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          suffixIcon: suffixIcon,
        ),
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
        title: const Text('College Registration'),
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
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
                          controller: _collegeNameController,
                          label: 'College Name',
                          validator: (value) => value!.isEmpty
                              ? 'Please enter the college name'
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
                        _buildTextField(
                          controller: _inchargeNameController,
                          label: 'Incharge Name',
                          validator: (value) => value!.isEmpty
                              ? 'Please enter the contact person\'s name'
                              : null,
                        ),
                        _buildTextField(
                          controller: _inchargeEmailController,
                          label: 'Incharge Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) =>
                              value!.isEmpty || !value.contains('@')
                                  ? 'Please enter a valid email address'
                                  : null,
                        ),
                        _buildTextField(
                          controller: _inchargePhoneController,
                          label: 'Incharge Phone',
                          keyboardType: TextInputType.phone,
                          validator: (value) =>
                              value!.isEmpty || value.length != 10
                                  ? 'Please enter a valid 10-digit phone number'
                                  : null,
                        ),
                        GestureDetector(
                            onTap: getImageFromGallery,
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                // borderRadius:
                                //const BorderRadius.all(Radius.elliptical(30)
                                // )
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Upload ID Proof")
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
                          obscureText: !_isPasswordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          validator: (value) => value!.isEmpty ||
                                  value.length < 6
                              ? 'Password must be at least 6 characters long'
                              : null,
                        ),
                        _buildTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password',
                          obscureText: !_isConfirmPasswordVisible,
                          suffixIcon: IconButton(
                            icon: Icon(_isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
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
