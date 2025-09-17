import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_booking_app/admin_panel/admin_page.dart';
import 'package:event_booking_app/components/error_dialogbox.dart';
import 'package:event_booking_app/components/myButton.dart';
import 'package:event_booking_app/components/mytextfeld.dart';
import 'package:event_booking_app/pages/bottom_navbar.dart';
import 'package:event_booking_app/pages/signup_page.dart';
import 'package:event_booking_app/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isChecked = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final _authServices = AuthServices();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(
          children: [
            Opacity(
              opacity: 0.1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.asset("images/signup_wallpaper2.png"),
              ),
            ),
            Column(
              children: [
                Image.asset(
                  "images/app_logo_bgremoved.png",
                  width: 200,
                ),
                Text(
                  "Unlock the future of",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Event Booking App",
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Discover, Book and experience unforgettable moments effortlessly!",
                    style: TextStyle(
                      color: const Color.fromARGB(95, 14, 14, 14),
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Mytextfeld(
                  controller: emailController,
                  hint: "Enter your Email",
                  obscure: false,
                ),
                SizedBox(height: 20),
                Mytextfeld(
                  controller: passController,
                  hint: "Enter your Password",
                  obscure: true,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Continue an Admin",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold),
                    ),
                    Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            if (!isChecked) {
                              isChecked = true;
                            } else {
                              isChecked = false;
                            }
                          });
                        }),
                  ],
                ),
                Mybutton(
                  text: "Log In",
                  ontap: () async {
                    try {
                      UserCredential user =
                          await _authServices.signInWithEmailAndPassword(
                              emailController.text,
                              passController.text,
                              isChecked);
                      String uid = user.user!.uid;
                      if (!isChecked) {
                        DocumentSnapshot userDoc = await _firebaseFirestore
                            .collection("Users")
                            .doc(uid)
                            .get();
                        if (userDoc.exists) {
                          await Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomNavbar()),
                          );
                        } else {
                          showErrorDialogBox(context, "You dont have an account, Please Sign Up first");
                        }
                      } else {
                        DocumentSnapshot userDoc = await _firebaseFirestore
                            .collection("Admin")
                            .doc(uid)
                            .get();
                        if (userDoc.exists) {
                          await Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminHomePage()),
                          );
                        }
                      }
                    } on Exception catch (e) {
                      showErrorDialogBox(context, e.toString());
                    }
                  },
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an Account? ",
                      style: TextStyle(color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPage()),
                        );
                      },
                      child: Text(
                        "Sign Up ",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 48, 92, 236),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
