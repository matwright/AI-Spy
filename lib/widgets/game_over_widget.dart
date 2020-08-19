import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ispy/data/spied_model.dart';
import 'package:ispy/widgets/button_widget.dart';
import 'package:ispy/widgets/contained_text.dart';
import 'package:ispy/widgets/imagematch_widget.dart';

class GameOverWidget extends StatelessWidget {
  SpiedModel spiedModel;
  Function onClick;
  bool success;
  GameOverWidget(this.spiedModel,this.onClick,this.success);
  @override
  Widget build(BuildContext context) {
    return
      Column(
        mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ContainedText(  (success==false?'Sorry! \nThe correct answer is:':'Well Done! \n You guessed correctly')),
        ContainedText(   spiedModel.word),
        Container(
            alignment: Alignment.topCenter,

            child: ImageMatchWidget(
              spiedModel: spiedModel,
            )),

        ButtonWidget(MaterialCommunityIcons.eye_check_outline,'Play Your Turn',onClick)
      ],
    );
  }
}
