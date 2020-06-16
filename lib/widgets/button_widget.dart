import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ispy/blocs/search/search_bloc.dart';
import 'package:ispy/blocs/search/search_state.dart';
import 'package:ispy/widgets/spinner_widget.dart';

class ButtonWidget extends StatelessWidget {
  String label;
  var onPressed;
  ButtonWidget(this.label,this.onPressed,{Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return
      Align(
          alignment: Alignment.bottomCenter,
          child:
          Padding(padding: EdgeInsets.only(bottom: 25),child:
      ButtonTheme(
        minWidth: 200.0,
        height: 50.0,
        buttonColor: Color.fromRGBO(67, 132, 165,1),
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(width: 1.00,color: Color.fromRGBO(45, 92, 110,1)))
        ,
        textTheme: ButtonTextTheme.primary,
        child:
        RaisedButton(

            onPressed:   onPressed, child: Text(label))
    )
    ));
}}
