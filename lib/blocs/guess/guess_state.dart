import 'package:ispy/data/spied_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GuessState {}

class InitialGuessState extends GuessState {}

class StartGuessState extends GuessState {
  final SpiedModel spiedModel;
  final int numTries;
   StartGuessState(this.spiedModel,this.numTries);

}

class VoiceGuessState extends GuessState {

  final SpiedModel spiedModel;
  final int numTries;

  VoiceGuessState(this.spiedModel,this.numTries);
}
class VoiceProcessedState extends GuessState {
  final String guessWord;
  final SpiedModel spiedModel;
  final int numTries;

  VoiceProcessedState(this.guessWord,this.spiedModel,this.numTries);
}

class GameOverState extends GuessState {

  final bool success;
  final SpiedModel spiedModel;
  final int numTries;

  GameOverState(this.success,this.spiedModel,this.numTries);
}
