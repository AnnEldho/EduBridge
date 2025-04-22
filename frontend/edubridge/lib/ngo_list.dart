import 'package:edubridge/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class NGOList extends StatefulWidget {
  @override
  _NGOListState createState() => _NGOListState();
}

class _NGOListState extends State<NGOList> {
  final UserService _userService = UserService();
  List<dynamic> ngoList = []; // List to store fetched NGO data
  bool isLoading = true; // To track the loading state

  @override
  void initState() {
    super.initState();
    fetchNgoList(); // Fetch data when the widget is initialized
  }

  // Function to fetch NGO list from the server
  Future<void> fetchNgoList() async {
    setState(() {
      isLoading = true; // Set loading state to true
    });
    try {
      final response = await _userService.getNgoList();
      setState(() {
        ngoList = response.data; // Store the fetched data in ngoList
        isLoading = false; // Set loading state to false
      }); // Call the service to get NGO list
    } on DioException catch (e) {
      setState(() {
        isLoading = false; // Set loading state to false in case of error
      });
      print(e.error); // Print the error for debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NGO List"),
      ),
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while fetching data
          : ngoList.isEmpty
              ? Center(
                  child: Text(
                      "No NGOs found")) // Show this message if no data found
              : ListView.builder(
                  itemCount:
                      ngoList.length, // Set the number of items in the list
                  itemBuilder: (context, index) {
                    // Safely extract ngo and user data
                    final ngo = ngoList[index]['ngo'] ?? {};
                    final user = ngoList[index]['user'] ?? {};

                    return Card(
                      margin: EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            16), // Rounded corners for the card
                      ),
                      elevation: 5, // Elevated effect for the card
                      // Card background color
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
                            Text('Incharge: ${ngo['incharge_name']}',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black87)),
                            Text('Email: ${ngo['incharge_email']}',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black87)),
                            Text('Phone: ${ngo['incharge_phone']}',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black87)),
                            Divider(),
                            Text(
                              'Contact Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
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
                            Text('State: ${user['state']} - ${user['pincode']}',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black87)),
                            SizedBox(height: 10),
                            Divider(),
                            Text(
                              'Bank Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text('Account Number: ${ngo['account_number']}',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black87)),
                            Text('IFSC Code: ${ngo['ifsc_code']}',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black87)),
                            Text('Bank Name: ${ngo['bank_name']}',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black87)),
                            Text('Branch: ${ngo['branch_name']}',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black87)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
