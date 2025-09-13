import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_booking_app/admin_panel/upload_event.dart';
import 'package:event_booking_app/pages/details.dart';
import 'package:event_booking_app/services/auth_services.dart';
import 'package:event_booking_app/services/firebase_database.dart';
import 'package:event_booking_app/services/image_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final imageStorage = ImageStorage();
  Stream<QuerySnapshot>? eventStream;
  late String uid;

  @override
  void initState() {
    super.initState();
    onLoading();
  }

  Future<void> onLoading() async {
    try {
      eventStream = await DatabaseFirestore().getEvents();
      //userName = (await AuthServices().getCurrentUserName())!;
      setState(() {});
    } catch (e) {
      print("Error loading events: $e");
    }
  }

  Widget allEvents() {
    return StreamBuilder(
      stream: eventStream,
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
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];
            final String inputDate = ds["Date"];
            DateTime parsedDate = DateTime.parse(inputDate);
            String formatedDate = DateFormat('MMM,dd').format(parsedDate);
            DateTime currentDate = DateTime.now();
            bool hasPassed = currentDate.isAfter(parsedDate);

            return hasPassed?Container(): GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailsPage(ds: ds)),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(right: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: FutureBuilder<File?>(
                            future: imageStorage.uploadImage(ds.id),
                            builder: (context, imageSnapshot) {
                              if (imageSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox(
                                  height: 200,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              } else if (imageSnapshot.hasError ||
                                  !imageSnapshot.hasData ||
                                  imageSnapshot.data == null) {
                                print(
                                  "Error loading image for ID ${ds.id}: ${imageSnapshot.error}",
                                );
                                return const Icon(
                                  Icons.broken_image,
                                  size: 100,
                                );
                              } else {
                                return Image.file(
                                  imageSnapshot.data!,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print("Image file error: $error");
                                    return const Icon(
                                      Icons.broken_image,
                                      size: 100,
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        margin: const EdgeInsets.only(left: 10, top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          formatedDate,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ds["Name"] ?? "Unnamed Event",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Text(
                          "\$${ds["Price"] ?? '0'}",
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16),
                      Text(ds["Location"] ?? "Unknown Location"),
                    ],
                  ),
                  const SizedBox(height: 20),
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on_outlined),
                    const SizedBox(width: 2),
                    const Text(
                      "Lahore, Pakistan",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        final auth = AuthServices();
                        auth.signOut();
                      },
                      child: const Icon(Icons.logout),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  "Hello , Kamran",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  "There are 20 events \naround your location",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple[500],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.only(left: 15),
                  child: const TextField(
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      hintText: "Search a Location",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 90,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategory(
                        context,
                        "images/microphone.png",
                        "Music",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UploadEvent(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      _buildCategory(context, "images/clothes.png", "Clothing"),
                      const SizedBox(width: 30),
                      _buildCategory(
                        context,
                        "images/confetti.png",
                        "Festivals",
                        onTap: () {},
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "UpComing Events",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        "See More",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                allEvents(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategory(
    BuildContext context,
    String imagePath,
    String label, {
    VoidCallback? onTap,
  }) {
    return Material(
      elevation: 10,
      color: Colors.grey,
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage(imagePath), width: 30),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
