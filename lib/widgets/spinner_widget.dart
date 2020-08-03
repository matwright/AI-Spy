import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SpinnerWidget extends StatelessWidget {

  SpinnerWidget({

    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SpinKitFadingCube(
      color: Color.fromRGBO(45, 92, 110, 1),
      size: MediaQuery.of(context).size.width/2
    );
  }
}
