import 'package:edubridge/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewSponsorship extends StatefulWidget {
  const ViewSponsorship({super.key});

  @override
  State<ViewSponsorship> createState() => _ViewSponsorshipState();
}

class _ViewSponsorshipState extends State<ViewSponsorship> {
  UserService userService = UserService();
  List<dynamic> sponsorships = [];

  Future<void> getAcceptedSponsorsip() async {
    try {
      final response = await userService.viewAccepedSponsorship();
      print(response.data);
      setState(() {
        sponsorships = response.data;
      });
    } catch (e) {
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
    getAcceptedSponsorsip();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sponsorships"),
      ),
      body: ListView.builder(
        itemCount: sponsorships.length,
        itemBuilder: (context, index) {
          final sponsorship = sponsorships[index];
          final ngo = sponsorship['ngoid'];
          final sponsor = sponsorship['sponsorid'];
          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Description: ${sponsorship['description']}"),
                  Text("Amount: ${sponsorship['amount']}"),
                  SizedBox(height: 10),
                  Text("NGO Details:"),
                  Text("Name: ${ngo['name']}"),
                  Text("Email: ${ngo['email']}"),
                  Text("Phone: ${ngo['phone_number']}"),
                  SizedBox(height: 10),
                  Text("Sponsor Details:"),
                  Text("Name: ${sponsor['name']}"),
                  Text("Email: ${sponsor['email']}"),
                  SizedBox(height: 10),
                  //Text("Status: ${sponsorship['status']}"),
                  Text(
                      "Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(sponsorship['datetime']))}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
