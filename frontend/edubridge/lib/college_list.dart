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
    print("Getting Approved Colleges");
    try {
      final response = await _userService.getCollegeList();
      print(response.data);
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
        title: Text('College List'),
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
                    child: Text(
                      'Pending Colleges',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
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
                          margin: EdgeInsets.all(10),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'College Name: ${user['name']}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                    'Incharge Name: ${college['incharge_name']}'),
                                Text(
                                    'Incharge Email: ${college['incharge_email']}'),
                                Text(
                                    'Incharge Phone: ${college['incharge_phone']}'),
                                SizedBox(height: 10),
                                Text('User Email: ${user['email']}'),
                                Text('User Phone: ${user['phone_number']}'),
                                Text('Place: ${user['place']}'),
                                Text('Taluk: ${user['taluk']}'),
                                Text('District: ${user['district']}'),
                                Text('State: ${user['state']}'),
                                Text('Pincode: ${user['pincode']}'),
                                Text('Status: ${user['status']}'),
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
  ));
}
