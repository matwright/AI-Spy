import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'challenge_event.dart';

part 'challenge_state.dart';

class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {

  ChallengeBloc():super(InitialChallengeState());
  @override
  ChallengeState get initialState => InitialChallengeState();

  @override
  Stream<ChallengeState> mapEventToState(ChallengeEvent event) async* {
    // TODO: Add your event logic
  }
}
