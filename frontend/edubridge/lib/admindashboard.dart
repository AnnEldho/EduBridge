
import 'package:edubridge/college_list.dart';
import 'package:edubridge/ngo-register.dart';
import 'package:edubridge/sponsor_list.dart';
import 'package:flutter/material.dart';
class Admindashboard extends StatefulWidget {
  const Admindashboard({super.key});

  @override
  State<Admindashboard> createState() => _Admindashboard();
}

class _Admindashboard extends State<Admindashboard> {
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("admin"), 
              accountEmail: Text("admin@gmail.com"),
              currentAccountPicture: CircleAvatar(
                child: Text(
                 "A",
                  style: TextStyle(fontSize: 40),
                  ),
                  ),
                ),
            ListTile(title: Text("Home"),leading: Icon(Icons.home,color: Colors.black,),
              onTap: (){

              },),
            ListTile(title: Text("About"),leading: Icon(Icons.help,color: Colors.black,),
              onTap: (){

              },),
            ListTile(title: Text("College"),leading: Icon(Icons.school,color: Colors.black,),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>CollegeList()),
                );
              },
              ),
              ListTile(title: Text("Sponsors"),leading: Icon(Icons.people,color: Colors.black,),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>SponsorList()),
                );
              },
              ),
              ListTile(title: Text("Add NGO"),leading: Icon(Icons.business,color: Colors.black,),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>NGORegistrationForm()),
                );
              },
              ),

          ],
        ),
      ),
    );
  }
}

