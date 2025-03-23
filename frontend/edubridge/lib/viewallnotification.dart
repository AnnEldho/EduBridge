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
    } catch (e) {
      return "Invalid Date";
    }
  }

  Future<void> getAllNotifications() async {
    if (!mounted) return;

    setState(() => isLoading = true);

    try {
      final Response res = await userService.getAllNotifications();
      if (mounted) {
        setState(() {
          _data = res.data ?? [];
          isLoading = false;
        });
      }
    } on DioException {
      if (mounted) {
        setState(() => isLoading = false);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error fetching notifications. Please try again."),
          duration: Duration(seconds: 2),
        ),
      );
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
      appBar: AppBar(
        title: const Text("All Notifications"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _data.isEmpty
              ? const Center(
                  child: Text(
                    "No Notifications",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                )
              : Column(
                  children: [
                    Flexible(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _data.length,
                        itemBuilder: (context, index) {
                          final notification = _data[index] ?? {};
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                        notification['title'] ?? "No Title"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notification['description'] ??
                                              "No Description",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          formatDateTime(
                                              notification['datetime']),
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Close"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: Color.fromARGB(255, 255, 180, 68),
                              elevation: 5,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                title: Text(
                                  notification['title'] ?? "No Title",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: notification['isOpened'] == true
                                        ? const Color.fromARGB(255, 0, 0, 0)
                                        : const Color.fromARGB(
                                            255, 101, 121, 220),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    notification['description'] ??
                                        "No Description",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      formatDateTime(notification['datetime']),
                                      style: const TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
