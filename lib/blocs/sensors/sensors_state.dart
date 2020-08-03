part of 'sensors_bloc.dart';

@immutable
abstract class SensorsState extends Equatable {
  const SensorsState();
}

class InitialSensorsState extends SensorsState {
  @override
  List<Object> get props => [];
}

class SensorsStartedState extends SensorsState {

  final  Map accelerometer;
  final  Map userAccelerometer;
  final  Map gyroscope;
  const SensorsStartedState(this.accelerometer,this.userAccelerometer,this.gyroscope);

  @override
  List<Object> get props => [
    accelerometer,userAccelerometer,gyroscope
  ];
}

class SensorsStoppedState extends SensorsState {
  @override
  List<Object> get props => [];
}