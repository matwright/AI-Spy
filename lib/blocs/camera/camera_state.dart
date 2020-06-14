import 'package:camera/camera.dart';
import 'package:ispy/data/spied_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CameraState {}

class InitialCameraState extends CameraState {}
class CameraStartedState extends CameraState {
  CameraController controller;
  CameraStartedState(this.controller);
}
class ImageCapturedState extends CameraState {

final SpiedModel spiedModel;
ImageCapturedState(this.spiedModel);
  @override
  List<Object> get props => [];
}