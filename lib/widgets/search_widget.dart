import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ispy/blocs/search/search_bloc.dart';
import 'package:ispy/blocs/search/search_state.dart';
import 'package:ispy/paint/eye_painter.dart';
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

          return
            Expanded(child:
            Stack(
              children: <Widget>[

                CameraPreview(state.cameraController),
                CustomPaint(
                  size: Size.infinite,
                  painter: EyePainter(color: Colors.black),
                ),
              ],
            )


            );


      }else if(state is SearchClueState){
          return Text('start guessing');
        }else{
    return SpinnerWidget();
    }

  }
    );
}

  void _drawBackground(Canvas canvas, Rect shapeBounds, Rect avatarBounds) {
    //1
    final paint = Paint()..color = Colors.black;

    //2
    final backgroundPath = Path()
      ..moveTo(shapeBounds.left, shapeBounds.top) //3
      ..lineTo(shapeBounds.bottomLeft.dx, shapeBounds.bottomLeft.dy) //4
      ..arcTo(avatarBounds, -pi, pi, false) //5
      ..lineTo(shapeBounds.bottomRight.dx, shapeBounds.bottomRight.dy) //6
      ..lineTo(shapeBounds.topRight.dx, shapeBounds.topRight.dy) //7
      ..close(); //8

//3
    //9
    canvas.drawPath(backgroundPath, paint);
  }
}
