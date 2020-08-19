import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ispy/blocs/search/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sensors/sensors.dart';

part 'sensors_event.dart';

part 'sensors_state.dart';


class SensorsBloc extends Bloc<SensorsEvent, SensorsState> {

  SearchBloc searchBloc;
  double maxMovement=0;
  SensorsBloc(this.searchBloc) : super(InitialSensorsState()){
    searchBloc.listen((state) {
      if(state is SearchClueState){
        print('close sensors');
        started=false;
        gyroscopeListener.cancel();
        userAccelerometerListener.cancel();
        accelerometerListener.cancel();
      }
    });
  }
  Map accelerometer={
    'x':0.0,
    'y':0.0,
    'z':0.0
  };
  Map userAccelerometer={
    'x':0.0,
    'y':0.0,
    'z':0.0
  };
  Map gyroscope={
    'x':0.0,
    'y':0.0,
    'z':0.0
  };

  StreamSubscription accelerometerListener;
  StreamSubscription userAccelerometerListener;
  StreamSubscription gyroscopeListener;

  bool started=false;


  @override
  Stream<SensorsState> mapEventToState(SensorsEvent event) async* {
    print(event);
    if(event is StartSensorsEvent){



      if(started==false) {
        started=true;
        accelerometerListener =
            accelerometerEvents.listen((AccelerometerEvent event) {



              accelerometer = {
                'x': event.x.toStringAsFixed(2),
                'y': event.y.toStringAsFixed(2),
                'z': event.z.toStringAsFixed(2),
              };
            });
        userAccelerometerListener =
            userAccelerometerEvents.listen((UserAccelerometerEvent event) {
              double absSum=event.x.abs()+event.y.abs()+event.z.abs();

              if(absSum>maxMovement){
                maxMovement=absSum;
              }
              userAccelerometer = {
                'x': event.x.toStringAsFixed(2),
                'y': event.y.toStringAsFixed(2),
                'z': event.z.toStringAsFixed(2),
              };
            });
        gyroscopeListener = gyroscopeEvents.listen((GyroscopeEvent event) {
          gyroscope = {
            'x': event.x.toStringAsFixed(2),
            'y': event.y.toStringAsFixed(2),
            'z': event.z.toStringAsFixed(2),
          };
        });


      }
      yield* _mapStartSensorsEventToState(event);
    }else if(event is StopSensorsEvent){
      print('stopping sensors');
      started=false;
      gyroscopeListener.cancel();
      userAccelerometerListener.cancel();
      accelerometerListener.cancel();
    }
  }

  Stream<SensorsState> _mapStartSensorsEventToState(StartSensorsEvent event) async* {
    yield SensorsStartedState(
        accelerometer, userAccelerometer, gyroscope);
    int i=0;
    while (started == true) {
      print('yielding');

      i++;
print('max: '+maxMovement.toString());
      if(i%100==0){
        if(maxMovement<1){
          print('MOVE ABOUT!!!!');
          FlutterTts flutterTts = FlutterTts();
          String text2 = "Come on, move around a bit.";
          await flutterTts.speak(text2);
        }
        maxMovement=0;
      }
      await new Future.delayed(const Duration(milliseconds: 100));

      yield SensorsStartedState(
          accelerometer, userAccelerometer, gyroscope);
    }
  }



}
