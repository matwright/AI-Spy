import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ispy/bloc_delegate.dart';
import 'package:ispy/blocs/camera/bloc.dart';
import 'package:ispy/blocs/search/search_bloc.dart';
import 'package:ispy/blocs/search/search_state.dart';
import 'package:ispy/blocs/nav/bloc.dart';
import 'package:ispy/home_screen.dart';
import 'package:ispy/localization.dart';
import 'package:ispy/theme.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocDelegate();
  runApp(
    BlocProvider(
      create: (context) => SearchBloc(CameraBloc())
  ,
      child: App(),
    ),
  );
}
class App extends StatelessWidget {


  App({Key key})
      :
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        themeMode: ThemeMode.light,
        theme: theme,
        locale: Locale('en'),
        onGenerateTitle: (BuildContext context) =>'welcome',

        supportedLocales: [
          const Locale('en'), // English
          const Locale('fr'), // French
          // ... other locales the app supports
        ],
        home: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            return BlocProvider(create: (context)=>NavBloc(),child: HomeScreen(name:'friend'));
          },

        )
    );
  }
}


