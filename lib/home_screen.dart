import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ispy/blocs/camera/bloc.dart';
import 'package:ispy/blocs/challenge/challenge_bloc.dart';
import 'package:ispy/blocs/guess/bloc.dart';
import 'package:ispy/blocs/search/bloc.dart';
import 'package:ispy/blocs/search/search_bloc.dart';
import 'package:ispy/blocs/nav/bloc.dart';
import 'package:ispy/blocs/sensors/sensors_bloc.dart';
import 'package:ispy/challenge_screen.dart';
import 'package:ispy/guess_screen.dart';
import 'package:ispy/search_screen.dart';
import 'package:ispy/widgets/button_widget.dart';

class HomeScreen extends StatelessWidget {
  final String name;
  int navIndex = 0;
  HomeScreen({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBloc, NavState>(builder: (_, state) {
      return Scaffold(
          appBar: AppBar(
            title: Text('iSpy v1.0.beta',
              textAlign: TextAlign.center,
              style: TextStyle(

                  fontSize: 18,

                  fontFamily: "Digital"
              ),),

          ),
          extendBodyBehindAppBar: false,
          body:
      Container(
      decoration: BoxDecoration(
      image: DecorationImage(
      image: AssetImage("assets/ispybg.png"),
      colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.hardLight),

      fit: BoxFit.cover,
      ),
      ),
      child:

      _body(state, context)));
    });
  }
}

_playAI(context){
  BlocProvider.of<NavBloc>(context)
      .add(NavPlayEvent(SearchState.PLAYER_AI));
}

_body(NavState state, BuildContext context) {
  if (state is InitialNavState || state is HomeNavState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[

        Image(image: AssetImage('assets/logo.png')),

        Image(image: AssetImage('assets/eye.png')),
        ButtonWidget(MaterialCommunityIcons.eye_circle_outline, 'play', ()=>_playAI(context)),

      ],
    );
  } else if (state is PlayNavState) {
    if (state.player == SearchState.PLAYER_AI) {
      SearchBloc searchBloc= SearchBloc(CameraBloc()..add(StartCameraEvent()), state.player);

      return MultiBlocProvider(
          providers: [
            BlocProvider<SearchBloc>(
              create: (context) =>
                  searchBloc
            )
            ,
            BlocProvider<SensorsBloc>(
              create: (context) =>
              SensorsBloc(searchBloc)..add(StartSensorsEvent()),
            )
        ],
        child: SearchScreen(),
      );
    } else {
      //@TODO add human guesser bloc
      return BlocProvider<ChallengeBloc>(
        create: (context) => ChallengeBloc()..add(PromptHumanEvent()),
        child: ChallengeScreen(),
      );
    }
  } else if (state is GuessingNavState) {
    if (state.spiedModel == null) {
      throw Exception('spiedModel is not set [home screen]');
    }

    return BlocProvider<GuessBloc>(
      create: (context) => GuessBloc(state.spiedModel)..add(StartGuessEvent()),
      child: GuessScreen(),
    );
  }
}
