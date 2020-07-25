import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ispy/data/spied_model.dart';


abstract class NavState extends Equatable {
  NavState();
  IconData _iconData;
  String _name;
  IconData get iconData => _iconData;
  String get name => _name;
}

//{ home, register, kids,kid_form,device_contacts,contacts }
class InitialNavState extends NavState {
  @override
  List<Object> get props => [];

  final String _name = null;
  final IconData _iconData = null;
}

class HomeNavState extends NavState {
  @override
  List<Object> get props => [];
  final String _name = 'Home';
  final IconData _iconData = null;
}

class PlayNavState extends NavState {
  PlayNavState(this.player);
  @override
  List<Object> get props => [];
  final String _name = 'Play';
  final IconData _iconData = null;
  final String player;
}

class GuessingNavState extends NavState {
  @override
  List<Object> get props => [];
  final String _name = 'Play';
  final IconData _iconData = null;
  SpiedModel spiedModel;
  GuessingNavState(this.spiedModel);
}


