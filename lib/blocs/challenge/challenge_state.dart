part of 'challenge_bloc.dart';

abstract class ChallengeState {}

class InitialChallengeState extends ChallengeState {}

class HumanPromptedState extends ChallengeState {
  String humanClue;
  HumanPromptedState(this.humanClue);
}

class ChallengeStartedState extends ChallengeState {
  String humanClue;
  ChallengeStartedState(this.humanClue);
}

class GuessState extends ChallengeState {
  String humanClue;
  SpiedModel spiedModel;
  GuessState(this.humanClue, this.spiedModel);
}

class GuessingState extends ChallengeState {
  GuessingState();
}

class GiveUpState extends ChallengeState {
  String humanClue;

  GiveUpState(this.humanClue);
}

class ObjectCaptureState extends ChallengeState {
  String humanClue;
  CameraController controller;
  ObjectCaptureState(this.humanClue,this.controller);
}

class ObjectCapturedState extends ChallengeState {
  String humanClue;
  ObjectCapturedState(this.humanClue);
}
