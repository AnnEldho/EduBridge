import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApproveSponsorRequest extends StatefulWidget {
  const ApproveSponsorRequest({super.key});

  @override
  State<ApproveSponsorRequest> createState() => _ApproveSponsorRequestState();
}

class _ApproveSponsorRequestState extends State<ApproveSponsorRequest> {
  final UserService _userService = UserService();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  List<dynamic> sponsorships = [];
  bool isLoading = true;

  // Fetch sponsorship requests
  Future<void> getApproveSponsorRequest() async {
    try {
      Map<String, String> allValues = await _storage.readAll();
      var user = allValues['user'];
      var userMap = jsonDecode(user!);

      final response =
          await _userService.viewSponsorRequestBySponsorId(userMap['_id']);
      setState(() {
        sponsorships = response.data;
        isLoading = false;
      });
    } on DioException catch (_) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error occurred, please try again"),
          duration: Duration(milliseconds: 300),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getApproveSponsorRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Sponsorship Requests',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : sponsorships.isEmpty
              ? const Center(
                  child: Text(
                    "No sponsorship requests available",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: sponsorships.length,
                  itemBuilder: (context, index) {
                    final sponsorship = sponsorships[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                      color: const Color.fromARGB(255, 255, 180, 68),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                sponsorship['description'],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Amount: ${sponsorship['amount']} Rs',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'NGO: ${sponsorship['ngoid']['name']}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                  Text(
                                    'Email: ${sponsorship['ngoid']['email']}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                  Text(
                                    'Phone: ${sponsorship['ngoid']['phone_number']}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: sponsorship['status'] == "requested"
                                      ? Colors.orange
                                      : Colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  sponsorship['status'],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            if (sponsorship['status'] == "requested")
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () =>
                                          _updateSponsorRequestStatus(
                                              sponsorship['_id'], "Approved"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        "Approve",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          _updateSponsorRequestStatus(
                                              sponsorship['_id'], "Rejected"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        "Reject",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  // Update sponsorship request status
  void _updateSponsorRequestStatus(String id, String status) {
    final jsonData = jsonEncode({"status": status, "id": id});
    _userService.updateSponsorRequestStatus(jsonData).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Request $status"),
          duration: const Duration(seconds: 3),
          backgroundColor: status == "Approved" ? Colors.green : Colors.red,
        ),
      );
      getApproveSponsorRequest();
    }).catchError((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error occurred, please try again"),
          duration: Duration(milliseconds: 300),
        ),
      );
    });
  }
}
