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
  final TextEditingController _sponsorIdController = TextEditingController();

  final UserService _userService = UserService();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  List<dynamic> _sponsors = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchSponsors();
  }

  Future<void> _fetchSponsors() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await _userService.getAllSponsors();
      setState(() {
        _sponsors = response.data;
      });
    } catch (e) {
      _showSnackBar("Failed to load sponsors. Try again.", Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final allValues = await _storage.readAll();
        final user = jsonDecode(allValues['user']!);

        final request = {
          "description": _descriptionController.text.trim(),
          "amount": _amountController.text.trim(),
          "ngoid": user['_id'],
          "sponsorid": _sponsorIdController.text.trim(),
        };

        await _userService.addSponsorRequest(jsonEncode(request));
        _showSnackBar("Request submitted successfully!", Colors.green);
        Navigator.pop(context);
      } catch (e) {
        _showSnackBar("Submission failed. Try again.", Colors.red);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _sponsorIdController.dispose();
    super.dispose();
  }

  // ... (imports and class declaration remain the same)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sponsorship Request",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 101, 121, 220),
        elevation: 5,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: const Color.fromARGB(255, 255, 187, 85),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Send Request',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 11, 11, 11),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _descriptionController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'Description',
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 18, 18, 18)),
                                prefixIcon: Icon(Icons.description,
                                    color: Colors.black),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                      ? 'Please enter a description'
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Amount',
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 18, 18, 18)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: const Icon(Icons.description,
                                    color: Colors.black),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter an amount';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Enter a valid number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Select Sponsor',
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 18, 18, 18)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              value: _sponsorIdController.text.isEmpty
                                  ? null
                                  : _sponsorIdController.text,
                              items: _sponsors
                                  .map<DropdownMenuItem<String>>((sponsor) {
                                return DropdownMenuItem<String>(
                                  value: sponsor['_id'],
                                  child: Text(sponsor['name']),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _sponsorIdController.text = value!;
                                });
                              },
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Please select a sponsor'
                                      : null,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.send, color: Colors.white),
                              label: const Text(
                                'Submit Request',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6579DC),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: _submitForm,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
