import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ispy/blocs/challenge/challenge_bloc.dart';
import 'package:ispy/widgets/capture_object_widget.dart';
import 'package:ispy/widgets/confirm_guess_widget.dart';
import 'package:ispy/widgets/confirm_letter_widget.dart';
import 'package:ispy/widgets/countdown_widget.dart';
import 'package:ispy/widgets/human_clue_widget.dart';
import 'package:ispy/widgets/human_speak_widget.dart';
import 'package:ispy/widgets/spinner_widget.dart';

class ChallengeScreen extends StatelessWidget {

  _timeOut(context) {
    print('TIMEOUT');
    BlocProvider.of<ChallengeBloc>(context).timedout=true;
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengeBloc, ChallengeState>(
        builder: (context, state) {
      if (state is HumanPromptedState) {
        return
          HumanClueWidget((state.humanClue!=null ?state.humanClue+'...': ''));
      } else if (state is ChallengeStartedState) {
        return ConfirmLetterWidget();
      } else if (state is GuessState) {
        return ConfirmGuessWidget();
      } else if (state is GuessingState) {
        return CountdownWidget(15,_timeOut);
      }  else if (state is GiveUpState) {
        return       SizedBox.expand(
            child:HumanSpeakWidget( 'Human wins\n\nTell me what you spied, please.')
        );
      } else if (state is ObjectCaptureState) {
        return CaptureObjectWidget(state.controller);
      }   else {
        return SpinnerWidget();
      }
    });
  }
}
