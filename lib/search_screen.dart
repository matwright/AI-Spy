import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ispy/blocs/camera/bloc.dart';
import 'package:ispy/blocs/search/search_bloc.dart';
import 'package:ispy/blocs/search/search_event.dart';
import 'package:ispy/blocs/search/search_state.dart';
import 'package:ispy/blocs/nav/bloc.dart';
import 'package:ispy/blocs/sensors/sensors_bloc.dart';
import 'package:ispy/widgets/metrics_widget.dart';
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

        if (state is SearchClueState) {
          print('***redirecting***');
          nav(context, state);
          return SpinnerWidget();
        }

       List<Widget> stack = [

          SearchWidget(),
          MetricsWidget(),

        ];

        if(state is InitialSearchState){
          stack.add(Image(image: AssetImage('assets/eye.png'),fit: BoxFit.scaleDown,height: 100,));
        }

        return Scaffold(
            body: Stack(
              fit: StackFit.expand,
             alignment: Alignment.topCenter,
          children: stack,
        ));
      },
    );
  }
}
