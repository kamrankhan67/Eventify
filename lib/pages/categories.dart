import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_booking_app/pages/details.dart';
import 'package:event_booking_app/services/firebase_database.dart';
import 'package:event_booking_app/services/image_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Categories extends StatefulWidget {
  final String eventName;
  const Categories({super.key, required this.eventName});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Stream<QuerySnapshot>? musicEvents;
  Stream<QuerySnapshot>? festivalEvents;
  Stream<QuerySnapshot>? clothingEvents;
  Stream<QuerySnapshot>? allEventStream;
  Stream<QuerySnapshot>? tournamentsStream;
  final imageStorage = ImageStorage();

  onTheLoad() async {
    musicEvents = await DatabaseFirestore().getMusicEvents();
    festivalEvents = await DatabaseFirestore().getFestivalEvents();
    clothingEvents = await DatabaseFirestore().getClothingEvents();
    if (widget.eventName == "Music") {
      setState(() {
        allEventStream = musicEvents;
      });
    } else if (widget.eventName == "Festivals") {
      setState(() {
        allEventStream = festivalEvents;
      });
    } else {
      setState(() {
        allEventStream = clothingEvents;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    onTheLoad();
  }

  Widget allEvents() {
    return StreamBuilder(
      stream: allEventStream,
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
            print(snapshot.data!.docs);

            return hasPassed
                ? Container()
                : GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(ds: ds),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 25.0,
                        top: 10,
                        right: 10,
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
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                print(
                                                  "Image file error: $error",
                                                );
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
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffe3e6ff), Color(0xfff1f3ff), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
            
                children: [
                  SizedBox(width: 10,),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_rounded,size: 32,),
                  ),
                  SizedBox(width: 90,),
                  Text(
                    widget.eventName,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Container(
                width: MediaQuery.of(context).size.width,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),

                child: Column(children: [allEvents()]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
