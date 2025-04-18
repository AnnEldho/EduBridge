import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SponsorShipRequest extends StatefulWidget {
  const SponsorShipRequest({super.key});

  @override
  State<SponsorShipRequest> createState() => _SponsorShipRequestState();
}

class _SponsorShipRequestState extends State<SponsorShipRequest> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _sponsoridController = TextEditingController();
  UserService userService = UserService();
  final storage = FlutterSecureStorage();
  List<dynamic> sponsors = [];

  Future<void> getAllSponsors() async {
    try {
      final response = await userService.getAllSponsors();
      setState(() {
        sponsors = response.data;
      });
    } on DioException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error occurred, please try again"),
          duration: Duration(milliseconds: 300),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getAllSponsors();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _sponsoridController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Map<String, String> allValues = await storage.readAll();
      var user = jsonDecode(allValues['user']!);
      var jsonData = jsonEncode({
        "description": _descriptionController.text,
        "amount": _amountController.text,
        "ngoid": user['_id'],
        "sponsorid": _sponsoridController.text,
      });
      try {
        await userService.addSponsorRequest(jsonData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Request added successfully"),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } on DioException {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error occurred, please try again"),
            duration: Duration(milliseconds: 300),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sponsorship Request"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 101, 121, 220),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: 'Sponsor',
                      border: OutlineInputBorder(),
                    ),
                    value: _sponsoridController.text.isEmpty
                        ? null
                        : _sponsoridController.text,
                    items: sponsors.map<DropdownMenuItem<String>>((sponsor) {
                      return DropdownMenuItem<String>(
                        value: sponsor['_id'],
                        child: Text(sponsor['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _sponsoridController.text = value as String;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a sponsor';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 40),
                    ),
                    onPressed: _submitForm,
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 101, 121, 220)),
                    ),
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
