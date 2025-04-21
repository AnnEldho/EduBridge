import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MySponsorshipRequest extends StatefulWidget {
  const MySponsorshipRequest({super.key});

  @override
  State<MySponsorshipRequest> createState() => _MySponsorshipRequestState();
}

class _MySponsorshipRequestState extends State<MySponsorshipRequest> {
  UserService userService = UserService();
  final storage = FlutterSecureStorage();
  List<dynamic> sponsorships = [];
  Future<void> getMySponsorshipRequest() async {
    Map<String, String> allValues = await storage.readAll();
    var user = allValues['user'];
    print(user);
    var userMap = jsonDecode(user!);
    try {
      final response =
          await userService.viewSponsorRequestByNgoId(userMap['_id']);
      print(response.data);
      setState(() {
        sponsorships = response.data;
      });
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred,please try again"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMySponsorshipRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Sponsorship Request'),
        backgroundColor: const Color(0xFF6579DC),
        centerTitle: true,
      ),
      body: sponsorships.isEmpty
          ? const Center(
              child: Text(
                "No sponsorship request",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: sponsorships.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final sponsor = sponsorships[index]['sponsorid'];
                return Card(
                  color: const Color(0xFFFFBB55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Description + Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                sponsorships[index]['description'],
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Text(
                              sponsorships[index]['status'],
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.black54,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.currency_rupee,
                              color: Colors.black87,
                              size: 18,
                            ),
                            Text(
                              '${sponsorships[index]['amount']}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const Text(
                              ' Rs',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 5, 5, 5),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.black54,
                        ),
                        const Text(
                          "Requested to:",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${sponsor['name']}",
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        Text(
                          "${sponsor['email']}",
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        Text(
                          "${sponsor['phone_number']}",
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
