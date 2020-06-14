import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnackbarWidget extends StatelessWidget {
  final String subject;
  final String body;
  final IconData icon;

  SnackbarWidget({
    @required this.body,
    this.subject='',
    this.icon=Icons.check,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width*0.8;
    return SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            width: width,
            child:
            Text.rich(
                TextSpan(

                  style: TextStyle(fontWeight: FontWeight.bold),
                  text: subject!=''?subject+'\n':subject,
                  children: <TextSpan>[
                    TextSpan(text:body,  style: TextStyle(fontWeight: FontWeight.normal,),)
                  ],
                )),
          )
          ,Icon(icon)],

      ),

    );
  }
}