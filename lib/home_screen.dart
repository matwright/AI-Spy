import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ispy/blocs/camera/bloc.dart';
import 'package:ispy/blocs/guess/bloc.dart';
import 'package:ispy/blocs/search/search_bloc.dart';
import 'package:ispy/blocs/search/search_event.dart';
import 'package:ispy/blocs/nav/bloc.dart';
import 'package:ispy/guess_screen.dart';
import 'package:ispy/search_screen.dart';
import 'package:ispy/widgets/appbar_widget.dart';

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

                body:

                NestedScrollView(
                    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        AppBarWidget(
                          title: null,
                          iconData: state.iconData,
                        ),

                      ];
                    },
                    body:_body(state,context)
                )
            );
          }
      );

  }
}

_body(NavState state,BuildContext context){
  if(state is InitialNavState || state is HomeNavState){

    return FlatButton(onPressed:   ()=>BlocProvider.of<NavBloc>(context).add(NavPlayEvent()), child: Text('Start Search'));

  }else if(state is PlayNavState){
    return      BlocProvider<SearchBloc>(
        create: (context)=>SearchBloc(CameraBloc()
          ..add(StartCameraEvent())),
      child: SearchScreen(),
    );
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

