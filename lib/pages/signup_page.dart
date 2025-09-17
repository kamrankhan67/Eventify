import 'package:event_booking_app/components/error_dialogbox.dart';
import 'package:event_booking_app/components/mybutton.dart';
import 'package:event_booking_app/components/mytextfeld.dart';
import 'package:event_booking_app/components/scaffold_message.dart';
import 'package:event_booking_app/pages/bottom_navbar.dart';
import 'package:event_booking_app/pages/login_page.dart';
import 'package:event_booking_app/services/auth_services.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool isChecked = false;
  bool isVerified = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final _authServices = AuthServices();
  final scaffoldMessage = ScaffoldMessage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.1,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset("images/signup_wallpaper2.png"),
            ),
          ),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Image.asset(
                  "images/app_logo_bgremoved.png",
                  width: 150,
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
                    "Discover,Book and experience unforgetable moments effortlessly!",
                    style: TextStyle(
                      color: const Color.fromARGB(95, 14, 14, 14),
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Mytextfeld(
                  controller: nameController,
                  hint: "Enter your Name",
                  obscure: false,
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
                    text: "Sign Up",
                    ontap: () async {
                      try {
                        if (!isChecked) {
                          await _authServices.signUpWithEmailAndPassword(
                              emailController.text,
                              passController.text,
                              nameController.text,
                              isChecked,
                              isVerified,);
                          scaffoldMessage.message(
                            context,
                            "Registered Successfully!!!",
                            Colors.green,
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomNavbar()),
                          );
                        } else {
                          await _authServices.signUpWithEmailAndPassword(
                              emailController.text,
                              passController.text,
                              nameController.text,
                              isChecked,
                              isVerified);
                          scaffoldMessage.message(
                            context,
                            "Registered Successfully!!!",
                            Colors.green,
                          );
                        }
                      } on Exception catch (e) {
                        showErrorDialogBox(context, e.toString());
                      }
                    }),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an Account? ",
                      style: TextStyle(color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        "Login ",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 48, 92, 236),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
