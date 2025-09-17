import 'package:event_booking_app/pages/signup_page.dart';
import 'package:event_booking_app/services/auth_services.dart';
import 'package:event_booking_app/services/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  String name = "";
  String email = "";
  getUserData() async {
    final String uid = await AuthServices().getCurrentUserUid();
    final snapshot = await DatabaseFirestore().getUserData(uid);

    if (snapshot.exists) {
      if (!mounted) return;
      setState(() {
        name = snapshot['name'];
        email = snapshot['email'];
      });
    }
  }

  Future<void> _launchGmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'mr.kamrankhan67@gmail.com',
      queryParameters: {
        'subject': 'Support',
        'body': 'Hello, I need help with...',
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch Gmail';
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('images/app_logo_bgremoved.png',width: 130,),
            profileContainerUserfield(
              name,
              "Name",
              Icon(Icons.person, color: Colors.blue),
            ),
            profileContainerUserfield(
              email,
              "Email",
              Icon(Icons.email_outlined, color: Colors.blue),
            ),
            GestureDetector(
              onTap: _launchGmail,
              child: ProfileUserAccountField(
                "Contact Us",
                Icon(Icons.contact_mail_outlined, color: Colors.blue),
              ),
            ),
            GestureDetector(
              onTap: () {
                Future<void> auth = AuthServices().signOut();
                auth;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
              child: ProfileUserAccountField(
                "Log Out",
                Icon(Icons.logout, color: Colors.blue),
              ),
            ),
            GestureDetector(
              onTap: () {
                AuthServices().deleteAccount();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
              child: ProfileUserAccountField(
                "Delete Account",
                Icon(Icons.delete_forever, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileContainerUserfield(String text, String heading, Icon icon) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          icon,
          SizedBox(width: 20),
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(heading, style: TextStyle(color: Colors.grey)),
                Text(
                  text,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget ProfileUserAccountField(String text, Icon icon) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          SizedBox(width: 20),
          Text(
            text,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          Spacer(),
          Icon(Icons.arrow_forward_ios, color: Colors.blue),
        ],
      ),
    );
  }
}
