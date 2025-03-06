import 'package:dio/dio.dart';
import 'package:edubridge/getpendingsponsor.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:flutter/material.dart';

class SponsorList extends StatefulWidget {
  const SponsorList({super.key});

  @override
  State<SponsorList> createState() => _SponsorListState();
}

class _SponsorListState extends State<SponsorList> {
  UserService _userService = UserService();
  bool isLoading = true;
  List<dynamic> approvedSponsors = [];

  Future<void> getApprovedSponsors() async {
    setState(() {
      isLoading = true;
    });
    print("Getting Approved Sponsors");
    try {
      final response = await _userService.getSponsorList();
      print(response.data);
      setState(() {
        approvedSponsors = response.data;
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
    getApprovedSponsors();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sponsor List'),
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
                     builder: (context) =>GetPendingSponsor(),
                   ),
                 );
               },
               child: Text(
                 'Pending Sponsors',
                 style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                        decoration: TextDecoration.underline,
                  ),
               ),
             ),
           ),
           Expanded(
            child: ListView.builder(
              itemCount: approvedSponsors.length ,
              itemBuilder:(context, index) {
                final user =approvedSponsors[index]['user'];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sponsor Name: ${user['name']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
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
    home: SponsorList(),
  ));
}