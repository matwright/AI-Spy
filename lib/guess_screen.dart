import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ispy/blocs/guess/bloc.dart';
import 'package:ispy/widgets/spinner_widget.dart';



class GuessScreen extends StatelessWidget {

  _nav(context)  {
    print('***redirection***');
    BlocProvider.of<GuessBloc>(context).add(VoiceGuessEvent());
  }
  @override
  Widget build(BuildContext context) {


    return BlocBuilder<GuessBloc, GuessState>(

      builder: (context, state) {
        if(state is StartGuessState){
          return Column(
            children: <Widget>[
              Text('Tries: '+state.numTries.toString()),
              Text(state.spiedModel.word.substring(0,1),style: TextStyle(fontSize: 200),),
            FlatButton(onPressed: ()=>_nav(context), child: Text('Guess'))
            ],
          );
        }else if(state is VoiceProcessedState){
          return Column(
            children: <Widget>[
              Text('Tries: '+state.numTries.toString()),
              Text(state.spiedModel.word.substring(0,1),style: TextStyle(fontSize: 200)),
             Text('guess: '+state.guessWord),
              Text(state.guessWord==state.spiedModel.word?'CORRECT!':'WRONG!!'),
              FlatButton(onPressed: ()=>_nav(context), child: Text('Guess'))
            ],
          );
        }

        else{
          return SpinnerWidget();
        }



      },
    );
  }
}