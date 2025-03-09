import 'package:dio/dio.dart';



class UserService {
  final dio = Dio();
  final String url = "http://192.168.1.103:8000/api/";

  registerUser(String userdata) async {
    final response = await dio.post("${url}register", data: userdata);
    return response;
  }

  loginUser(String userdata) async {
    final response = await dio.post("${url}login", data: userdata);
    return response;
  }

  getPendingCollege() async {
    final response = await dio.get("${url}getpendingcollege");
    return response;
  }

  getPendingSponsor() async {
    final response = await dio.get("${url}getpendingsponsor");
    return response;
  }

  getCollegeList() async {
    final response = await dio.get("${url}getcollegelist");
    return response;
  }
   getSponsorList() async {
    final response = await dio.get("${url}getsponsorlist");
    return response;  
  }

  getCollege() async{
    final response = await dio.get("${url}getcollege");
    return response;
  }

  changeStatus(String userdata) async {
    final response = await dio.post("${url}updatestatus", data: userdata);
    return response;
  }

  getUserData() async {
    final response = await dio.get("${url}getuserdata");
    return response;
  }
}
