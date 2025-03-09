import 'package:dio/dio.dart';

class UserService {
  final dio = Dio();
  final String url = "http://10.0.2.2:8000/api/";

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

  getCollege() async {
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

  getStudentsByInstitution(String userdata) async {
    final response =
        await dio.post("${url}getstudentsbyinstituition", data: userdata);
    return response;
  }

  approveStudent(String userdata) async {
    final response = await dio.post("${url}approvestudent", data: userdata);
    return response;
  }

  //scholorship
  addScholarship(String scholarshipData) async {
    final response =
        await dio.post("${url}add-scholarship", data: scholarshipData);
    return response;
  }

  viewScholarship(userid) async {
    final response =
        await dio.get("${url}view-scholarship", data: {"userid": userid});
    return response;
  }

  viewAllScholarships() async {
    final response = await dio.get("${url}view-all-scholarships");
    return response;
  }

  joinScholarship(String scholarshipData) async {
    final response =
        await dio.post("${url}join-scholarship", data: scholarshipData);
    return response;
  }

  viewJoinedScholarship(userid) async {
    final response = await dio
        .get("${url}view-joined-scholarship", data: {"userid": userid});
    return response;
  }

  viewJoinedScholarshipByNgo(ngoid) async {
    final response = await dio
        .get("${url}view-joined-scholarship-by-ngo", data: {"ngoid": ngoid});
    return response;
  }

  viewScholarshipById(String scholarshipId) async {
    final response =
        await dio.get("${url}viewScholarshipById", data: {"id": scholarshipId});
    return response;
  }

  viewScholarshipJoinById(String scholarshipId) async {
    final response = await dio.get(
        "${url}view-joined-scholarship-by-sholoarshipid",
        data: {"scholorshipid": scholarshipId});
    return response;
  }
}
