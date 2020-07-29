part of 'challenge_bloc.dart';

abstract class ChallengeEvent {}
class PromptHumanEvent extends ChallengeEvent{
  PromptHumanEvent();
}

class StartChallengeEvent extends ChallengeEvent{
  String humanClue;
  StartChallengeEvent(this.humanClue);
}

class HumanNotUnderstoodEvent extends ChallengeEvent{
  HumanNotUnderstoodEvent();
}



