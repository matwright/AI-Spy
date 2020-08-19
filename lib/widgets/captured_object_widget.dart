
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:ispy/widgets/button_widget.dart';
import 'package:ispy/widgets/contained_text.dart';


class CapturedObjectWidget extends StatelessWidget {

  Function onClick;
File file;
  CapturedObjectWidget(this.onClick,this.file);
  @override
  Widget build(BuildContext context) {
    return
      Column(
        mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ContainedText( 'Thankyou! Image shared.'),
        Container(
            alignment: Alignment.topCenter,

            child: Image.file(file)),

        ButtonWidget(MaterialCommunityIcons.play_circle_outline,'Start Again',onClick)
      ],
    );
  }
}
