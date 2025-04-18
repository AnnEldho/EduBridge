import 'package:dio/dio.dart';

class UserService {
  final dio = Dio();
  final String url = "http://192.168.86.181:8000/api/";

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

  changeScholarshipStatus(String scholarshipData) async {
    final response = await dio.post("${url}change-scholarship-status",
        data: scholarshipData);
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

  //sponsorship
  addSponsorRequest(String requestData) async {
    final response = await dio.post("${url}add-request", data: requestData);
    return response;
  }

  viewSponsorRequestBySponsorId(String sponsorId) async {
    final response = await dio
        .get("${url}view-request-by-sponsorid", data: {"sponsorid": sponsorId});
    return response;
  }

  viewSponsorRequestByNgoId(String ngoId) async {
    final response =
        await dio.get("${url}view-request-by-ngoid", data: {"ngoid": ngoId});
    return response;
  }

  updateSponsorRequestStatus(String requestData) async {
    final response =
        await dio.put("${url}update-request-status", data: requestData);
    return response;
  }

  getAllSponsors() async {
    final response = await dio.get("${url}get-all-sponsors");
    return response;
  }

  //sponsorship
  viewAccepedSponsorship() async {
    final response = await dio.get(
      "${url}view-accepted-sponsor-request",
    );
    return response;
  }

  joinSponsorship(String sponsorshipData) async {
    final response =
        await dio.post("${url}join-sponsorship", data: sponsorshipData);
    return response;
  }

  viewJoinedSponsorship(userid) async {
    final response = await dio
        .get("${url}view-joined-sponsorship", data: {"userid": userid});
    return response;
  }

  viewJoinedSponsorshipBySponsorId(String sponsorId) async {
    final response = await dio.get("${url}view-joined-sponsorship-by-sponsorid",
        data: {"sponsorid": sponsorId});
    return response;
  }

  viewJoinedSponsorshipByNgoId(String ngoId) async {
    final response = await dio
        .get("${url}view-joined-sponsorship-by-ngoid", data: {"ngoid": ngoId});
    return response;
  }

  viewJoinedSponsorshipBySponsorshipId(String sponsorshipId) async {
    final response = await dio.get(
        "${url}view-joined-sponsorship-by-sponsorshipid",
        data: {"sponsorshipid": sponsorshipId});
    return response;
  }
  //complaint

  addComplaint(String details) async {
    final response = await dio.post("${url}addComplaint", data: details);
    return response;
  }

  getAllComplaint() async {
    final response = await dio.post("${url}getAllComplaint");
    return response;
  }

  getComplaintByUserid(String userid) async {
    final response =
        await dio.post("${url}getComplaintByUserid", data: {"userid": userid});
    return response;
  }

  getComplaintById(String complaintid) async {
    final response = await dio
        .post("${url}getComplaintById", data: {"complaintid": complaintid});
    return response;
  }

  addReplyToComplaint(String details) async {
    final response = await dio.post("${url}addReplyToComplaint", data: details);
    return response;
  }

  //add notifications

  addNotification(String details) async {
    final response = await dio.post("${url}addNotification", data: details);
    return response;
  }

  getAllNotifications() async {
    final response = await dio.get("${url}getAllNotifications");
    return response;
  }

  getNotificationById(String notificationid) async {
    final response = await dio.get("${url}getNotificationById",
        data: {"notificationid": notificationid});
    return response;
  }

  //password
  forgotPassword(String email) async {
    final response =
        await dio.post("${url}forgotpassword", data: {"email": email});
    return response;
  }

  checkEmail(String email) async {
    final response = await dio.post("${url}checkemail", data: {"email": email});
    return response;
  }

  resetPassword(String email, String newPassword) async {
    final response = await dio.post("${url}resetpassword",
        data: {"email": email, "newPassword": newPassword});
    return response;
  }

  verifyPassword(String password, String confirmPassword) async {
    final response =
        await dio.post("${url}verifypassword", data: {"password": password});
    return response;
  }

  //update
  updateEmail(String email, String userid) async {
    final response = await dio
        .put("${url}updateemail", data: {"email": email, "userid": userid});
    return response;
  }

  updatePhoneNumber(int phone, String userid) async {
    final response = await dio.put("${url}updatephonenumber",
        data: {"phone": phone, "userid": userid});
    return response;
  }

  updatePassword(String password, String userid) async {
    final response = await dio.put("${url}updatepassword",
        data: {"password": password, "userid": userid});
    return response;
  }

  findUser(String email) async {
    final response = await dio.post("${url}finduser", data: {"email": email});
    return response;
  }

  getUser(String userid) async {
    final response = await dio.get("${url}getuser", data: {"userid": userid});
    return response;
  }
}
