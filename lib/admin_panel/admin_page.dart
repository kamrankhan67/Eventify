import 'package:event_booking_app/admin_panel/admin_profile.dart';
import 'package:event_booking_app/admin_panel/delete.dart';
import 'package:event_booking_app/admin_panel/tickets.dart';
import 'package:event_booking_app/admin_panel/upload_event.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminProfile(),
                    ));
              },
              child: Icon(
                Icons.person_2_rounded,
                color: Colors.white,
                size: 30,
              )),
          title: Text(
            "Admin Home ",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.deepPurple,
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //upload Events
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadEvent(),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // shadow color
                          spreadRadius: 2, // how much it spreads
                          blurRadius: 6, // how soft it looks
                          offset: Offset(
                              3, 3), // horizontal, vertical shadow position
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload,
                          color: Colors.deepPurple,
                          size: 50,
                        ),
                        Text(
                          "Upload Event",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 51, 51, 51),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Listed Events

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Tickets(),
                        ));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // shadow color
                          spreadRadius: 2, // how much it spreads
                          blurRadius: 6, // how soft it looks
                          offset: Offset(
                              3, 3), // horizontal, vertical shadow position
                        ),
                      ],
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_available_outlined,
                          color: Colors.deepPurple,
                          size: 50,
                        ),
                        Text(
                          "All Events",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 51, 51, 51),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),

                //Total Profits per Event.

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Delete(),
                        ));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 255, 255, 255),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // shadow color
                          spreadRadius: 2, // how much it spreads
                          blurRadius: 6, // how soft it looks
                          offset: Offset(
                              3, 3), // horizontal, vertical shadow position
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                          size: 50,
                        ),
                        Text(
                          "Delete Event",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 51, 51, 51),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
