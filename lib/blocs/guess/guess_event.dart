import 'package:ispy/data/spied_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GuessEvent {}

class InitializeGuessEvent extends GuessEvent {
  InitializeGuessEvent();
}

class StartGuessEvent extends GuessEvent {}

class VoiceGuessEvent extends GuessEvent {}

class VoiceProcessedEvent extends GuessEvent {}

class VoiceErrorEvent extends GuessEvent {}
