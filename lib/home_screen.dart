import 'package:assets_audio_player/assets_audio_player.dart';
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
import 'package:video_player/video_player.dart';

class HomeScreen extends StatelessWidget {
  final String name;
  int navIndex = 0;
  HomeScreen({Key key, @required this.name}) : super(key: key);
  VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<NavBloc, NavState>(builder: (_, state) {
      return Scaffold(
        drawer: Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child:
            Image(image: AssetImage('assets/logo.png')),

            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),

          AboutListTile(
            applicationIcon: Icon(Icons.info_outline),
            applicationName: "AI Spy",
            applicationVersion: "1.0.0.beta",
            icon: Icon(
              Icons.info_outline,
              size: 32,
            ),
            applicationLegalese:
            "Mat Wright\n\nhttps://matwright.dev\n\nThis app is a research & development project by Matthew Wright. If you have any questions please contact me at mail@matwright.dev",
            aboutBoxChildren: <Widget>[
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircleAvatar(
                          maxRadius: 50,
                          minRadius: 25,
                          backgroundColor: Colors.white.withOpacity(0),
                          backgroundImage:
                          AssetImage('assets/matwright.jpg'))))
            ],
          ),


        ],
      ),
      ),
          appBar: AppBar(
            title: Text('aISpy v1.0.beta',
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

    AssetsAudioPlayer.newPlayer().open(
      Audio("assets/intro.mp3"
      ,metas: Metas(  id:'intro')
      ),
      autoStart: true,
      showNotification: true,

playInBackground: PlayInBackground.disabledPause
    );

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
