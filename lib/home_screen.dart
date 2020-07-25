import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ispy/blocs/camera/bloc.dart';
import 'package:ispy/blocs/challenge/challenge_bloc.dart';
import 'package:ispy/blocs/guess/bloc.dart';
import 'package:ispy/blocs/search/bloc.dart';
import 'package:ispy/blocs/search/search_bloc.dart';
import 'package:ispy/blocs/nav/bloc.dart';
import 'package:ispy/challenge_screen.dart';
import 'package:ispy/guess_screen.dart';
import 'package:ispy/search_screen.dart';

class HomeScreen extends StatelessWidget {
  final String name;
  int navIndex=0;
  HomeScreen({Key key, @required this.name}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    return
      BlocBuilder<NavBloc, NavState>(
          builder: (_,state){
            return Scaffold(
              appBar: AppBar(title: Text('iSPY v.1.0.beta'),backgroundColor: Color.fromRGBO(45, 92, 110,1),),
extendBodyBehindAppBar: false,
                body:

                _body(state,context)
            );
          }
      );

  }
}

_body(NavState state,BuildContext context){
  if(state is InitialNavState || state is HomeNavState){

    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.all(20)),
        Image(image:AssetImage('assets/logo.png') ),
        Padding(padding: EdgeInsets.all(20)),
  ButtonTheme(
  minWidth: 200.0,
  height: 50.0,
      buttonColor: Color.fromRGBO(67, 132, 165,1),
  shape:  RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10.0),
  side: BorderSide(width: 1.00,color: Color.fromRGBO(45, 92, 110,1)))
  ,
textTheme: ButtonTextTheme.primary,
      child:
        RaisedButton(
            onPressed:   ()=>BlocProvider.of<NavBloc>(context).add(NavPlayEvent(SearchState.PLAYER_AI)), child: Text('Play'))
  )

  ],
    );



  }else if(state is PlayNavState){
    if(state.player==SearchState.PLAYER_AI){
      return      BlocProvider<SearchBloc>(
        create: (context)=>SearchBloc(CameraBloc()
          ..add(StartCameraEvent()),state.player),
        child: SearchScreen(),
      );
    }else{
      //@TODO add human guesser bloc
      return  BlocProvider<ChallengeBloc>(
        create: (context)=>ChallengeBloc(),
        child: ChallengeScreen(),
      );
    }

  }else if (state is GuessingNavState){
    if(state.spiedModel==null){
      throw Exception('spiedModel is not set [home screen]');
    }
    print("open guess screen");
    return BlocProvider<GuessBloc>(
        create: (context)=>GuessBloc(state.spiedModel)..add(StartGuessEvent()),
            child: GuessScreen(),
    );
  }

}

