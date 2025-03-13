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
  final TextEditingController _ngoidController = TextEditingController();
  final TextEditingController _sponsoridController = TextEditingController();
  UserService userService = UserService();
  final storage = FlutterSecureStorage();
  List<dynamic> sponsors = [];
  Future<void> getAllSponsors() async {
    try {
      final response = await userService.getAllSponsors();
      print(response.data);
      setState(() {
        sponsors = response.data;
      });
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred,please try again"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllSponsors();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _ngoidController.dispose();
    _sponsoridController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      Map<String, String> allValues = await storage.readAll();
      var user = allValues['user'];
      print(user);
      var userMap = jsonDecode(user!);
      // Process the data
      var jsonData = jsonEncode({
        "description": _descriptionController.text,
        "amount": _amountController.text,
        "ngoid": userMap['_id'],
        "sponsorid": _sponsoridController.text,
      });
      try {
        final response = await userService.addSponsorRequest(jsonData);
        print(response.data);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Request added successfully"),
          duration: Duration(
            milliseconds: 3000,
          ),
          backgroundColor: Colors.green,
        ));
        Navigator.pop(context);
      } on DioException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error occurred,please try again"),
          duration: Duration(milliseconds: 300),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sponsorship Request"),
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
                children: <Widget>[
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(labelText: 'Amount'),
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
                  DropdownButtonFormField(
                    decoration: InputDecoration(labelText: 'Sponsor'),
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
                        return 'Please select a Sponsor';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Submit'),
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
