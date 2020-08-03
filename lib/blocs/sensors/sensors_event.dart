part of 'sensors_bloc.dart';

@immutable
abstract class SensorsEvent {}

class StartSensorsEvent extends SensorsEvent{
  StartSensorsEvent();
}

class StopSensorsEvent extends SensorsEvent{
  StopSensorsEvent();
}


