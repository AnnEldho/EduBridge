import 'package:dio/dio.dart';
import 'package:edubridge/getpendingcollege.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:flutter/material.dart';

class CollegeList extends StatefulWidget {
  const CollegeList({super.key});

  @override
  State<CollegeList> createState() => _CollegeListState();
}

class _CollegeListState extends State<CollegeList> {
  UserService _userService = UserService();
  bool isLoading = true;
  List<dynamic> approvedColleges = [];

  Future<void> getApprovedColleges() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await _userService.getCollegeList();
      setState(() {
        approvedColleges = response.data;
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
    super.initState();
    getApprovedColleges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('College List', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GetPendingCollege()),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'View Pending Colleges',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: approvedColleges.length,
                    itemBuilder: (context, index) {
                      final college = approvedColleges[index]['college'];
                      final user = approvedColleges[index]['user'];
                      if (user['status'] == 'Approved') {
                        return Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user['name'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text('Incharge: ${college['incharge_name']}',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black54)),
                                Text('Email: ${college['incharge_email']}',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black54)),
                                Text('Phone: ${college['incharge_phone']}',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black54)),
                                Divider(),
                                Text(
                                  'Contact Details',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 8),
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
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: user['status'] == 'Approved'
                                        ? Colors.green
                                        : Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Status: ${user['status']}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CollegeList(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: 'Roboto',
    ),
  ));
}
