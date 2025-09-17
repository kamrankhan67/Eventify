import 'package:flutter/material.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.deepPurple,foregroundColor: Colors.white,centerTitle: true,title: Text("Profile",style: TextStyle(fontWeight: FontWeight.bold),),),
      body: Container(
        color: Colors.white,
      ),
    );
  }
}