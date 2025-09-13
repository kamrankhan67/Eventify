import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseFirestore {
  Future addEvent(Map<String, dynamic> userInfo, String id) async {
    return await FirebaseFirestore.instance
        .collection("Events")
        .doc(id)
        .set(userInfo);
  }

  Future<Stream<QuerySnapshot>> getEvents() async {
    return await FirebaseFirestore.instance.collection("Events").snapshots();
  }
  
  Future<Stream<QuerySnapshot>> getBookedTickets(String id) async {
    return await FirebaseFirestore.instance.collection("Users").doc(id).collection("Bookings").snapshots();
  }
}
