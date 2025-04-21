import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class ViewScholarshipSingle extends StatefulWidget {
  const ViewScholarshipSingle({super.key, required this.id});
  final String id;

  @override
  State<ViewScholarshipSingle> createState() => _ViewScholarshipSingleState();
}

class _ViewScholarshipSingleState extends State<ViewScholarshipSingle> {
  final UserService _userService = UserService();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  dynamic scholarshipData;

  @override
  void initState() {
    super.initState();
    _fetchScholarshipDetails();
  }

  Future<void> _fetchScholarshipDetails() async {
    try {
      final response = await _userService.viewScholarshipById(widget.id);
      setState(() {
        scholarshipData = response.data;
      });
    } on DioException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error occurred, please try again."),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> joinScholorship() async {
    Map<String, String> allValues = await _storage.readAll();
    var user = allValues['user'];
    print(user);
    var userMap = jsonDecode(user!);
    var jsonData = jsonEncode({
      "scholorshipid": widget.id,
      "userid": userMap["_id"],
      "providerid": scholarshipData['userid']
    });
    try {
      final response = await _userService.joinScholarship(jsonData);
      print(response.data);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Scholarship applied successfully"),
        duration: Duration(milliseconds: 3000),
        backgroundColor: Colors.green,
      ));
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.response?.data["message"]),
        duration: Duration(milliseconds: 3000),
      ));
    }
  }

  Widget _buildScholarshipDetails() {
    final closingDate = DateTime.parse(scholarshipData['closing_date']);
    final isClosed = closingDate.isBefore(DateTime.now());

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailRow(
            label: "Title",
            value: scholarshipData['title'],
            icon: Icons.school,
          ),
          DetailRow(
            label: "Description",
            value: scholarshipData['description'],
            icon: Icons.description,
          ),
          DetailRow(
            label: "Amount",
            value: "₹${scholarshipData['amount']}",
            icon: Icons.attach_money,
          ),
          DetailRow(
            label: "Opening Date",
            value: DateFormat.yMMMd().format(
              DateTime.parse(scholarshipData['opening_date']),
            ),
            icon: Icons.calendar_today,
          ),
          DetailRow(
            label: "Closing Date",
            value: DateFormat.yMMMd().format(
              DateTime.parse(scholarshipData['closing_date']),
            ),
            icon: Icons.calendar_today_outlined,
          ),
          const SizedBox(height: 20),
          if (isClosed)
            const Center(
              child: Text(
                "Applying date has been closed",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            Center(
              child: ElevatedButton.icon(
                onPressed: joinScholorship,
                icon: const Icon(Icons.send),
                label: const Text("Apply Now"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scholarship Details"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: scholarshipData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(child: _buildScholarshipDetails()),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) Icon(icon, color: Colors.blueAccent, size: 24),
          if (icon != null) const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$label: ",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.black87,
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
