import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_booking_app/services/auth_services.dart';
import 'package:event_booking_app/services/firebase_database.dart';
import 'package:event_booking_app/services/image_storage.dart';
import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final imageStorage = ImageStorage();
  late String uid;

  onTheLoad() async {
    AuthServices user = AuthServices();
    uid = await user.getCurrentUserUid();
    bookingStream = await DatabaseFirestore().getBookedTickets(uid);
    print(bookingStream);
  }

  Stream? bookingStream;

  Widget allBookings() {
    return StreamBuilder(
      stream: bookingStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? SingleChildScrollView(
              child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(20),
                          right: Radius.circular(20),
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on_outlined),
                              SizedBox(width: 5),
                              Text(ds["Location"]),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30, right: 30),
                            child: Divider(color: Colors.grey, thickness: 1),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // FutureBuilder(future: imageStorage.uploadImage(id), builder: (context, imageSnapshot) {
                              //   if(imageSnapshot.hasData){
                              //     Image.asset(
                              //     imageSnapshot.data,
              
                              //     )
                              //   }
              
                              // },)
                              //,
                              SizedBox(
                                width: 130,
                                height: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    "images/concert3.jpg",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
              
                                children: [
                                  Center(
                                    child: Text(
                                      ds["Name"],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_month_rounded,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(width: 7),
                                      Text(
                                        ds["Date"],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.group, color: Colors.blue),
                                      SizedBox(width: 5),
                                      Text(ds["Ticket"]),
                                      SizedBox(width: 20),
                                      Icon(
                                        Icons.monetization_on,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        ds["Price"],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
            )
            : Container(
              child: Center(child: Text("No data here")),
            );
      },
    );
  }

  @override
  void initState() {
    onTheLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                "Bookings",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
              SizedBox(height: 15),
              allBookings(),
            ],
          ),
        ),
      ),
    );
  }
}
