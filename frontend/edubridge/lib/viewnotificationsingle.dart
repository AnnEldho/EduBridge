import 'package:dio/dio.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:edubridge/widgets/text_widgets.dart';
import 'package:flutter/material.dart';

class ViewNotificationSingle extends StatefulWidget {
  const ViewNotificationSingle({super.key, required this.notificationid});
  final String notificationid;

  @override
  State<ViewNotificationSingle> createState() => _ViewNotificationSingleState();
}

class _ViewNotificationSingleState extends State<ViewNotificationSingle> {
  final UserService _userService = UserService();
  dynamic _data;
  bool isloading = false;

  getNotification() async {
    if (mounted) {
      setState(() {
        isloading = true;
      });
    }
    try {
      final Response res =
          await _userService.getNotificationById(widget.notificationid);
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error occurred, please try again.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Details"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 4,
      ),
      body: isloading
          ? const Center(child: CircularProgressIndicator())
          : _data == null
              ? const Center(
                  child: Text(
                    "No Notification Found",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Title:",
                            style: TextStyle(
                              fontSize: 22, // Changed font size
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 5),
                          SubHeadingText(
                            text: _data["title"],
                            align: TextAlign.left,
                            color: Colors.black87,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "Description:",
                            style: TextStyle(
                              fontSize: 22, // Changed font size
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 5),
                          DescriptionText(
                            text: _data["description"],
                            align: TextAlign.justify,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
