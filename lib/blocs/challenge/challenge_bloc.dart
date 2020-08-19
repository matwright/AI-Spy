import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ispy/blocs/camera/bloc.dart';
import 'package:ispy/data/speech.dart';
import 'package:ispy/data/spied_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uuid/uuid.dart';
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
  SpiedModel spiedObject;

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
    if (event is AIWinsEvent) {
      await AssetsAudioPlayer.newPlayer().open(
        Audio("assets/ai_wins.mp3"),
        showNotification: true,
      );
      FlutterTts flutterTts = FlutterTts();
      await flutterTts.setSpeechRate(0.8);
      print("VoiceProcessedEvent!!!");
      print('***GUESS*** ' + humanClue);
      await flutterTts.speak('A I Wins ');
      yield AIWinsState(humanClue,spiedObject);
    } else
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
    }else if(event is TakePictureEvent){
      final path =    (await getTemporaryDirectory()).path+'${DateTime.now()}.png';
      AssetsAudioPlayer.newPlayer().open(
          Audio("assets/capture.mp3"
              ,metas: Metas(  id:'intro')
          ),
          autoStart: true,
          showNotification: true,

          playInBackground: PlayInBackground.disabledPause
      );
      print(humanClue);
      print('***');
      // Attempt to take a picture and log where it's been saved.
      //await cameraController.stopImageStream();
      await cameraController.takePicture(path);
      print(path);
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: path,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Select Object',
              toolbarColor: Colors.black,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              hideBottomControls:true,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          )
      );

      final FirebaseStorage storage = FirebaseStorage.instance;

      final String uuid = Uuid().v1();
      final fileName=humanClue.replaceAll(new RegExp(r'[^\w\s]+'),'');

      final StorageReference imageRef =
      storage.ref().child(uuid).child(fileName+'.png');
      print(imageRef.path);
      final StorageUploadTask uploadImageTask = imageRef.putFile(
        File(path),
        StorageMetadata(
          contentLanguage: 'en',
          customMetadata: <String, String>{'label': humanClue,'type':'full'},
        ),
      );

      final StorageReference ref =
      storage.ref().child(uuid).child(fileName+'_cropped.png');
      final StorageUploadTask uploadCropped = ref.putFile(
        croppedFile,
        StorageMetadata(
          contentLanguage: 'en',
          customMetadata: <String, String>{'label': humanClue,'type':'cropped'},
        ),
      );


      yield ObjectCapturedState(humanClue,croppedFile);


    }



    }
  Stream<ChallengeState> _mapStartObjectCaptureEventToState(StartObjectCaptureEvent event)async*{

      if (isProcessingStream == false) {
        print('starting camera');
        //cameraController == null || !cameraController.value.isInitialized
        isProcessingStream = true;
        cameras = await availableCameras();
        print(cameras);
        cameraController =  CameraController(
          cameras[0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await cameraController.initialize();
//await cameraController.startImageStream((processImage));

        print('***START STREAM***');


      }
      yield ObjectCaptureState(humanClue,cameraController);
    }

  processImage(CameraImage img) async {

  }

  Stream<ChallengeState> _mapStartGuessingEventToState(StartGuessingEvent event,FlutterTts flutterTts)async* {
    await new Future.delayed(Duration(seconds: 1));
    int n = Random(1).nextInt(3) + 1;
    print(n.toString()+ ' hesitations');
    yield GuessingState();

    for (int i = 0; n > i; i++) {
      if(timedout==true){
        print('timed out in for');
        break;
      }
      if(timedout==false) {
        String hesitation = Speech.say(type: Speech.HESITATION);
        await flutterTts.speak(hesitation);
        int delay = Random(1).nextInt(5) ;
print('1.delay for '+delay.toString()+' seconds');
        await new Future.delayed(
            Duration(seconds: delay));
      }
    }

    if (timedout==true || filteredSpiedObjectsIndex == filteredSpiedObjects.length) {
      timedout=false;
      FlutterTts flutterTts = FlutterTts();
      String say=Speech.say(type: Speech.GIVE_UP);
      await flutterTts.speak(say);
      int delay = say.length~/10;
      print('2.delay for '+delay.toString()+' seconds');
      await new Future.delayed(Duration(seconds: delay.toInt()));
      await flutterTts.speak("Human wins.");
      await new Future.delayed(const Duration(seconds: 4));
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
       spiedObject =
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
    yield GiveUpState(humanClue);
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
      print('listening for 10 secs');
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
