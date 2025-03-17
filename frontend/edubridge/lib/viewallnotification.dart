import 'package:dio/dio.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:edubridge/viewnotificationsingle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class ViewAllNotification extends StatefulWidget {
  const ViewAllNotification({super.key});

  @override
  State<ViewAllNotification> createState() => _ViewAllNotificationState();
}

class _ViewAllNotificationState extends State<ViewAllNotification> {
  final UserService userService = UserService();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  List<dynamic> _data = [];
  bool isLoading = false;
  String formatDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return "No Date";
    }
    try {
      DateTime parsedDate = DateTime.parse(dateTimeString);
      return DateFormat('dd MMM yyyy, hh:mm a').format(parsedDate);
      // Example: 15 Mar 2025, 08:30 PM
    } catch (e) {
      return "Invalid Date";
    }
  }

  Future<void> getAllNotifications() async {
    if (!mounted) return; // Prevent calling setState if widget is not in tree

    setState(() {
      isLoading = true;
    });

    try {
      final Response res = await userService.getAllNotifications();
      if (mounted) {
        setState(() {
          _data = res.data ?? []; // Ensure _data is always a list
          isLoading = false;
        });
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error fetching notifications. Please try again."),
          duration: Duration(seconds: 2),
        ),
      );
      debugPrint("Error: ${e.message}");
    }
  }

  @override
  void initState() {
    super.initState();
    getAllNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Notifications")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _data.isEmpty
              ? const Center(child: Text("No Notifications"))
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: _data.length,
                  itemBuilder: (context, index) {
                    final notification = _data[index] ?? {}; // Ensure not null
                    return ListTile(
                      title: Text(notification['title'] ?? "No Title"),
                      subtitle:
                          Text(notification['description'] ?? "No Description"),
                      trailing: Text(formatDateTime(_data[index]['datetime'])),
                      onTap: () {
                        if (notification["_id"] != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewNotificationSingle(
                                notificationid: notification["_id"],
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Invalid Notification"),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
    );
  }
}
