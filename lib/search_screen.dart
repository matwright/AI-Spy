import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ispy/blocs/camera/bloc.dart';
import 'package:ispy/blocs/search/search_bloc.dart';
import 'package:ispy/blocs/search/search_event.dart';
import 'package:ispy/blocs/search/search_state.dart';
import 'package:ispy/blocs/nav/bloc.dart';
import 'package:ispy/widgets/search_widget.dart';
import 'package:ispy/widgets/spinner_widget.dart';



class SearchScreen extends StatelessWidget {

    nav(context, state)  {
      print('***redirection***');
  BlocProvider.of<NavBloc>(context).add(NavGuessEvent(state.spiedModel));
}
  @override
  Widget build(BuildContext context) {

    return BlocBuilder<SearchBloc, SearchState>(

      builder: (context, state) {
        print('search state: '+state.toString());
        if(state is SearchLoadedState){

        }

        if(state is SearchClueState){
          print('***redirecting***');
            nav(context,state);
         return SpinnerWidget();
        }

        return Scaffold(

              floatingActionButton: FloatingActionButton(
                heroTag: "addKid",
                onPressed: () async {

                },
                child: Icon(Icons.add),
                tooltip: 'new search',
              )
              ,
              body:
              Column(
                children: <Widget>[
                  Text('Search'),
                  SearchWidget()
                ],
              )

          );




      },
    );
  }
}