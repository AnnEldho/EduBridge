import 'package:edubridge/services/user_service.dart';
import 'package:dio/dio.dart';
import 'package:edubridge/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

class ViewMyComplaintsSingle extends StatefulWidget {
  const ViewMyComplaintsSingle({super.key, required this.complaintid});
  final String complaintid;

  @override
  State<ViewMyComplaintsSingle> createState() => _ViewMyComplaintsSingleState();
}

class _ViewMyComplaintsSingleState extends State<ViewMyComplaintsSingle> {
  UserService _utilityService = UserService();
  dynamic _data;
  bool isloading = false;

  getComplaint() async {
    if (mounted) {
      setState(() {
        isloading = true;
      });
    }
    try {
      final Response res =
          await _utilityService.getComplaintById(widget.complaintid);
      print(res.data);
      if (mounted) {
        setState(() {
          _data = res.data;
          isloading = false;
        });
      }
    } on DioException catch (e) {
      setState(() {
        isloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred, please try again"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  @override
  void initState() {
    getComplaint();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complaints")),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      _data["subject"],
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16, // Smaller size
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      _data["complaint"],
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16, // Smaller size
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_data["reply"] != null) ...[
                    Text(
                      "Reply: ${_data["reply"]}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 11, 11, 11),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  Text(
                    "Status: ${_data["status"]}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 247, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Date Text
                  Text(
                    "Date: ${DateTime.fromMicrosecondsSinceEpoch(int.parse(_data["timestamp"]) * 1000).toString().split(' ')[0]}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
