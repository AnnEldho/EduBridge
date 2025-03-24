import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:flutter/material.dart';

class GetPendingCollege extends StatefulWidget {
  const GetPendingCollege({super.key});

  @override
  State<GetPendingCollege> createState() => _GetPendingCollegeState();
}

class _GetPendingCollegeState extends State<GetPendingCollege> {
  UserService _userService = UserService();
  bool isLoading = true;
  List<dynamic> pendingCollege = [];
  Future<void> changeStatus(String id, String status, int index) async {
    print("Changing Status");
    var userdata = jsonEncode({"id": id, "status": status});
    try {
      final response = await _userService.changeStatus(userdata);
      print(response.data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("${status} Successfully"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ));
      //print(pendingCollege);
      setState(() {
        pendingCollege.removeAt(index);
      });
      //print(pendingCollege);
    } on DioException catch (e) {
      print(e.error);
    }
  }

  Future<void> getPendingCollege() async {
    setState(() {
      isLoading = true;
    });
    print("Getting Pending College");
    try {
      final response = await _userService.getPendingCollege();
      print(response.data);
      setState(() {
        pendingCollege = response.data;
        isLoading = false;
      });
    } on DioException catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.error);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPendingCollege();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pending College')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pendingCollege.length,
              itemBuilder: (context, index) {
                final college = pendingCollege[index]['college'];
                final user = pendingCollege[index]['user'];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${user['name']}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 5),
                                  Text(
                                      'Incharge Name: ${college['incharge_name']}'),
                                  Text(
                                      'Incharge Email: ${college['incharge_email']}'),
                                  Text(
                                      'Incharge Phone: ${college['incharge_phone']}'),
                                  Divider(),
                                  Text(
                                    'Contact Details',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text('Email: ${user['email']}',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black87)),
                                  Text('Phone: ${user['phone_number']}',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black87)),
                                  Text(
                                      'Location: ${user['place']}, ${user['district']}',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black87)),
                                  Text(
                                      'State: ${user['state']} - ${user['pincode']}',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black87)),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Image.memory(
                                          base64Decode(
                                              college['idproof'].split(',')[1]),
                                          fit: BoxFit.contain,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            return const Icon(Icons.image,
                                                size: 100);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Image.memory(
                                base64Decode(college['idproof'].split(',')[1]),
                                fit: BoxFit.contain,
                                width: 200, // Set the desired width
                                height: 200, // Set the desired height
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return const Icon(Icons.image, size: 100);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                changeStatus(
                                    pendingCollege[index]["user"]['_id'],
                                    'Approved',
                                    index);
                              },
                              child: Text('Approve'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                changeStatus(
                                    pendingCollege[index]["user"]['_id'],
                                    'Rejected',
                                    index);
                              },
                              child: Text('Reject'),
                            ),
                          ],
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
