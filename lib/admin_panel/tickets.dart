import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_booking_app/services/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    onTheLoad();
  }

  Widget allAdminEvents() {
    return StreamBuilder(
      stream: allEvents,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print("Error in StreamBuilder: ${snapshot.error}");
          return const Center(child: Text("Error loading events"));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No events found"));
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];
            return Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 240, 240, 240),
                  boxShadow: [BoxShadow(offset: Offset(3, 3),blurRadius: 6,spreadRadius: 2,color:Colors.black.withOpacity(0.4), ),],
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
                  Row(
                    children: [
                      Text(
                        "Name: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ds['Name'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  //date
                  Row(
                    children: [
                      Text(
                        "Date: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
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
                    Text(ds["Location"]),
                  ]),
                  //total tickets
                  Row(children: [
                    Text(
                      "Total Tickets: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(ds['Total_Tickets'].toString()),
                  ]),

                  //sold tickets
                  Row(children: [
                    Text(
                      "Sold Tickets: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(ds['Booked_Tickets'].toString()),
                  ]),
                  //revenue
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      "Amount Collected: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${(int.parse(ds['Booked_Tickets'])) * (int.parse(ds['Price']))} \$",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
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
        body: allAdminEvents());
  }
}
