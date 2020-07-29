import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ispy/blocs/guess/bloc.dart';
import 'package:ispy/blocs/nav/bloc.dart';
import 'package:ispy/blocs/search/bloc.dart';
import 'package:ispy/widgets/button_widget.dart';
import 'package:ispy/widgets/imagematch_widget.dart';
import 'package:ispy/widgets/spinner_widget.dart';



class GuessScreen extends StatelessWidget {


  _navGuessAgain(context)  {
    BlocProvider.of<GuessBloc>(context).add(VoiceGuessEvent());
  }

  _navPlayAgain(context)  {
    BlocProvider.of<NavBloc>(context).add(NavPlayEvent(SearchState.PLAYER_HUMAN));
  }
  @override
  Widget build(BuildContext context) {


    return BlocBuilder<GuessBloc, GuessState>(

      builder: (context, state) {
        if(state is StartGuessState){
          return Column(
            children: <Widget>[
              Center(child: TriesWidget(state.numTries)),
              ClueWidget(state.spiedModel.word),
              ButtonWidget('Guess', ()=>_navGuessAgain(context))

            ],
          );
        }else
        if( state is VoiceProcessedState && state.guessWord!=null){
          return Column(
            children: <Widget>[
              Center(child: TriesWidget(state.numTries)),
              ClueWidget(state.spiedModel.word),

              ButtonWidget('Have Another Go!', ()=>_navGuessAgain(context)),
              RichText(
                text: TextSpan(
                  text: 'You answered : ',
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(text: state.guessWord, style: TextStyle(fontWeight: FontWeight.bold)),

                  ],
                ),
              )

            ],
          );
        }else if(state is VoiceProcessedState){
          return Column(
            children: <Widget>[
              Center(child: TriesWidget(state.numTries)),
              ClueWidget(state.spiedModel.word),

              ButtonWidget('Have Another Go!', ()=>_navGuessAgain(context)),
            ],
          );
        }else if (state is GameOverState){

          return

        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            state.spiedModel.word,
            style    : new TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 40),
          ),

          Container
            (alignment: Alignment.topCenter,
              color: Colors.white,
            child:ImageMatchWidget(spiedModel: state.spiedModel,)),
          Text(
            'Well Done!',
            style    : new TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 40),
          ),

         ButtonWidget('Play Your Turn', ()=>_navPlayAgain(context))

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

class TriesWidget extends StatelessWidget{
int numTries;
  TriesWidget(this.numTries);
  Widget build(BuildContext build){
    return Padding(
      padding: EdgeInsets.only(top:20),
      child: Text('Tries: '+numTries.toString()+'/5',style: TextStyle(
        fontSize: 32,

      ),textAlign: TextAlign.center,)
    );
  }
}

class ClueWidget extends StatelessWidget{
  String clue;
  ClueWidget(this.clue);
  Widget build(BuildContext build){
    return Text(clue.substring(0,1),style: TextStyle(
      fontSize: 300,

    ),textAlign: TextAlign.center);
  }
}

