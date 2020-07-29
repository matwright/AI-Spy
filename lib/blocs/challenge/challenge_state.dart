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