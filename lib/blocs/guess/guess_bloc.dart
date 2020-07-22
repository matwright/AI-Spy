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

  GuessBloc(this.spiedModel):super(InitialGuessState()) {
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

  int numTries=0;
  int maxTries=5;
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
      await new Future.delayed(const Duration(seconds : 3));
      FlutterTts flutterTts = FlutterTts();
      await flutterTts.setSpeechRate(0.8);
      print("VoiceProcessedEvent!!!");
      String clue;
      print('***GUESS*** '+guessWord);
      print('***SPIED*** '+spiedModel.word);
      if(guessWord.toLowerCase().replaceAll(' ', '')==spiedModel.word.toLowerCase().replaceAll(' ', '')){
        clue="Hurray! Well done. You guessed correctly! Human wins";
        flutterTts.speak(clue);
        yield GameOverState(true, spiedModel, numTries);
      }else if(numTries==maxTries){

        clue="No! Sorry, That's not correct. You've used up all your five turns. AI is the winner.";
        flutterTts.speak(clue);
        yield GameOverState(false, spiedModel, numTries);
      }else{
        List answersList=[
          "No! Sorry, That's not correct. Have another go.",
          "Wrong! Come on you can do better than this. Third time lucky maybe.",
          "Incorrect. Oh dear you are not very good at this. And to think I was created by your kind.",
          "Still wrong. Is your neural network operational?"

        ];
        Map answers=answersList.asMap();
        flutterTts.speak(answers[numTries-1]);
        yield VoiceProcessedState(guessWord, spiedModel, numTries);
      }





    }else  if(event is VoiceErrorEvent){

yield *_mapStartVoiceErrorEventToState(event);
    }


  }



  Stream<GuessState> _mapStartVoiceErrorEventToState(VoiceErrorEvent event) async* {

    String clue="Sorry, I did not understand. Please try again.";
    FlutterTts flutterTts = FlutterTts();
    await flutterTts.speak(clue);
    yield VoiceProcessedState(guessWord, spiedModel, numTries);
  }


  Stream<GuessState> _mapStartVoiceGuessEventToState(VoiceGuessEvent event) async* {
    if(numTries==0){
      String clue="OK, tell me your answer after the bleep.";
      FlutterTts flutterTts = FlutterTts();
      await flutterTts.speak(clue);
      await new Future.delayed(const Duration(seconds : 3));
    }



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

    if(result.finalResult==true){
      print("${result.recognizedWords} - ${result.finalResult}");
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
