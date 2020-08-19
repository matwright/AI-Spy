import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ispy/blocs/challenge/challenge_bloc.dart';
import 'package:ispy/widgets/button_widget.dart';
import 'package:ispy/widgets/contained_text.dart';

class CaptureObjectWidget extends StatelessWidget {
  final CameraController cameraController;

  final String humanClue;
  CaptureObjectWidget(this.cameraController,this.humanClue);

  _takePicture(context) {
    print('TAKE PICTURE');
    BlocProvider.of<ChallengeBloc>(context).add(TakePictureEvent());
  }
  @override
  Widget build(BuildContext context) {

    return Stack(

      children: [

        CameraPreview(cameraController),
        ContainedText(humanClue),
        ButtonWidget(MaterialCommunityIcons.camera_outline,'Take Picture',()=>_takePicture(context)),

      ],
    );
  }
}
