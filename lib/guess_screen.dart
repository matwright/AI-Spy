import 'dart:ui';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ispy/blocs/guess/bloc.dart';
import 'package:ispy/blocs/nav/bloc.dart';
import 'package:ispy/blocs/search/bloc.dart';
import 'package:ispy/widgets/button_widget.dart';
import 'package:ispy/widgets/contained_text.dart';
import 'package:ispy/widgets/game_over_widget.dart';
import 'package:ispy/widgets/guess_widget.dart';
import 'package:ispy/widgets/human_speak_widget.dart';
import 'package:ispy/widgets/spinner_widget.dart';

class GuessScreen extends StatelessWidget {
  _navGuessAgain(context) {
    AssetsAudioPlayer.newPlayer().open(
        Audio("assets/beep.mp3"
            ,metas: Metas(  id:'intro')
        )
    );
    BlocProvider.of<GuessBloc>(context).add(VoiceGuessEvent());
  }

  _navPlayAgain(context) {
    AssetsAudioPlayer.newPlayer().open(
        Audio("assets/beep.mp3"
            ,metas: Metas(  id:'intro')
        )
    );
    BlocProvider.of<NavBloc>(context).add(NavPlayEvent(SearchState.PLAYER_HUMAN));
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GuessBloc, GuessState>(
      builder: (context, state) {
        print(state);
        if (state is StartGuessState) {
          return GuessWidget(label:'Say Answer',onClick:()=>_navGuessAgain(context));
        } else if (state is VoiceProcessedState ) {
          return GuessWidget(label:'Have Another Go',onClick:()=>_navGuessAgain(context));

        } else if (state is GameOverState) {
          return GameOverWidget(state.spiedModel,()=>_navPlayAgain(context),state.success);
        } else  if (state is VoiceGuessState) {
          return
            SizedBox.expand(
          child:HumanSpeakWidget( 'Say your answer')
            );

        } {
          return Container();
        }
      },
    );
  }
}

class TriesWidget extends StatelessWidget {
  final int numTries;
  TriesWidget(this.numTries);
  Widget build(BuildContext build) {
    return

      ContainedText( 'Tries: ' + numTries.toString() + '/5');

  }
}

