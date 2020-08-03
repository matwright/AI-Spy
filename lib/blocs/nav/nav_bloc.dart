import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ispy/data/spied_model.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../blocs/nav/bloc.dart';

class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc() : super(InitialNavState());

  @override
  Stream<NavState> mapEventToState(
    NavEvent event,
  ) async* {
    if (event is NavHomeEvent) {
      yield HomeNavState();
    } else if (event is NavPlayEvent) {
      yield PlayNavState(event.player);
    } else if (event is NavGuessEvent) {
      print('START GUESSING');
      yield GuessingNavState(event.spiedModel);
    }
  }
}
