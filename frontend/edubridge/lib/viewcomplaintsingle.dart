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
        title: const Text("Complaints"),
        backgroundColor: Colors.blueAccent,
      ),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubHeadingText(
                    text: _data["subject"],
                    align: TextAlign.left,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  DescriptionText(
                    text: _data["complaint"],
                    align: TextAlign.justify,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 20),
                  if (_data["reply"] == null) ...[
                    const Text(
                      "Add Reply",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _reply,
                      decoration: const InputDecoration(
                        labelText: "Reply",
                        prefixIcon: Icon(Icons.send),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                      maxLines: 5,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: addReply,
                      child: const Text("Add Reply"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Reply: ${_data["reply"]}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  DescriptionText(
                    text: "Status: ${_data["status"]}",
                    align: TextAlign.left,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  DescriptionText(
                    text:
                        "Date: ${DateTime.fromMicrosecondsSinceEpoch(int.parse(_data["timestamp"]) * 1000)}",
                    align: TextAlign.left,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
