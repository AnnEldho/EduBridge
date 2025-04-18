import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EditSponsorProfile extends StatefulWidget {
  const EditSponsorProfile({super.key});

  @override
  State<EditSponsorProfile> createState() => _EditSponsorProfileState();
}

class _EditSponsorProfileState extends State<EditSponsorProfile> {
  final _formKey = GlobalKey<FormState>();
  final storage = FlutterSecureStorage();

  // Controllers for each field
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final placeController = TextEditingController();
  final talukController = TextEditingController();
  final districtController = TextEditingController();
  final pincodeController = TextEditingController();
  final stateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    var allValues = await storage.readAll();
    var user = allValues['user'];
    if (user != null) {
      var userMap = jsonDecode(user);
      setState(() {
        nameController.text = userMap['name'] ?? '';
        emailController.text = userMap['email'] ?? '';
        phoneController.text = userMap['phone'] ?? '';
        placeController.text = userMap['place'] ?? '';
        talukController.text = userMap['taluk'] ?? '';
        districtController.text = userMap['district'] ?? '';
        pincodeController.text = userMap['pincode'] ?? '';
        stateController.text = userMap['state'] ?? '';
      });
    }
  }

  void updateProfile() async {
    if (_formKey.currentState!.validate()) {
      // Create updated user map
      var updatedUser = {
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'place': placeController.text,
        'taluk': talukController.text,
        'district': districtController.text,
        'pincode': pincodeController.text,
        'state': stateController.text,
      };

      // Save to storage
      await storage.write(key: 'user', value: jsonEncode(updatedUser));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      Navigator.pop(context);
    }
  }

  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text, bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value!.isEmpty ? 'Enter $label' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color.fromARGB(255, 101, 121, 220),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
                buildTextField("Name", nameController, readOnly: true),
              buildTextField("Email", emailController,
                  type: TextInputType.emailAddress),
              buildTextField("Phone Number", phoneController,
                  type: TextInputType.phone),
              buildTextField("Place", placeController),
              buildTextField("Taluk", talukController),
              buildTextField("District", districtController),
              buildTextField("Pincode", pincodeController,
                  type: TextInputType.number),
              buildTextField("State", stateController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 101, 121, 220),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Update Profile",
                    style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
