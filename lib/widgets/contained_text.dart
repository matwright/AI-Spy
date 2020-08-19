import 'package:flutter/material.dart';

class ContainedText extends StatelessWidget {
  final String text;
  ContainedText(this.text);
  @override
  Widget build(BuildContext context) {
    return   Container(
      width:  double.infinity,
        padding: EdgeInsets.fromLTRB(0,0,0,10),
        decoration:BoxDecoration(
          color: Colors.black54,

        )
        ,
        child: Text(
         text,
          style: TextStyle(
            height:0.8,
            fontFamily: "Digital",
            fontWeight: FontWeight.bold,

            fontSize: 32,
          ),
          textAlign: TextAlign.center,
        )
    );
  }
}
