import 'package:flutter/material.dart';


class ClueWidget extends StatelessWidget {
  final String clue;
  ClueWidget(this.clue);
  Widget build(BuildContext build) {

    return
      Container(

          padding: EdgeInsets.fromLTRB(10,0,10,20),
          decoration:BoxDecoration(
            color: Colors.black54,
            border: Border.all(
              color: Color.fromRGBO(242, 22, 165, 0.5),
              width: 5,
            ),
            borderRadius: BorderRadius.circular(12),
          )
          ,
          child:   Text((clue.length>0?clue.substring(0, 1).toUpperCase():'?'),
              style: TextStyle(
                fontSize: 500,
                fontFamily: "Digital",
                color:Color.fromRGBO(53, 255, 255, 1),
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(5.0, 5.0),
                    blurRadius: 3.0,
                    color:Color.fromRGBO(242, 22, 165, 0.2),
                  ),
                  Shadow(
                    offset: Offset(5.0, 5.0),
                    blurRadius: 18.0,
                    color: Color.fromRGBO(242, 22, 165, 0.5),
                  ),
                ],
              ),
              textAlign: TextAlign.center)
      );

  }
}