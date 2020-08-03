import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ispy/blocs/search/search_bloc.dart';
import 'package:ispy/blocs/search/search_state.dart';
import 'package:ispy/widgets/spinner_widget.dart';

class ButtonWidget extends StatelessWidget {
  String label;
  IconData icon=Icons.arrow_forward_ios;
  Color color;
  Color backgroundColor;
  var onPressed;
  ButtonWidget(this.icon,this.label, this.onPressed, {Key key,this.color=Colors.white,this.backgroundColor=Colors.black45}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
            padding: EdgeInsets.only(bottom: 25),
            child: ButtonTheme(
                minWidth: 200.0,
                height: 50.0,

                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                        width: 1.00,
                        color: color)),
                textTheme: ButtonTextTheme.primary,
                child:
                RaisedButton.icon(onPressed: onPressed,elevation: 20,

                    color: backgroundColor,
icon: Icon(icon,size: 30,    color:color ,),
                        label: Text(label,style:
                    TextStyle(
                      color:color ,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Cinzel",),)))));
  }
}
