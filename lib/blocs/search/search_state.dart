import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:ispy/data/spied_model.dart';

abstract class SearchState extends Equatable {
  const SearchState(this.player);
  static const String PLAYER_AI="AI";
  static const String PLAYER_HUMAN="human";
  final String player;
}

class InitialSearchState extends SearchState {
  InitialSearchState(String player):super(player);
  @override
  List<Object> get props => [];
}

class SearchLoadingState extends SearchState {
  SearchLoadingState(String player):super(player);
  @override
  List<Object> get props => [];
}

class SearchLoadedState extends SearchState {

  final CameraController cameraController;
  SearchLoadedState(this.cameraController,String player):super(player);
  @override
  List<Object> get props => [];
}


class SearchClueState extends SearchState {
  final SpiedModel spiedModel;
  SearchClueState(this.spiedModel,String player):super(player);
  @override
  List<Object> get props => [];
}


class CameraLoadedState extends SearchState {
  final CameraDescription camera;
  CameraLoadedState(this.camera,String player):super(player);
  @override
  List<Object> get props => [];
}

class ImagesSelectedState extends SearchState {

  final selectedObject;
  ImagesSelectedState(this.selectedObject,String player):super(player);
  @override
  List<Object> get props => [];

}


