import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:ispy/data/spied_model.dart';
import 'package:tflite/tflite.dart';

import './bloc.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc() {
    this.onChange.listen((e) {
      if ((e.eventData) == 'captured') {
        print('***CLSOE IT***');
        //Tflite.close();
        if(this.controller.value.isStreamingImages){
          this.controller.stopImageStream();
          //this.controller.dispose();
        }
        this.imageCaptured = true;
        this.add(CameraStoppedEvent());
      }
    });
  }

  var changeController = new StreamController<CapturedEvent>();

  Stream<CapturedEvent> get onChange => changeController.stream;
  CameraState get initialState => InitialCameraState();
  List<CameraDescription> cameras;
  CameraController controller;
  bool processing = false;
  bool model = false;
  double highestRating = 0;
  bool imageCaptured = false;
  int i = 0;
  SpiedModel spiedModel;

  @override
  Stream<CameraState> mapEventToState(
    CameraEvent event,
  ) async* {
    if (!model) {
      model = true;
      await Tflite.loadModel(
          model: "assets/yolov2_tiny.tflite",
          labels: "assets/yolov2_tiny.txt",
          numThreads: 1, // defaults to 1
          isAsset:
              true // defaults to true, set to false to load resources outside assets
          );
    }
    if (event is StartCameraEvent) {
      yield* _mapStartCameraEventToState();
    } else if (event is CameraStoppedEvent) {
      yield ImageCapturedState(spiedModel);
    }
  }

  Future<void> processRecognitions(List recognitions, CameraImage img) async {
    double tmpHighestRating=0.0;
    CameraImage tmpImg;
    var tmpElement;
    recognitions.forEach((element) {
      print('***HIGHEST***' + element["confidenceInClass"].toString());
      if (element["confidenceInClass"] > tmpHighestRating) {
        tmpHighestRating=element["confidenceInClass"];
        tmpImg=img;
        tmpElement=element;
      }
    });

    highestRating = tmpHighestRating;
    spiedModel=new SpiedModel(tmpImg, tmpElement["rect"], tmpElement['detectedClass']);
    return;
  }

  Stream<CameraState> _mapStartCameraEventToState() async* {
    print('***PROCESSING***' + processing.toString());
    if (processing == false) {
      //controller == null || !controller.value.isInitialized
      processing = true;
      cameras = await availableCameras();
      controller = CameraController(cameras[0], ResolutionPreset.high,
          enableAudio: false);
      await controller.initialize();
      print('***START STREAM***');
      await controller.startImageStream(processImage);
    }
    yield CameraStartedState(controller);
  }

  processImage(CameraImage img) async {
    if (this.imageCaptured == true) {
      return;
    }
    if (i % 60 == 0) {
      print('***LIST REC***');
      List recognitions = [];
      recognitions = await Tflite.detectObjectOnFrame(
        bytesList: img.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        model: "YOLO",
        imageHeight: img.height,
        imageWidth: img.width,
        imageMean: 0,
        imageStd: 255.0,
        numResultsPerClass: 1,
        threshold: 0.5,
      );

      //processing=false;
      print('***recognitions***' + recognitions.length.toString());
      if (recognitions.length > 0) {
        print('***MATCH***' + recognitions.length.toString());
        await processRecognitions(recognitions, img);
        print('***imageCaptured***');
        changeController.add(new CapturedEvent('captured'));
        imageCaptured = true;
        return;
      }
    }
    i++;
  }
}

class CapturedEvent {
  String eventData;

  CapturedEvent(this.eventData);
}
