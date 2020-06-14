import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ispy/blocs/search/search_bloc.dart';
import 'package:ispy/blocs/search/search_state.dart';
import 'package:ispy/widgets/spinner_widget.dart';

class SearchWidget extends StatelessWidget {
  SearchWidget({Key key}) : super(key: key);
  bool isDetecting = false;

  @override
  Widget build(BuildContext context) {

    CameraController controller;
    return  BlocConsumer<SearchBloc, SearchState>(
        listener: (context, state) {
          // do stuff here based on BlocA's state
        },
      builder: (context, state) {

        if (state is SearchLoadedState ) {
          return AspectRatio(
              aspectRatio:
              state.cameraController.value.aspectRatio,
              child: CameraPreview(state.cameraController));

      }else if(state is SearchClueState){
          return Text('start guessing');
        }else{
    return SpinnerWidget();
    }

  }
    );
}}
