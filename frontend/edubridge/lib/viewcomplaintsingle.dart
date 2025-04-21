import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:edubridge/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

class ViewComplaintsSingle extends StatefulWidget {
  const ViewComplaintsSingle({super.key, required this.complaintid});
  final String complaintid;

  @override
  State<ViewComplaintsSingle> createState() => _ViewComplaintsSingleState();
}

class _ViewComplaintsSingleState extends State<ViewComplaintsSingle> {
  UserService _userService = UserService();
  dynamic _data;
  bool isloading = false;
  TextEditingController _reply = TextEditingController();

  getComplaint() async {
    if (mounted) {
      setState(() {
        isloading = true;
      });
    }
    try {
      final Response res =
          await _userService.getComplaintById(widget.complaintid);
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

  addReply() async {
    if (_reply.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please add reply text"),
        duration: Duration(milliseconds: 300),
      ));
    } else {
      var details =
          jsonEncode({"complaintid": widget.complaintid, "reply": _reply.text});
      try {
        final Response res = await _userService.addReplyToComplaint(details);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Reply Added"),
                content: const Text("Reply added successfully"),
                actions: [
                  TextButton(
                    child: const Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      } on DioException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error occurred, please try again"),
          duration: Duration(milliseconds: 300),
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getComplaint();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Complaints",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subject Text
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

                  const SizedBox(height: 12),

                  // Complaint Description
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

                  // Add Reply Section or Display Reply
                  if (_data["reply"] == null) ...[
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _reply,
                      decoration: const InputDecoration(
                        labelText: "Reply",
                        prefixIcon: Icon(Icons.send),
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                      keyboardType: TextInputType.text,
                      maxLines: 5,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: addReply,
                      child: const Text("Add Reply"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ] else ...[
                    // Displaying Existing Reply
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Reply: ${_data["reply"]}",
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),

                  // Status Text
                  if (_data["status"] == "Pending") ...[
                    Text(
                      "Status: ${_data["status"]}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 0, 0),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ] else ...[
                    DescriptionText(
                      text: "Status: ${_data["status"]}",
                      align: TextAlign.left,
                      color: Colors.black87,
                    ),
                  ],
                  const SizedBox(height: 12),

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

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
