part of 'challenge_bloc.dart';

abstract class ChallengeEvent {}

class PromptHumanEvent extends ChallengeEvent {
  PromptHumanEvent();
}

class StartChallengeEvent extends ChallengeEvent {
  String humanClue;
  StartChallengeEvent(this.humanClue);
}

class HumanNotUnderstoodEvent extends ChallengeEvent {
  HumanNotUnderstoodEvent();
}

class StartGuessingEvent extends ChallengeEvent {
  StartGuessingEvent();
}

class TimeOutEvent extends ChallengeEvent {
  TimeOutEvent();
}

class StartObjectCaptureEvent extends ChallengeEvent {
  String humanClue;
  StartObjectCaptureEvent(this.humanClue);
}

class ObjectCapturedEvent extends ChallengeEvent {
  ObjectCapturedEvent();
}
