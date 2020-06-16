import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

class SpiedModel{
  CameraImage cameraImage;
  Map rect;
  String word;
  var aspectRatio;
  List<dynamic> finalImage;
  SpiedModel(this.cameraImage,this.rect,this.word,this.finalImage,this.aspectRatio);



}