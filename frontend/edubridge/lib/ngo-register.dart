import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:edubridge/admindashboard.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:flutter/material.dart';

class NGORegistrationForm extends StatefulWidget {
  const NGORegistrationForm({super.key});

  @override
  State<NGORegistrationForm> createState() => _NGORegistrationFormState();
}

class _NGORegistrationFormState extends State<NGORegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
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
  final _bankAccountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _accountTypeController = TextEditingController();
  final _branchNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

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
      "status": "Active",
      "password": _passwordController.text,
      "confirm_password": _confirmPasswordController.text,
      "usertype": "Ngo",
      "account_number": _bankAccountNumberController.text,
      "bank_name": _bankNameController.text,
      "ifsc_code": _ifscCodeController.text,
      "account_type": _accountTypeController.text,
      "branch_name": _branchNameController.text,
      "incharge_name": _inchargeNameController.text,
      "incharge_email": _inchargeEmailController.text,
      "incharge_phone": _inchargePhoneController.text,
    });

    print(userdata);
    try {
      final response = await userService.registerUser(userdata);
      print(response.data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration Successful!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Admindashboard()),
      );
    } on DioException catch (e) {
      print(e.response!.data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Registering User!')),
      );
    }
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
        title: const Text('NGO Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      label: 'Name',
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
                      validator: (value) =>
                          value!.isEmpty || !value.contains('@')
                              ? 'Please enter a valid email address'
                              : null,
                    ),
                    _buildTextField(
                      controller: _inchargeNameController,
                      label: 'Incharge Name',
                      validator: (value) => value!.isEmpty
                          ? 'Please enter the incharge name'
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
                      validator: (value) => value!.isEmpty || value.length != 10
                          ? 'Please enter a valid 10-digit phone number'
                          : null,
                    ),
                    _buildTextField(
                      controller: _bankAccountNumberController,
                      label: 'Bank Account Number',
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty || value.length != 10
                          ? 'Please enter a valid 10-digit account number'
                          : null,
                    ),
                    _buildTextField(
                      controller: _bankNameController,
                      label: 'Bank Name',
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter the bank name' : null,
                    ),
                    _buildTextField(
                      controller: _ifscCodeController,
                      label: 'IFSC Code',
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter the IFSC code' : null,
                    ),
                    _buildTextField(
                      controller: _accountTypeController,
                      label: 'Account Type',
                      validator: (value) => value!.isEmpty
                          ? 'Please enter the account type'
                          : null,
                    ),
                    _buildTextField(
                      controller: _branchNameController,
                      label: 'Branch Name',
                      validator: (value) => value!.isEmpty
                          ? 'Please enter the branch name'
                          : null,
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
                      validator: (value) => value!.isEmpty || value.length < 6
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
      ),
    );
  }
}
