import 'dart:io';
import 'package:event_booking_app/components/myButton.dart';
import 'package:event_booking_app/components/scaffold_message.dart';
import 'package:event_booking_app/components/upload_event_textfield.dart';
import 'package:event_booking_app/services/firebase_database.dart';
import 'package:event_booking_app/services/image_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class UploadEvent extends StatefulWidget {
  const UploadEvent({super.key});

  @override
  State<UploadEvent> createState() => _UploadEventState();
}

class _UploadEventState extends State<UploadEvent> {
  final scaffoldMessenger = ScaffoldMessage();
  final databaseFirestore = DatabaseFirestore();
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController ticketPriceController = TextEditingController();
  final List<String> categories = ["Clothing", "Festivals", "Music"];
  String? selectedCategory;
  File? selectedImage;
  final imageStorage = ImageStorage();
  final TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return DateFormat("hh:mm a").format(dateTime);
  }

  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future getImage() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.arrow_back, size: 25),
                  SizedBox(width: 60),
                  Text(
                    "Upload Event",
                    style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              selectedImage != null
                  ? Center(
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(10),
                        child: Image.file(
                          selectedImage!,
                          width: MediaQuery.of(context).size.height / 4,
                          height: MediaQuery.of(context).size.height / 7,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: Center(
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 4,
                          height: MediaQuery.of(context).size.height / 7,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.camera_alt_outlined),
                        ),
                      ),
                    ),
              SizedBox(height: 15),
              Text(
                "Event Name",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              UploadEventTextfield(
                controller: eventNameController,
                hint: "Event Name",
                height: 40,
              ),
              SizedBox(height: 10),
              Text(
                "Ticket Price",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              UploadEventTextfield(
                controller: ticketPriceController,
                hint: "Ticket Price",
                height: 40,
              ),
              SizedBox(height: 10),
              Text(
                "Location",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              UploadEventTextfield(
                controller: locationController,
                hint: "Enter Location",
                height: 40,
              ),
              SizedBox(height: 10),
              Text(
                "Select Category",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButtonHideUnderline(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xffececf8),
                    border: Border.all(
                      width: 1,
                      color: const Color.fromARGB(255, 20, 20, 20),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    hint: Text(
                      "Select a category",
                      style: TextStyle(color: Colors.grey),
                    ),
                    value: selectedCategory,
                    items: categories.map<DropdownMenuItem<String>>((
                      String value,
                    ) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _pickDate();
                    },
                    child: Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    DateFormat('yyyy-MM-dd').format(selectedDate),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      _pickTime();
                    },
                    child: Icon(Icons.alarm, color: Colors.blue),
                  ),
                  SizedBox(width: 5),
                  Text(
                    formatTimeOfDay(selectedTime),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "Description",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              UploadEventTextfield(
                controller: descriptionController,
                hint: "Tell us about your Event...",
                maxLines: 4,
              ),
              SizedBox(height: 10),
              Mybutton(
                text: "Upload",
                ontap: () async {
                  String id = randomAlphaNumeric(10);
                  if (eventNameController.text.isNotEmpty &&
                      ticketPriceController.text.isNotEmpty &&
                      selectedCategory != null &&
                      descriptionController.text.isNotEmpty) {
                    imageStorage.saveImage(selectedImage!, id);
                    Map<String, dynamic> uploadEvent = {
                      
                      'Name': eventNameController.text,
                      'Price': ticketPriceController.text,
                      'Category': selectedCategory,
                      'Description': descriptionController.text,
                      'Date': DateFormat('yyyy-MM-dd').format(selectedDate),
                      'Time': formatTimeOfDay(selectedTime),
                      'Location': locationController.text,
                    };

                    await databaseFirestore.addEvent(uploadEvent, id).then((
                      value,
                    ) {
                      scaffoldMessenger.message(
                        context,
                        "Upload Successfully!",
                        Colors.green,
                      );
                    });

                    setState(() {
                      eventNameController.text = "";
                      ticketPriceController.text = "";
                      descriptionController.text = "";
                      locationController.text = "";
                      selectedImage = null;
                      selectedDate = DateTime.now();
                      selectedTime = TimeOfDay.now();
                    });
                  } else {
                    await scaffoldMessenger.message(
                      context,
                      "Fill all the Fields!",
                      Colors.red,
                    );
                  }
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
