import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class SingleScholarShip extends StatefulWidget {
  const SingleScholarShip({super.key, required this.id});
  final String id;

  @override
  State<SingleScholarShip> createState() => _SingleScholarShipState();
}

class _SingleScholarShipState extends State<SingleScholarShip> {
  final UserService _userService = UserService();
  final FlutterSecureStorage storage = FlutterSecureStorage();
  dynamic data;
  List<dynamic> joinedScholarship = [];
  List<dynamic> filteredUsers = [];
  String filterStatus = "All";
  String sortBy = "Name";

  Future<void> joinScholarship() async {
    Map<String, String> allValues = await storage.readAll();
    var user = allValues['user'];
    var userMap = jsonDecode(user!);
    var jsonData = jsonEncode({
      "scholarshipid": widget.id,
      "userid": userMap["_id"],
      "ngoid": data['userid']
    });

    try {
      await _userService.joinScholarship(jsonData);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Scholarship applied successfully"),
        duration: Duration(milliseconds: 3000),
        backgroundColor: Colors.green,
      ));
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.response?.data["message"] ?? "Error occurred"),
        duration: Duration(milliseconds: 3000),
      ));
    }
  }

  Future<void> changeScholarshipStatus(String id, String status) async {
    var jsonData = jsonEncode({"scholarshipid": id, "status": status});

    try {
      await _userService.changeScholarshipStatus(jsonData);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Status Changed Successfully"),
        duration: Duration(milliseconds: 3000),
        backgroundColor: Colors.green,
      ));
      setState(() {
        data['status'] = status;
      });
    } on DioException {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred, please try again"),
        duration: Duration(milliseconds: 3000),
      ));
    }
  }

  String checkScholarshipStatus(String closingDate) {
    DateTime currentDate = DateTime.now();
    DateTime closingDateTime = DateTime.parse(closingDate);

    return currentDate.isAfter(closingDateTime) ? "Expired" : "Active";
  }

  Future<void> getScholarship() async {
    try {
      final response = await _userService.viewScholarshipById(widget.id);
      setState(() {
        data = response.data;
      });
    } on DioException {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred, please try again"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  Future<void> getJoinedScholarship() async {
    try {
      final response = await _userService.viewScholarshipJoinById(widget.id);
      setState(() {
        joinedScholarship = response.data;
        filteredUsers = List.from(joinedScholarship);
      });
    } on DioException {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred, please try again"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  void sortUsers() {
    setState(() {
      if (sortBy == "Name") {
        filteredUsers.sort((a, b) => a['userid']['name']
            .toString()
            .compareTo(b['userid']['name'].toString()));
      } else if (sortBy == "Status") {
        filteredUsers.sort(
            (a, b) => a['status'].toString().compareTo(b['status'].toString()));
      }
    });
  }

  void filterUsers() {
    setState(() {
      if (filterStatus == "All") {
        filteredUsers = List.from(joinedScholarship);
      } else {
        filteredUsers = joinedScholarship
            .where((user) => user['status'] == filterStatus)
            .toList();
      }
      sortUsers();
    });
  }

  @override
  void initState() {
    super.initState();
    getScholarship();
    getJoinedScholarship();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scholarship Details")),
      body: data == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildScholarshipCard(),
                  const SizedBox(height: 20),
                  buildSortingAndFilteringControls(),
                  const SizedBox(height: 15),
                  Text(
                    "Total Users: ${filteredUsers.length}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  buildJoinedUsersList(),
                ],
              ),
            ),
    );
  }

  Widget buildScholarshipCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: const Color.fromARGB(255, 255, 180, 68),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🎓 ${data['title']}",
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              "📜 Description: ${data['description']}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "💰 Amount: ₹${data['amount']}",
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 8),
            Text(
              "📅 Opening Date: ${DateFormat.yMd().format(DateTime.parse(data['opening_date']))}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "⏳ Closing Date: ${DateFormat.yMd().format(DateTime.parse(data['closing_date']))}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text("📌 Status: ", style: TextStyle(fontSize: 18)),
                Chip(
                  label: Text(
                    checkScholarshipStatus(data['closing_date']),
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: checkScholarshipStatus(data['closing_date']) ==
                          "Expired"
                      ? Colors.red
                      : Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget buildSortingAndFilteringControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButton<String>(
          value: sortBy,
          items: const [
            DropdownMenuItem(value: "Name", child: Text("Sort by Name")),
            DropdownMenuItem(value: "Status", child: Text("Sort by Status")),
          ],
          onChanged: (value) {
            setState(() {
              sortBy = value!;
            });
            sortUsers();
          },
        ),
        DropdownButton<String>(
          value: filterStatus,
          items: const [
            DropdownMenuItem(value: "All", child: Text("All Statuses")),
            DropdownMenuItem(value: "Approved", child: Text("Approved")),
            DropdownMenuItem(value: "Rejected", child: Text("Rejected")),
            DropdownMenuItem(value: "Applied", child: Text("Applied")),
          ],
          onChanged: (value) {
            setState(() {
              filterStatus = value!;
            });
            filterUsers();
          },
        ),
      ],
    );
  }

  Widget buildJoinedUsersList() {
    return ExpansionTile(
      title: const Text(
        "👥 Joined Users",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      children: filteredUsers.map((scholarship) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: ListTile(
            title: Text("User: ${scholarship['userid']['name']}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("📧 Email: ${scholarship['userid']['email']}"),
                Text("📞 Phone: ${scholarship['userid']['phone_number']}"),
                Text("🏠 District: ${scholarship['userid']['district']}"),
                Text("🌍 Taluk: ${scholarship['userid']['taluk']}"),
                Row(
                  children: [
                    Chip(
                      label: Text(scholarship['status']),
                      backgroundColor: scholarship['status'] == "Approved"
                          ? Colors.green
                          : scholarship['status'] == "Rejected"
                              ? Colors.red
                              : Colors.blue,
                    ),
                  ],
                ),
                if (scholarship['status'] == 'Applied')
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            changeScholarshipStatus(widget.id, "Approved"),
                        child: const Text("Approve"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () =>
                            changeScholarshipStatus(widget.id, "Rejected"),
                        child: const Text("Reject"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
