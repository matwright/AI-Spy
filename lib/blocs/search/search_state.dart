import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:ispy/data/spied_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();
}

class InitialSearchState extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchLoadingState extends SearchState {
  @override
  List<Object> get props => [];
}

class SearchLoadedState extends SearchState {

  CameraController cameraController;
  SearchLoadedState(this.cameraController);
  @override
  List<Object> get props => [];


}


class SearchClueState extends SearchState {
  final SpiedModel spiedModel;
  SearchClueState(this.spiedModel);
  @override
  List<Object> get props => [];
}


class CameraLoadedState extends SearchState {
  final CameraDescription camera;
  CameraLoadedState(this.camera);
  @override
  List<Object> get props => [];
}

class ImagesSelectedState extends SearchState {

  final selectedObject;
  ImagesSelectedState(this.selectedObject);
  @override
  List<Object> get props => [];

}


