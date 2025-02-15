
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
            ListTile(title: Text("Phone"),leading: Icon(Icons.phone,color: Colors.black,),
              onTap: (){

              },
              ),
              

          ],
        ),
      ),
    );
  }
}

