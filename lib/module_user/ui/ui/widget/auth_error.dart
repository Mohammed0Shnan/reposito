import 'package:flutter/material.dart';
 showErrorDialog(context)async{
  return showDialog(context:context ,builder: (context){
     return AlertDialog(
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(30),
         ),
         content: Container(
           padding: EdgeInsets.all(10),
           alignment: Alignment.center,
           height: 50,
           width: 100,
           child: Text("Error , Try again !!!!!!"),
         )
     );
   });
 }
