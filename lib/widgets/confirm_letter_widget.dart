import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ispy/blocs/challenge/challenge_bloc.dart';
import 'package:ispy/theme.dart';
import 'package:ispy/widgets/clue_widget.dart';
import 'package:ispy/widgets/contained_text.dart';

class ConfirmLetterWidget extends StatelessWidget {
  _startGuessing(context) {
    BlocProvider.of<ChallengeBloc>(context).add(StartGuessingEvent());
  }

  _startAgain(context) {
    BlocProvider.of<ChallengeBloc>(context).add(PromptHumanEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChallengeBloc, ChallengeState>(
        listener: (context, state) {
      // do stuff here based on BlocA's state
    }, builder: (context, state) {
      if (state is ChallengeStartedState) {

        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ClueWidget(state.humanClue.length>1 ?state.humanClue.substring(state.humanClue.length - 1): ''),
      ContainedText( 'Did I hear you correctly?')
           ,
            Wrap(
              spacing: 50,
              children: [
                IconButton(
                  onPressed: () => _startGuessing(context),
                  iconSize: 100,
                  icon: Icon(MaterialCommunityIcons.thumb_up_outline),
                  color: theme.colorScheme.primaryVariant,
                ),
                IconButton(
                  onPressed: () =>_startAgain(context),
                  iconSize: 100,
                  icon: Icon(MaterialCommunityIcons.thumb_down_outline),
                  color: theme.colorScheme.error,
                ),
              ],
            )
          ],
        ));
      } else {
        return Text('Invalid State');
      }
    });
  }
}
