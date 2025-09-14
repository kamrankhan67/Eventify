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
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .collection("Bookings")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getMusicEvents() async {
    return await FirebaseFirestore.instance
        .collection("Events")
        .where("Category", isEqualTo: "Music")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getFestivalEvents() async {
    return await FirebaseFirestore.instance
        .collection("Events")
        .where("Category", isEqualTo: "Festivals")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getClothingEvents() async {
    return await FirebaseFirestore.instance
        .collection("Events")
        .where("Category", isEqualTo: "Clothing")
        .snapshots();
  }

  Future<DocumentSnapshot> getUserData(String id) async {
    return FirebaseFirestore.instance.collection("Users").doc(id).get();
  }
}
