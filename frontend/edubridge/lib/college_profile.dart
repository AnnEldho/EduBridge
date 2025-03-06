import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:edubridge/services/user_service.dart';
import 'package:flutter/material.dart';

class CollegeProfile extends StatefulWidget {
  const CollegeProfile({super.key});

  @override
  State<CollegeProfile> createState() => CollegeProfileState();
}

class CollegeProfileState extends State<CollegeProfile> {
  UserService _userService = UserService();
  bool isLoading = true;
  List<dynamic> collegeProfile = [];
  Future<void> getCollegeProfile(String id) async {
      print("Getting College Profile");
      var userdata = jsonEncode({"id": id});
    try {
      final response = await _userService.getCollege();
      print(response.data);
      setState(() {
        collegeProfile = response.data;
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
    getCollegeProfile();
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}