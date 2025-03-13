import 'package:edubridge/college-register.dart';
import 'package:edubridge/sponsor-register.dart';
import 'package:edubridge/student-register.dart';
import 'package:flutter/material.dart';

class UserTypeSelection extends StatelessWidget {
  const UserTypeSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select User Type'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUserTypeCard(
                context,
                'College',
                Icons.school,
                const CollegeRegistrationForm(),
              ),
              const SizedBox(height: 20),
              _buildUserTypeCard(
                context,
                'Students',
                Icons.person,
                const StudentRegistrationForm(),
              ),
              const SizedBox(height: 20),
              _buildUserTypeCard(
                context,
                'Sponsors',
                Icons.business,
                const SponsorRegistrationForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeCard(BuildContext context, String title, IconData icon, Widget destination) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: Colors.black,
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}