import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SpinnerWidget extends StatelessWidget {
  final double size;


  SpinnerWidget({
    this.size=200.0,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SpinKitFadingFour(
      color:Theme.of(context).primaryColor,
      size: size,
    );
  }
}