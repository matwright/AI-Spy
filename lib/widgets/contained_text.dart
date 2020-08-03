import 'package:flutter/material.dart';

class ContainedText extends StatelessWidget {
  final String text;
  ContainedText(this.text);
  @override
  Widget build(BuildContext context) {
    return   Container(
        padding: EdgeInsets.all(10),
        decoration:BoxDecoration(
          color: Colors.black54,

        )
        ,
        child: Text(
         text,
          style: TextStyle(
            fontFamily: "Cinzel",
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
          textAlign: TextAlign.center,
        )
    );
  }
}
