import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ispy/blocs/camera/bloc.dart';
import 'package:ispy/data/speech.dart';
import 'package:ispy/data/spied_model.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'challenge_event.dart';

part 'challenge_state.dart';

class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {
  String humanClue;
  bool timedout=false;
  Box spiedBox;
  bool confirmSent=false;
  bool humanClueComplete = false;
  int filteredSpiedObjectsIndex = 0;
  List<SpiedModel> filteredSpiedObjects;
  List<CameraDescription> cameras;
  CameraController cameraController;
  bool isProcessingStream = false;

  ChallengeBloc() : super(InitialChallengeState()) {
    this.onChangeEvent.listen((e) {
      if ((e.eventData) == 'spokenword') {
        print('***SPOKEN WORD PROCESSING***');
        humanClueComplete = true;
        print('timedout:'+timedout.toString());
        if(timedout==true){
          this.add(StartObjectCaptureEvent(humanClue));
        }else{
          this.add(StartChallengeEvent(humanClue));
        }

      }
      if ((e.eventData) == 'notunderstand') {
        print('***SPOKEN WORD ERROR PROCESSING***');
        this.add(HumanNotUnderstoodEvent());
      }
    });
  }

  var changeController = new StreamController<CapturedEvent>();

  Stream<CapturedEvent> get onChangeEvent => changeController.stream;

  @override
  ChallengeState get initialState => InitialChallengeState();

  @override
  Stream<ChallengeState> mapEventToState(ChallengeEvent event) async* {
    print(event);
    if (null == spiedBox) {
      await Hive.initFlutter();
      spiedBox = await Hive.openBox<SpiedModel>('spiedBox');
    }
    FlutterTts flutterTts = FlutterTts();
    if (event is PromptHumanEvent) {
      humanClue='';
      timedout=false;
      yield* _mapPromptHumanEventToState(event);
    } else if (event is StartChallengeEvent) {


      if(confirmSent==false) {
        await new Future.delayed(const Duration(seconds: 3));
        FlutterTts flutterTts = FlutterTts();
        await flutterTts.setSpeechRate(0.8);
        print("VoiceProcessedEvent!!!");
        print('***GUESS*** ' + humanClue);
        await flutterTts.speak('Please confirm the letter is ' +
            humanClue.substring(humanClue.length - 1));
        confirmSent = true;
      }

      yield ChallengeStartedState(humanClue);
    } else if (event is HumanNotUnderstoodEvent) {
      yield* _mapHumanNotUnderstoodEventToState(event);
    }

    else if (event is StartGuessingEvent) {
      if (filteredSpiedObjects == null) {
        filteredSpiedObjects = spiedBox.values
            .where((spiedObject) => spiedObject.word
                .startsWith(humanClue.substring(humanClue.length - 1)))
            .toList();
      }

      await flutterTts.setSpeechRate(0.8);
     yield* _mapStartGuessingEventToState(event,flutterTts);
  }else if(event is StartObjectCaptureEvent){

      yield* _mapStartObjectCaptureEventToState(event);
    }

    }
  Stream<ChallengeState> _mapStartObjectCaptureEventToState(StartObjectCaptureEvent event)async*{

      if (isProcessingStream == false) {
        print('starting camera');
        //cameraController == null || !cameraController.value.isInitialized
        isProcessingStream = true;
        cameras = await availableCameras();
        cameraController = CameraController(
          cameras[0],
          ResolutionPreset.low,
          enableAudio: false,
        );
await cameraController.startImageStream((image) => null);
        await cameraController.initialize();
        print('***START STREAM***');


      }
      yield ObjectCaptureState(humanClue,cameraController);
    }

  Stream<ChallengeState> _mapStartGuessingEventToState(StartGuessingEvent event,FlutterTts flutterTts)async* {
    int n = Random().nextInt(3) + 1;
    print(n.toString()+ ' hesitations');
    yield GuessingState();
    for (int i = 0; n > i; i++) {
      if(timedout==true){
        print('timed out in for');
        break;
      }
      await flutterTts.speak(Speech.say(type: Speech.HESITATION));
      await new Future.delayed(Duration(seconds: Random().nextInt(5) + 3));
    }

    if (timedout==true || filteredSpiedObjectsIndex == filteredSpiedObjects.length) {
      timedout=true;
      FlutterTts flutterTts = FlutterTts();
      await new Future.delayed(Duration(seconds: Random().nextInt(5) + 3));
      await flutterTts.speak(Speech.say(type: Speech.GIVE_UP));
      await new Future.delayed(const Duration(seconds: Speech.GIVE_UP.length*5));
      await flutterTts.speak("Human wins.");
      await new Future.delayed(const Duration(seconds: 3));
      await flutterTts.speak("Please tell me what you spied.");
      await new Future.delayed(const Duration(seconds: 4));
      if(humanClue!=null){
        humanClue=null;
      }
      print("***START LISTENING***");
      SpeechToText speech = SpeechToText();
      bool available = await speech.initialize(
          onStatus: statusListener, onError: errorListener);
      if (available) {
        await speech.listen(onResult: resultListener);
      } else {
        print("The user has denied the use of speech recognition.");
      }
      yield GiveUpState(humanClue);
      while (!humanClueComplete) {
        yield GiveUpState(humanClue);
        await new Future.delayed(const Duration(milliseconds: 500));
      }

    } else {
      SpiedModel spiedObject =
      filteredSpiedObjects.elementAt(filteredSpiedObjectsIndex);
      filteredSpiedObjectsIndex++;

      String text = "Is it a " + spiedObject.word + '?';
      await flutterTts.speak(text);
      yield GuessState(humanClue, spiedObject);
    }
  }

  Stream<ChallengeState> _mapHumanNotUnderstoodEventToState(
      HumanNotUnderstoodEvent event) async* {
    print("NOT UNDERSTOOD!!!");
  }

  Stream<ChallengeState> _mapPromptHumanEventToState(
      PromptHumanEvent event) async* {
    FlutterTts flutterTts = FlutterTts();
    await flutterTts.setSpeechRate(0.8);

    String text = "Okay, your turn.";
    await flutterTts.speak(text);
    await new Future.delayed(const Duration(seconds: 3));
    print("***START LISTENING FOR HUMAN***");
    SpeechToText speech = SpeechToText();

    bool available = await speech.initialize(
        onStatus: statusListener, onError: errorListener);
    if (available) {
      speech.listen(
          onResult: resultListener,
          listenFor: Duration(seconds: 10),
          partialResults: true,
          onDevice: true,
          listenMode: ListenMode.dictation);
    } else {
      print("The user has denied the use of speech recognition.");
    }
    yield HumanPromptedState(humanClue);
    while (!humanClueComplete) {
      yield HumanPromptedState(humanClue);
      await new Future.delayed(const Duration(milliseconds: 500));
    }
  }

  void resultListener(SpeechRecognitionResult result) {
    humanClue = result.recognizedWords;
    print(result.alternates);
    if (result.finalResult == true) {
      print("${result.recognizedWords} - ${result.finalResult}");
      changeController.add(new CapturedEvent('spokenword'));
    } else {
      changeController.add(new CapturedEvent('spokenpart'));
    }
  }

  void errorListener(SpeechRecognitionError error) {
    print('errorListener: ' + error.toString());
    changeController.add(new CapturedEvent('notunderstand'));
  }

  void statusListener(String status) {
    print('statusListener: ' + status);
  }
}
