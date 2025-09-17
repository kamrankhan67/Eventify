import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_booking_app/services/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class Tickets extends StatefulWidget {
  const Tickets({super.key});

  @override
  State<Tickets> createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  Stream<QuerySnapshot>? allEvents;

  onTheLoad() async {
    allEvents = await DatabaseFirestore().getAdminEvents(uid);
  }

  @override
  void initState() {
    super.initState();
    onTheLoad();
  }

  Widget allAdminEvents() {
    return StreamBuilder(
      stream: allEvents,
      builder: (context, snapshot) {
        return snapshot.data==null?Container(): ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];
            return Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 199, 199, 199),
                  borderRadius: BorderRadius.circular(20)),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //img
                  Container(
                    width: double.infinity,
                    child: Image.asset(
                      'images/concert2.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                  //name
                  Text(
                    ds['Name'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  //date
                  Row(
                    children: [
                      Text(
                        "Date: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.blue,
                        size: 20,
                      ),
                      Text(ds['Date'])
                    ],
                  ),

                  //location
                  Row(children: [
                    Text(
                      "Location: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(ds[Location]),
                  ]),
                  //total tickets
                  Row(children: [
                    Text(
                      "Total Tickets: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(ds['Total_Tickets']),
                  ]),

                  //sold tickets
                  Row(children: [
                    Text(
                      "Sold Tickets: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(ds['Booked_Tickets']),
                  ]),
                  //revenue
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      "Amount Collected: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Total Amount",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("${((double.parse(ds['Booked_Tickets']))*(double.parse(ds["Price"])))} \$"),
                  ]),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Published Events"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children:[allAdminEvents()],
      ),
    );
  }
}
