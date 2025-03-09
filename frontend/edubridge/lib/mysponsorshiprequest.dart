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
      ),
      body: sponsorships.length == 0
          ? Center(
              child: Text("No sponsorship request"),
            )
          : ListView.builder(
              itemCount: sponsorships.length,
              itemBuilder: (context, index) {
                return Card(
                    child: Column(
                  children: [
                    ListTile(
                      trailing: Text(
                        sponsorships[index]['status'],
                        style: TextStyle(color: Colors.red),
                      ),
                      title: Text(sponsorships[index]['description']),
                      subtitle: Text(sponsorships[index]['amount'].toString() +
                          "Rs\n" +
                          sponsorships[index]['sponsorid']['name'] +
                          "\n" +
                          sponsorships[index]['sponsorid']['email'] +
                          "\n" +
                          sponsorships[index]['sponsorid']['phone_number']
                              .toString()),
                    ),
                  ],
                ));
              },
            ),
    );
  }
}
