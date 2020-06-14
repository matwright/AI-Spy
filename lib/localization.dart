import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FlutterBlocLocalizations {
  FlutterBlocLocalizations(this.locale);
  final Locale locale;
  static FlutterBlocLocalizations of(BuildContext context) {
    return Localizations.of<FlutterBlocLocalizations>(
      context,
      FlutterBlocLocalizations,
    );
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Parent App',
      'welcome': 'Welcome',
      'add contact':'Add Contact'
    },
    'fr': {
      'title': 'Parent',
      'welcome': 'Bienvenue',
      'add contact':'Ajouter Contact'
    },
  };

  String  translate(String value)  {

    return _localizedValues[locale.languageCode][value]??value;
  }

}

class FlutterBlocLocalizationsDelegate
    extends LocalizationsDelegate<FlutterBlocLocalizations> {
  const FlutterBlocLocalizationsDelegate();
  @override
  Future<FlutterBlocLocalizations> load(Locale locale) =>
      SynchronousFuture<FlutterBlocLocalizations>(FlutterBlocLocalizations(locale));

  @override
  bool shouldReload(FlutterBlocLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>["en","fr"].contains(locale.languageCode.toLowerCase());

}
