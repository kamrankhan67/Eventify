import 'package:event_booking_app/components/error_dialogbox.dart';
import 'package:event_booking_app/components/myButton.dart';
import 'package:event_booking_app/components/mytextfeld.dart';
import 'package:event_booking_app/pages/bottom_navbar.dart';
import 'package:event_booking_app/pages/signup_page.dart';
import 'package:event_booking_app/services/auth_services.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final _authServices = AuthServices();

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
                SizedBox(height: 40),
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
                SizedBox(height: 20),
                Mybutton(
                  text: "Log In",
                  ontap: () async{
                    
                    try {
                      await _authServices.signInWithEmailAndPassword(
                        emailController.text,
                        passController.text,
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => BottomNavbar()),
                      );
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
