import 'package:edubridge/admindashboard.dart';
import 'package:edubridge/collegedashboard.dart';
import 'package:edubridge/login.dart';
import 'package:edubridge/ngodashboard.dart';
import 'package:edubridge/sponsordashboard.dart';
import 'package:edubridge/studentdashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'EduBridge',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            centerTitle: true,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                textStyle: const TextStyle(fontSize: 20, color: Colors.white),
                foregroundColor: Colors.white),
          ),
        ),
        home: LoginForm(),
        routes: {
          '/admin': (context) => Admindashboard(),
          '/college': (context) => Collegedashboard(),
          '/student': (context) => Studentdashboard(),
          '/ngo': (context) => NGODashboard(),
          '/sponsor': (context) => SponsorDashboard(),
          '/login': (context) => LoginForm(),
        });
  }
}
