import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ispy/blocs/search/search_bloc.dart';
import 'package:ispy/blocs/search/search_state.dart';
import 'package:ispy/paint/eye_painter.dart';
import 'package:ispy/widgets/spinner_widget.dart';

class SearchWidget extends StatelessWidget {
  SearchWidget({Key key}) : super(key: key);
  final bool isDetecting = false;

  @override
  Widget build(BuildContext context) {
    CameraController controller;
    return BlocBuilder<SearchBloc, SearchState>(
         builder: (context, state) {
      if (state is SearchLoadedState ) {
        return Stack(
          children: <Widget>[
            CameraPreview(state.cameraController),

            CustomPaint(child:    SpinKitDualRing(
              color: Colors.lightBlueAccent.withOpacity(0.3),
              size: 100,

            ),
              size: Size.infinite,
              painter: EyePainter(color: Colors.black),
            ),
          ],
        );
      } else if (state is SearchClueState) {
        return Text('start guessing');
      } else {
        return Container(color: Colors.black,);
      }
    });
  }

}
