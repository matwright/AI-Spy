import 'package:camera/camera.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CameraEvent {}

class StartCameraEvent extends CameraEvent {
  @override
  StartCameraEvent();
}

class CaptureImageEvent extends CameraEvent {
  @override
  List<Object> get props => [];
  CameraImage cameraImage;
  CaptureImageEvent(this.cameraImage);
}

class CameraStoppedEvent extends CameraEvent {
  @override
  List<Object> get props => [];

  CameraStoppedEvent();
}
