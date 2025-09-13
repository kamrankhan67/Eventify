import 'package:flutter/material.dart';

class Mytextfeld extends StatelessWidget {
  const Mytextfeld({
    super.key,
    required this.controller,
    required this.hint,
    required this.obscure,
  });
  final TextEditingController controller;
  final String hint;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: const Color.fromARGB(255, 20, 20, 20),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        obscureText: obscure,
        controller: controller,
        cursorColor: Colors.black,
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
