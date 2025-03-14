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
        content: Text("Error occurred,please try again"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  addReply() async {
    if (_reply.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please add reply tetx"),
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
                title: Text("Reply Added"),
                content: Text("Reply added successfully"),
                actions: [
                  TextButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      } on DioException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error occurred,please try again"),
          duration: Duration(milliseconds: 300),
        ));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getComplaint();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Complaints")),
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(padding: EdgeInsets.all(20), children: [
              SubHeadingText(
                  text: _data["subject"],
                  align: TextAlign.left,
                  color: Colors.black),
              DescriptionText(
                  text: _data["complaint"],
                  align: TextAlign.justify,
                  color: Colors.black),
              SizedBox(
                height: 10,
              ),
              if (_data["reply"] == null) ...[
                Text(
                  "Add Reply",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _reply,
                  decoration: InputDecoration(
                    label: Text("Reply"),
                    prefixIcon: Icon(Icons.send),
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: 5,
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return "Please Enter somthing";
                    }
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      addReply();
                    },
                    child: Text("Add Reply"))
              ] else ...[
                Text("Reply :" + _data["reply"])
              ],
              SizedBox(
                height: 10,
              ),
              DescriptionText(
                  text: "Status: " + _data["status"],
                  align: TextAlign.left,
                  color: Colors.black),
              DescriptionText(
                  text: DateTime.fromMicrosecondsSinceEpoch(
                          int.parse(_data["timestamp"]) * 1000)
                      .toString(),
                  align: TextAlign.left,
                  color: Colors.black),
            ]),
    );
  }
}