import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ispy/widgets/contained_text.dart';

class CaptureObjectWidget extends StatelessWidget {
  final CameraController cameraController;

  CaptureObjectWidget(this.cameraController);
  @override
  Widget build(BuildContext context) {

    return Container(
      child:
      Column(
        children: [
          ContainedText('I give up'),
          CameraPreview(cameraController),
        ],
      )

    );
  }
}
