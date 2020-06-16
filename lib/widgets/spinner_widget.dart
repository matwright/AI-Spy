import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SpinnerWidget extends StatelessWidget {
  final double size;


  SpinnerWidget({
    this.size=600.0,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SpinKitRipple(
      color:Color.fromRGBO(45, 92, 110,1),
      size: size,
    );
  }
}