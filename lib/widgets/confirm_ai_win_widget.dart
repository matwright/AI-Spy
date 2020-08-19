import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ispy/blocs/challenge/challenge_bloc.dart';
import 'package:ispy/blocs/nav/bloc.dart';
import 'package:ispy/blocs/search/bloc.dart';
import 'package:ispy/theme.dart';
import 'package:ispy/widgets/button_widget.dart';
import 'package:ispy/widgets/contained_text.dart';
import 'package:ispy/widgets/imagematch_widget.dart';

class ConfirmAIWinWidget extends StatelessWidget {


  _playAI(context){
    BlocProvider.of<NavBloc>(context)
        .add(NavHomeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChallengeBloc, ChallengeState>(
        listener: (context, state) {
      // do stuff here based on BlocA's state
    }, builder: (context, state) {
      if (state is AIWinsState) {
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ContainedText(state.spiedModel.word),
            Container(
              height: MediaQuery.of(context).size.height/2,
              child:    ImageMatchWidget(spiedModel: state.spiedModel),
            )
         ,
            ContainedText('A.I. Wins'),
            ButtonWidget(MaterialCommunityIcons.eye_circle_outline, 'OK', ()=>_playAI(context)),
          ],
        ));
      } else {
        return Text('Invalid State');
      }
    });
  }
}
