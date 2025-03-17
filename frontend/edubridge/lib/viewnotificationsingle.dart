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
  UserService _userService = UserService();
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
    super.initState();
    getNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notification Details")),
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _data == null
              ? const Center(
                  child: Text("No Notification Found"),
                )
              : Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Title :",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SubHeadingText(
                        text: _data["title"],
                        align: TextAlign.left,
                        color: Colors.black,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Description :",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      DescriptionText(
                        text: _data["description"],
                        align: TextAlign.justify,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
    );
  }
}
