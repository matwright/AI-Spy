import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ispy/blocs/camera/bloc.dart';
import 'package:meta/meta.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'challenge_event.dart';

part 'challenge_state.dart';

class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {

  String humanClue;
  bool humanClueComplete=false;
  ChallengeBloc():super(InitialChallengeState()){

  this.onChange.listen((e) {
  if ((e.eventData) == 'spokenword') {
  print('***SPOKEN WORD PROCESSING***');
  humanClueComplete=true;
  this.add(StartChallengeEvent(humanClue));
  }
  if ((e.eventData) == 'notunderstand') {
  print('***SPOKEN WORD ERROR PROCESSING***');
  this.add(HumanNotUnderstoodEvent());
  }

  });
}

var changeController = new StreamController<CapturedEvent>();

Stream<CapturedEvent> get onChange => changeController.stream;


@override
  ChallengeState get initialState => InitialChallengeState();

  @override
  Stream<ChallengeState> mapEventToState(ChallengeEvent event) async* {
print(event);
if(event is PromptHumanEvent){
  yield* _mapPromptHumanEventToState(event);
}else  if(event is StartChallengeEvent){
  await new Future.delayed(const Duration(seconds : 3));
  FlutterTts flutterTts = FlutterTts();
  await flutterTts.setSpeechRate(0.8);
  print("VoiceProcessedEvent!!!");
  String clue;
  print('***GUESS*** '+humanClue);

  yield ChallengeStartedState(humanClue);

}else  if(event is HumanNotUnderstoodEvent){
  yield *_mapHumanNotUnderstoodEventToState(event);
}
  }



  Stream<ChallengeState> _mapHumanNotUnderstoodEventToState(HumanNotUnderstoodEvent event) async* {
    print("NOT UNDERSTOOD!!!");
  }

  Stream<ChallengeState> _mapPromptHumanEventToState(PromptHumanEvent event) async* {
    FlutterTts flutterTts = FlutterTts();
    await flutterTts.setSpeechRate(0.8);

    String text="Okay, you're turn.";
    await  flutterTts.speak(text);
    await new Future.delayed(const Duration(seconds : 3));
    print("***START LISTENING FOR HUMAN***");
    SpeechToText speech = SpeechToText();

    bool available = await speech.initialize( onStatus: statusListener, onError: errorListener);
    if ( available ) {
      speech.listen( onResult: resultListener,  listenFor: Duration(seconds: 10),  partialResults: true,onDevice: true,
          listenMode: ListenMode.dictation);
    }
    else {
      print("The user has denied the use of speech recognition.");
    }

    while(!humanClueComplete){
      yield HumanPromptedState(humanClue);
      await new Future.delayed(const Duration(milliseconds : 500));
    }

  }


  void resultListener(SpeechRecognitionResult result) {
    humanClue=result.recognizedWords;
    print(result.alternates);
    if(result.finalResult==true){
      print("${result.recognizedWords} - ${result.finalResult}");
     changeController.add(new CapturedEvent('spokenword'));
    }else{
      changeController.add(new CapturedEvent('spokenpart'));
    }


  }
  void errorListener(SpeechRecognitionError error) {
    print('errorListener: '+error.toString());
    changeController.add(new CapturedEvent('notunderstand'));
  }

  void statusListener(String status) {
    print('statusListener: '+status);
  }

}
