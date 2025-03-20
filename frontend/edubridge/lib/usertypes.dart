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
        backgroundColor:
            const Color.fromARGB(255, 101, 121, 220), // Match theme
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
                Icons.school, // College Icon
                const CollegeRegistrationForm(),
              ),
              const SizedBox(height: 10),
              _buildUserTypeCard(
                context,
                'Students',
                Icons.person, // Student Icon
                const StudentRegistrationForm(),
              ),
              const SizedBox(height: 10),
              _buildUserTypeCard(
                context,
                'Sponsors',
                Icons.business, // Sponsor Icon
                const SponsorRegistrationForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeCard(
      BuildContext context, String title, IconData icon, Widget destination) {
    return Card(
      elevation: 3,
      color: const Color.fromARGB(255, 255, 180, 68),
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
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            children: [
              // Icon
              Icon(
                icon,
                size: 30, // Reduced icon size
                color: const Color.fromARGB(255, 101, 121, 220),
              ),
              const SizedBox(width: 12),

              // Title Text
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16, // Reduced font size
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),

              // Arrow Icon
              const Icon(
                Icons.arrow_forward_ios,
                color: Color.fromARGB(255, 101, 121, 220),
                size: 18, // Smaller arrow
              ),
            ],
          ),
        ),
      ),
    );
  }
}
