import 'dart:async';
import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ispy/data/spied_model.dart';
import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as imglib;
import './bloc.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc() : super(InitialCameraState()) {
    this.onChangeEvent.listen((e) {
      if ((e.eventData) == 'captured' && this.imageCaptured == false) {
        this.imageCaptured = true;
        this.add(CameraStoppedEvent());
      }
    });
  }

  var changeController = new StreamController<CapturedEvent>();


  Stream<CapturedEvent> get onChangeEvent => changeController.stream;

  List<CameraDescription> cameras;
  CameraController cameraController;
  bool moveWarning = false;
  bool isProcessingStream = false;
  bool isProcessingFrame = false;
  bool model = false;
  double highestRating = 0;
  bool imageCaptured = false;
  int i = 0;
  SpiedModel spiedModel;
  Box spiedBox;
  List<String> spiedClasses = [];

  Future<List> convertYUV420toImage(CameraImage image) async {
    try {
      final int width = image.width;
      final int height = image.height;

      var img = imglib.Image(width, height); // Create Image buffer

      // Fill image buffer with plane[0] from YUV420_888
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
          final pixelColor = image.planes[0].bytes[y * width + x];
          // color: 0x FF  FF  FF  FF
          //           A   B   G   R
          // Calculate pixel color
          img.data[y * width + x] = (0xFF << 24) |
              (pixelColor << 16) |
              (pixelColor << 8) |
              pixelColor;
        }
      }

      imglib.PngEncoder pngEncoder = new imglib.PngEncoder(level: 0, filter: 0);
      List<int> png = pngEncoder.encodeImage(img);
      return png;
    } catch (e) {
      print("#65 ERROR:" + e.toString());
    }
    return null;
  }

  @override
  Stream<CameraState> mapEventToState(
    CameraEvent event,
  ) async* {
    if (null == spiedBox) {

      await Hive.initFlutter();

      spiedBox = await Hive.openBox<SpiedModel>('spiedBox');
      spiedBox.clear();
    }

    if (!model) {
      model = true;
      await Tflite.loadModel(
          model: "assets/detect.tflite",
          labels: "assets/labelmap.txt",
          numThreads: 2, // defaults to 1
          isAsset:
              true // defaults to true, set to false to load resources outside assets
          );
    }
    if (event is StartCameraEvent) {


      FlutterTts flutterTts = FlutterTts();

      print('voices');
      await flutterTts.setSpeechRate(0.8);

      String text = "Initialising neural network";
      await flutterTts.speak(text);

      await new Future.delayed(const Duration(seconds: 3));

      String text2 = "Please allow me to scan our environment";
      await flutterTts.speak(text2);
      AssetsAudioPlayer.newPlayer().open(
        Audio("assets/scanning.mp3"),
        showNotification: true,
      );
      yield* _mapStartCameraEventToState();
    } else if (event is CameraStoppedEvent) {
      yield ImageCapturedState(spiedModel);
    }
  }

  Future<void> processRecognitions(List recognitions, CameraImage img) async {
    double tmpHighestRating = 0.0;
    CameraImage tmpImg;
    var tmpElement;
    await Future.forEach(recognitions, (element) async {
      print('***HIGHEST***' + element["confidenceInClass"].toString());
      if (element["confidenceInClass"] > tmpHighestRating) {
        tmpHighestRating = element["confidenceInClass"];
        tmpImg = img;
        tmpElement = element;
      }
    });

    highestRating = tmpHighestRating;
    List<dynamic> finalImage = await convertYUV420toImage(tmpImg);

    SpiedModel tmpSpiedModel = new SpiedModel(
        tmpElement["rect"],
        tmpElement['detectedClass'],
        finalImage,
        cameraController.value.aspectRatio);
    if (null == spiedClasses ||
        !spiedClasses.contains(tmpElement['detectedClass'])) {
      print('WRITING TO BOX : ' + tmpElement['detectedClass']);
      await spiedBox.add(tmpSpiedModel);
      spiedClasses.add(tmpElement['detectedClass']);
    }
    return;
  }

  Stream<CameraState> _mapStartCameraEventToState() async* {
    print('***isProcessingStream***' + isProcessingStream.toString());
    if (isProcessingStream == false) {
      //cameraController == null || !cameraController.value.isInitialized
      isProcessingStream = true;
      cameras = await availableCameras();
      cameraController = CameraController(
        cameras[0],
        ResolutionPreset.low,
        enableAudio: false,
      );

      await cameraController.initialize();
      print('***START STREAM***');

      await cameraController.startImageStream(processImage);
    }
    yield CameraStartedState(cameraController);
  }

  processImage(CameraImage img) async {
    if (this.imageCaptured == true) {
      return;
    }


    if (isProcessingFrame == false && imageCaptured == false) {
      print('***LIST REC***');
      List recognitions = [];
      isProcessingFrame = true;
      List imageBytes = img.planes.map((plane) {
        return plane.bytes;
      }).toList();
      try {
        recognitions = await Tflite.detectObjectOnFrame(
            bytesList: imageBytes,
            model: "SSDMobileNet",
            imageHeight: img.height,
            imageWidth: img.width,
            imageMean: 0,
            imageStd: 255.0,
            numResultsPerClass: 1,
            asynch: true,
            threshold: 0.7);

        isProcessingFrame = false;
      } on PlatformException catch (e) {
        print("if Tflite still busy from previous request, continue");
        print(e);
        isProcessingFrame = false;
        return;
      }

      //isProcessingStream=false;
      print('***recognitions***' + recognitions.length.toString());
      if (recognitions.length > 0) {
        print('***MATCH***' + recognitions.length.toString());

        await processRecognitions(recognitions, img);

        if (i > 500 && spiedBox.length > 1 && imageCaptured == false) {
          if (this.cameraController.value.isStreamingImages) {
            await this.cameraController.stopImageStream();
            await this.cameraController.dispose();
          }
          var random = new Random();
          print(spiedClasses.length.toString() + ' MATCHES!');
          print(spiedClasses);
          spiedModel = spiedBox.getAt(random.nextInt(spiedClasses.length));
          //await Tflite.close();
          changeController.add(new CapturedEvent('captured'));
          return;
        }
      }
    }
    i++;
  }
}

class CapturedEvent {
  String eventData;

  CapturedEvent(this.eventData);
}
