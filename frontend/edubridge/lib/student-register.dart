import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StudentRegistrationForm extends StatefulWidget {
  const StudentRegistrationForm({super.key});

  @override
  State<StudentRegistrationForm> createState() =>
      _StudentRegistrationFormState();
}

class _StudentRegistrationFormState extends State<StudentRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _houseNameController = TextEditingController();
  final _talukController = TextEditingController();
  final _districtController = TextEditingController();
  final _stateController = TextEditingController();
  final _nationalityController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _aadharNumberController = TextEditingController();
  final _institutionNameController = TextEditingController();
  final _courseController = TextEditingController();
  final _yearOfEnrollmentController = TextEditingController();
  final _academicYearController = TextEditingController();
  final _cgpaController = TextEditingController();
  final _bankAccountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _accountTypeController = TextEditingController();
  final _branchNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  UserService userService = UserService();
  List<dynamic> collegeList = [];
  XFile? _imageFile;
  bool isloading = false;
  Future<void> getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image;
    });
  }

  Future<void> getCollegeList() async {
    try {
      final response = await userService.getCollegeList();
      print(response.data);
      setState(() {
        collegeList = response.data;
      });
    } on DioException catch (e) {
      print(e.response!.data);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCollegeList();
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
      "dob": _dobController.text,
      "gender": _genderController.text,
      "email": _emailController.text,
      "phone_number": _phoneController.text,
      "house_name": _houseNameController.text,
      "taluk": _talukController.text,
      "district": _districtController.text,
      "state": _stateController.text,
      "nationality": _nationalityController.text,
      "pincode": _pincodeController.text,
      "aadhar_number": _aadharNumberController.text,
      "instituition": _institutionNameController.text,
      "course": _courseController.text,
      "academic_year": _academicYearController.text,
      "cgpa": _cgpaController.text,
      "account_number": _bankAccountNumberController.text,
      "bank_name": _bankNameController.text,
      "ifsc_code": _ifscCodeController.text,
      "branch_name": _branchNameController.text,
      "password": _passwordController.text,
      "confirm_password": _confirmPasswordController.text,
      "usertype": "Student",
      "idproof": pic
    });
    print(userdata);
    try {
      final response = await userService.registerUser(userdata);
      print(response.data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration Successful!'),
          duration: const Duration(seconds: 2),
        ),
      );
      setState(() {
        isloading = false;
      });
      Navigator.pop(context);
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
    _dobController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _houseNameController.dispose();
    _talukController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    _nationalityController.dispose();
    _pincodeController.dispose();
    _aadharNumberController.dispose();
    _institutionNameController.dispose();
    _courseController.dispose();
    _yearOfEnrollmentController.dispose();
    _academicYearController.dispose();
    _cgpaController.dispose();
    _bankAccountNumberController.dispose();
    _bankNameController.dispose();
    _ifscCodeController.dispose();
    _accountTypeController.dispose();
    _branchNameController.dispose();
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
        title: const Text('Student Registration'),
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
                          controller: _nameController,
                          label: 'Name',
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter your  name' : null,
                        ),
                        GestureDetector(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _dobController.text =
                                    "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: _buildTextField(
                              controller: _dobController,
                              label: 'Date of Birth',
                              keyboardType: TextInputType.datetime,
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter your date of birth'
                                  : null,
                            ),
                          ),
                        ),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(labelText: 'Gender'),
                          value: _genderController.text.isEmpty
                              ? null
                              : _genderController.text,
                          items:
                              ['Male', 'Female', 'Other'].map((String gender) {
                            return DropdownMenuItem<String>(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _genderController.text = newValue!;
                            });
                          },
                          validator: (value) => value == null
                              ? 'Please select your gender'
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
                          controller: _phoneController,
                          label: 'Phone',
                          keyboardType: TextInputType.phone,
                          validator: (value) =>
                              value!.isEmpty || value.length != 10
                                  ? 'Please enter a valid 10-digit phone number'
                                  : null,
                        ),
                        _buildTextField(
                          controller: _houseNameController,
                          label: 'House Name',
                          validator: (value) => value!.isEmpty
                              ? 'Please enter your house name'
                              : null,
                        ),
                        _buildTextField(
                          controller: _talukController,
                          label: 'Taluk',
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter your taluk' : null,
                        ),
                        _buildTextField(
                          controller: _districtController,
                          label: 'District',
                          validator: (value) => value!.isEmpty
                              ? 'Please enter your district'
                              : null,
                        ),
                        _buildTextField(
                          controller: _nationalityController,
                          label: 'Nationality',
                          validator: (value) => value!.isEmpty
                              ? 'Please enter your nationality'
                              : null,
                        ),
                        _buildTextField(
                          controller: _stateController,
                          label: 'State',
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter your state' : null,
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
                          controller: _aadharNumberController,
                          label: 'Aadhar Number',
                          keyboardType: TextInputType.number,
                          validator: (value) => value!.isEmpty ||
                                  value.length != 12
                              ? 'Please enter a valid 12-digit Aadhar number'
                              : null,
                        ),
                        DropdownButtonFormField(
                          decoration:
                              InputDecoration(labelText: 'Institution Name'),
                          value: _institutionNameController.text.isEmpty
                              ? null
                              : _institutionNameController.text,
                          items: collegeList
                              .where((college) =>
                                  college['user']['status'] ==
                                  'Approved') // Filtering
                              .map<DropdownMenuItem<String>>((college) {
                            return DropdownMenuItem<String>(
                              value: college['user']['_id'],
                              child: Text(college['user']['name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _institutionNameController.text = value as String;
                            });
                          },
                          validator: (value) => value == null
                              ? 'Please select your institution'
                              : null,
                        ),
                        _buildTextField(
                          controller: _courseController,
                          label: 'Course',
                          validator: (value) => value!.isEmpty
                              ? 'Please enter your course'
                              : null,
                        ),
                        _buildTextField(
                          controller: _academicYearController,
                          label: 'Academic Year',
                          validator: (value) => value!.isEmpty
                              ? 'Please enter your academic year'
                              : null,
                        ),
                        _buildTextField(
                          controller: _cgpaController,
                          label: "CGPA",
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter your CGPA' : null,
                        ),
                        _buildTextField(
                          controller: _bankAccountNumberController,
                          label: 'Bank Account Number',
                          keyboardType: TextInputType.number,
                          validator: (value) => value!.isEmpty
                              ? 'Please enter your bank account number'
                              : null,
                        ),
                        _buildTextField(
                          controller: _bankNameController,
                          label: 'Bank Name',
                          validator: (value) => value!.isEmpty
                              ? 'Please enter your bank name'
                              : null,
                        ),
                        _buildTextField(
                          controller: _ifscCodeController,
                          label: 'IFSC Code',
                          validator: (value) => value!.isEmpty
                              ? 'Please enter your IFSC code'
                              : null,
                        ),
                        _buildTextField(
                          controller: _branchNameController,
                          label: 'Branch Name',
                          validator: (value) => value!.isEmpty
                              ? 'Please enter your branch name'
                              : null,
                        ),
                        GestureDetector(
                            onTap: getImageFromGallery,
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                // border: Border.fromBorderSide(BorderSide(
                                //     style: BorderStyle.solid,

                                //     color: Theme.of(context).primaryColor)),

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
