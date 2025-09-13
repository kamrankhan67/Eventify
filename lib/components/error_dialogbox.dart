import 'package:flutter/material.dart';

void showErrorDialogBox(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        icon: Icon(Icons.error),
        
        title: Text("Error",style: TextStyle(color:Colors.red),),
        content: Text(message),
        actions: <Widget>[
          
          TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Ok"))
        ],

      );
    },
  );
}
