import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ispy/blocs/challenge/challenge_bloc.dart';

class ChallengeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChallengeBloc, ChallengeState>(

        builder: (context, state) {
          print(state);
          if(state is HumanPromptedState){
            return Text(state.humanClue??'');
          }else if(state is ChallengeStartedState){
            return Text((state.humanClue.substring(state.humanClue.length-1)??''),style: TextStyle(fontSize: 100),);
          }else{
            return Text('challenge');
          }

        }
    );
  }
}