import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_booking_app/components/scaffold_message.dart';
import 'package:event_booking_app/services/auth_services.dart';
import 'package:event_booking_app/services/image_storage.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.ds});
  final DocumentSnapshot ds;
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late String id;
  late File image;
  final imageStorage = ImageStorage();
  int count = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Stack(
                children: [
                  FutureBuilder(
                    future: imageStorage.uploadImage(widget.ds.id),
                    builder: (context, imageSnapshot) {
                      if (imageSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (imageSnapshot.hasError ||
                          !imageSnapshot.hasData ||
                          imageSnapshot.data == null) {
                        print(
                          "Error loading image for ID ${widget.ds.id}: ${imageSnapshot.error}",
                        );
                        return const Icon(Icons.broken_image, size: 100);
                      } else {
                        image = imageSnapshot.data!;
                        return Image.file(
                          imageSnapshot.data!,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 2,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print("Image file error: $error");
                            return const Icon(Icons.broken_image, size: 100);
                          },
                        );
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            margin: EdgeInsets.only(top: 30),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.ds["Name"],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  widget.ds["Date"],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(width: 25),
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  widget.ds["Location"],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(widget.ds["Description"]),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Number of Tickets",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 50),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          border: BoxBorder.all(width: 1),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        height: 100,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  ++count;
                                });
                              },
                              child: Text(
                                "+",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Text(
                              count.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (count > 1) {
                                    --count;
                                  }
                                });
                              },
                              child: Text(
                                "-",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Amount : \$ ${int.parse(widget.ds["Price"]) * count}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 153, 61, 199),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          id = randomAlphaNumeric(9);
                          final authSrevices = AuthServices();
                          final firestore = FirebaseFirestore.instance;
                          final user = await authSrevices.getCurrentUser();
                          final uid = await user.uid;
                          firestore
                              .collection("Users")
                              .doc(uid)
                              .collection("Bookings")
                              .doc(id)
                              .set({
                            "Name": widget.ds["Name"],
                            "Price": widget.ds["Price"],
                            "Tickets": (count.toString()),
                            "Location": widget.ds["Location"],
                            "Date": widget.ds["Date"],
                            "Id": id,
                          }).then((value) {
                            final scfMdg = ScaffoldMessage();
                            scfMdg.message(
                              context,
                              "Booked Successfully",
                              Colors.green,
                            );
                          });

                         await  firestore.collection("Events").doc(widget.ds['uid']).update({
                            'Booked_Tickets':(count).toString()
                          });

                          //for image Storage

                          imageStorage.saveImage(image, id);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Book Now",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
