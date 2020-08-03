import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ispy/data/spied_model.dart';
import 'package:ispy/widgets/button_widget.dart';
import 'package:ispy/widgets/contained_text.dart';
import 'package:ispy/widgets/imagematch_widget.dart';

class GameOverWidget extends StatelessWidget {
  SpiedModel spiedModel;
  Function onClick;
  GameOverWidget(this.spiedModel,this.onClick);
  @override
  Widget build(BuildContext context) {
    return
      Column(
        mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ContainedText(  'Well Done!'),
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
