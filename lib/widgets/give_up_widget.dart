import 'package:flutter/material.dart';
import 'package:ispy/widgets/contained_text.dart';
import 'package:ispy/widgets/guess_widget.dart';
import 'package:ispy/widgets/human_clue_widget.dart';

class GiveUpWidget extends StatelessWidget {

@override
Widget build(BuildContext context) {
  return Container(
    child: Column(

      children: [
        ContainedText('I give up, you win!'),

      ],
    ),
  );
}}
