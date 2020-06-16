import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ispy/data/spied_model.dart';
import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as imglib;
import './bloc.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraBloc() {
    this.onChange.listen((e) {
      if ((e.eventData) == 'captured') {
        print('***CLSOE IT***');
        //Tflite.close();
        if(this.controller.value.isStreamingImages){
          this.controller.stopImageStream();
          this.controller.dispose();
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

 Future<List> convertYUV420toImage(CameraImage image) async {

    try {
      final int width = image.width;
      final int height = image.height;



      var img = imglib.Image(width, height); // Create Image buffer

      // Fill image buffer with plane[0] from YUV420_888
      for(int x=0; x < width; x++) {
        for(int y=0; y < height; y++) {
          final pixelColor = image.planes[0].bytes[y * width + x];
          // color: 0x FF  FF  FF  FF
          //           A   B   G   R
          // Calculate pixel color
          img.data[y * width + x] = (0xFF << 24) | (pixelColor << 16) | (pixelColor << 8) | pixelColor;
        }
      }

      imglib.PngEncoder pngEncoder = new imglib.PngEncoder(level: 0, filter: 0);
      List<int> png = pngEncoder.encodeImage(img);
      return png;
    } catch (e) {
      print("ERROR:" + e.toString());
    }
    return null;
  }



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
      FlutterTts flutterTts = FlutterTts();

      print('voices');
      await flutterTts.setSpeechRate(0.8);

     String text="Initialising neural network";
     await  flutterTts.speak(text);


      await new Future.delayed(const Duration(seconds : 3));


      String text2="Please allow me to scan our environment";
      await flutterTts.speak(text2);

      yield* _mapStartCameraEventToState();
    } else if (event is CameraStoppedEvent) {
      yield ImageCapturedState(spiedModel);
    }
  }

  Future<void> processRecognitions(List recognitions, CameraImage img) async {
    double tmpHighestRating=0.0;
    CameraImage tmpImg;
    var tmpElement;
    await  Future.forEach(recognitions,(element) async {
      print('***HIGHEST***' + element["confidenceInClass"].toString());
      if (element["confidenceInClass"] > tmpHighestRating) {
        tmpHighestRating=element["confidenceInClass"];
        tmpImg=img;
        tmpElement=element;
      }
    });

    highestRating = tmpHighestRating;
    List<dynamic> finalImage= await convertYUV420toImage(tmpImg);

    spiedModel=new SpiedModel(tmpImg, tmpElement["rect"], tmpElement['detectedClass'],finalImage,controller.value.aspectRatio);

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


    //skip first 300 frames (5 secs)
    if (i>300 && i % 60 == 0) {
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
        threshold: 0.6,
      );

      //processing=false;
      print('***recognitions***' + recognitions.length.toString());
      if (recognitions.length > 0) {
        print('***MATCH***' + recognitions.length.toString());
        await processRecognitions(recognitions, img);
        print('***imageCaptured***');
        if(imageCaptured==false){

          changeController.add(new CapturedEvent('captured'));
        }

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
