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
  UserService userService = UserService();
  final storage = FlutterSecureStorage();
  List<dynamic> sponsorships = [];
  Future<void> getApproveSponsorRequest() async {
    Map<String, String> allValues = await storage.readAll();
    var user = allValues['user'];
    print(user);
    var userMap = jsonDecode(user!);
    try {
      final response =
          await userService.viewSponsorRequestBySponsorId(userMap['_id']);
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
    getApproveSponsorRequest();
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
                          sponsorships[index]['ngoid']['name'] +
                          "\n" +
                          sponsorships[index]['ngoid']['email'] +
                          "\n" +
                          sponsorships[index]['ngoid']['phone_number']
                              .toString()),
                    ),
                    sponsorships[index]['status'] == "requested"
                        ? Row(
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    var jsonData = jsonEncode({
                                      "status": "Approved",
                                      "id": sponsorships[index]['_id']
                                    });
                                    userService
                                        .updateSponsorRequestStatus(jsonData)
                                        .then((value) {
                                      print(value.data);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text("Request approved"),
                                        duration: Duration(
                                          milliseconds: 3000,
                                        ),
                                        backgroundColor: Colors.green,
                                      ));
                                      getApproveSponsorRequest();
                                    }).catchError((e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "Error occurred,please try again"),
                                        duration: Duration(milliseconds: 300),
                                      ));
                                    });
                                  },
                                  child: Text("Approve")),
                              ElevatedButton(
                                  onPressed: () {
                                    var jsonData = jsonEncode({
                                      "status": "Rejected",
                                      "id": sponsorships[index]['_id']
                                    });
                                    userService
                                        .updateSponsorRequestStatus(jsonData)
                                        .then((value) {
                                      print(value.data);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text("Request rejected"),
                                        duration: Duration(
                                          milliseconds: 3000,
                                        ),
                                        backgroundColor: Colors.green,
                                      ));
                                      getApproveSponsorRequest();
                                    }).catchError((e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "Error occurred,please try again"),
                                        duration: Duration(milliseconds: 300),
                                      ));
                                    });
                                  },
                                  child: Text("Reject")),
                            ],
                          )
                        : Container()
                  ],
                ));
              },
            ),
    );
  }
}
