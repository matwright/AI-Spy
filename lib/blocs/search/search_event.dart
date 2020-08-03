import 'package:equatable/equatable.dart';
import 'package:ispy/data/spied_model.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class LoadSearchEvent extends SearchEvent {
  @override
  List<Object> get props => [];
  LoadSearchEvent();
}

class ImageSelectedEvent extends SearchEvent {
  @override
  List<Object> get props => [];

  ImageSelectedEvent();
}
