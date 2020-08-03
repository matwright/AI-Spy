import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ispy/blocs/challenge/challenge_bloc.dart';
import 'package:ispy/widgets/clue_widget.dart';
import 'package:ispy/widgets/contained_text.dart';
import 'package:ispy/widgets/countdown_widget.dart';

class HumanClueWidget extends StatelessWidget {

  final String clue;
  _timeOut(context) {
    print('TIMEOUT');
    BlocProvider.of<ChallengeBloc>(context).add(StartChallengeEvent(clue));
  }
  HumanClueWidget(this.clue);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContainedText('Speak!'),
        ContainedText(clue),
        CountdownWidget(5,()=> _timeOut(context))


      ],
    );
  }
}
