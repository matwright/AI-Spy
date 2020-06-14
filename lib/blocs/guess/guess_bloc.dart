import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ispy/blocs/camera/bloc.dart';
import 'package:ispy/data/spied_model.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import './bloc.dart';

class GuessBloc extends Bloc<GuessEvent, GuessState> {

  GuessBloc(this.spiedModel) {
    this.onChange.listen((e) {
      if ((e.eventData) == 'spokenword') {
        print('***SPOKEN WORD PROCESSING***');
        this.add(VoiceProcessedEvent());
      }
      if ((e.eventData) == 'notunderstand') {
        print('***SPOKEN WORD ERROR PROCESSING***');
        this.add(VoiceErrorEvent());
      }

    });
  }

  var changeController = new StreamController<CapturedEvent>();

  Stream<CapturedEvent> get onChange => changeController.stream;
  @override
  GuessState get initialState => InitialGuessState();
  int numTries=0;
  SpiedModel spiedModel;
  String guessWord;

  @override
  Stream<GuessState> mapEventToState(
    GuessEvent event,
  ) async* {
    if(event is InitializeGuessEvent){
      yield InitialGuessState();
    }else  if(event is StartGuessEvent){
      print("StartGuessEvent!!!");
      yield* _mapStartGuessEventToState(event);
    }else  if(event is VoiceGuessEvent){
      print("StartVoiceGuessEvent!!!");
      yield* _mapStartVoiceGuessEventToState(event);
    }else  if(event is VoiceProcessedEvent){
      print("VoiceProcessedEvent!!!");
      yield VoiceProcessedState(guessWord, spiedModel, numTries);
    }else  if(event is VoiceErrorEvent){
      print("VoiceErrorEvent!!!");
      yield* _mapStartVoiceErrorEventToState(event);


    }


  }

  Stream<GuessState> _mapStartVoiceErrorEventToState(VoiceErrorEvent event) async* {
    String clue="Sorry, I did not understand. Please try again.";
    FlutterTts flutterTts = FlutterTts();
    await flutterTts.speak(clue);
    yield VoiceGuessState(spiedModel,numTries);
  }


  Stream<GuessState> _mapStartVoiceGuessEventToState(VoiceGuessEvent event) async* {
    print("***START LISTENING***");
    SpeechToText speech = SpeechToText();
    bool available = await speech.initialize( onStatus: statusListener, onError: errorListener );
    if ( available ) {
      speech.listen( onResult: resultListener );
    }
    else {
      print("The user has denied the use of speech recognition.");
    }
    yield VoiceGuessState(spiedModel,numTries);
  }

  Stream<GuessState> _mapStartGuessEventToState(StartGuessEvent event) async* {
    yield StartGuessState(spiedModel,numTries);
  }

  void resultListener(SpeechRecognitionResult result) {
    print("${result.recognizedWords} - ${result.finalResult}");
    if(result.finalResult){
      guessWord=result.recognizedWords;
      numTries++;
      changeController.add(new CapturedEvent('spokenword'));
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
