import 'package:dio/dio.dart';
class UserService {
  final dio = Dio();
  final String url = "http://192.168.31.211:8000/api/";

  registerUser(String userdata)async{
    final response = await dio.post("${url}register",data: userdata);
    return response;

  }

  loginUser(String userdata)async{
    final response = await dio.post("${url}login",data: userdata);
    return response;

  }
}