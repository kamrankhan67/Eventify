import 'package:flutter/material.dart';

class UploadEventTextfield extends StatelessWidget {
  const UploadEventTextfield({
    super.key,
    required this.controller,
    required this.hint,
    this.maxLines,
    this.height
  });
  final TextEditingController controller;
  final String hint;
  final int? maxLines;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.center,
      height: height,

      decoration: BoxDecoration(
        color: Color(0xffececf8),
        border: Border.all(
          width: 1,
          color: const Color.fromARGB(255, 20, 20, 20),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        cursorColor: Colors.black,
        maxLines: maxLines ?? 1,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintStyle: TextStyle(color: Colors.grey),
          hintText: hint,
          fillColor: Colors.white,

          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        ),
      ),
    );
  }
}
