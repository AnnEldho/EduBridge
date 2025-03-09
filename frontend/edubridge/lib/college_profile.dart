import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CollegeProfile extends StatefulWidget {
  const CollegeProfile({super.key});

  @override
  State<CollegeProfile> createState() => _CollegeProfileState();
}

class _CollegeProfileState extends State<CollegeProfile> {
	final storage = FlutterSecureStorage();
  String name = "";
  String email = "";
  getUser() async {
    print("Getting User");
    Map<String, String> allValues = await storage.readAll();
    var user = allValues['user'];
    print(user);
    var userMap = jsonDecode(user!);
    print(userMap);
    setState(() {
      name = userMap['name'];
      email = userMap['email'];
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}