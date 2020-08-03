import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ispy/widgets/contained_text.dart';

class HumanSpeakWidget extends StatelessWidget {
  final String text;
  HumanSpeakWidget(this.text);
  @override
  Widget build(BuildContext context) {
    return   Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        ContainedText(text),
        Stack(
          alignment: Alignment.center,
          children: [
            SpinKitDoubleBounce(
                color: Color.fromRGBO(45, 92, 110, 0),
                size: MediaQuery.of(context).size.width
            ),
            Icon(MaterialCommunityIcons.microphone_outline,size:MediaQuery.of(context).size.width/2)
          ],
        ),

      ],
    );
  }
}
