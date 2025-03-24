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
      appBar: AppBar(title: Text("Complaints")),
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
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
                  if (_data["reply"] != null) ...[
                    Text(
                      "Reply: " + _data["reply"],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  DescriptionText(
                    text: "Status: " + _data["status"],
                    align: TextAlign.left,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  DescriptionText(
                    text: DateTime.fromMicrosecondsSinceEpoch(
                            int.parse(_data["timestamp"]) * 1000)
                        .toString(),
                    align: TextAlign.left,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
    );
  }
}
