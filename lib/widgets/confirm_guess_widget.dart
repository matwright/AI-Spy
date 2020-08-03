import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ispy/blocs/challenge/challenge_bloc.dart';
import 'package:ispy/theme.dart';
import 'package:ispy/widgets/contained_text.dart';
import 'package:ispy/widgets/imagematch_widget.dart';

class ConfirmGuessWidget extends StatelessWidget {
  _startGuessing(context) {
    BlocProvider.of<ChallengeBloc>(context).add(StartGuessingEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChallengeBloc, ChallengeState>(
        listener: (context, state) {
      // do stuff here based on BlocA's state
    }, builder: (context, state) {
      if (state is GuessState) {
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
            ContainedText('Did I guess correctly?'),
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
                  onPressed: () => _startGuessing(context),
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
