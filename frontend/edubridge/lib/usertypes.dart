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
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CollegeRegistrationForm()),
                  );
                },
                child: const Text(
                  'College',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StudentRegistrationForm()),
                  );
                },
                child: const Text(
                  'Students',
                  style: TextStyle(fontSize: 20),
                ),
              ), 
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SponsorRegistrationForm()),
                  );
                },
                child: const Text(
                  'Sponsors',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
