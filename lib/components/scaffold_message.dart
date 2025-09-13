import 'package:flutter/material.dart';

class ScaffoldMessage {

  Future message(BuildContext context,String text,Color color)async{
    await ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor:color,
                          content: Text(text),
                        ),
                      );
  }
}