import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:ispy/bloc_delegate.dart';
import 'package:ispy/blocs/camera/bloc.dart';
import 'package:ispy/blocs/search/search_bloc.dart';
import 'package:ispy/blocs/search/search_state.dart';
import 'package:ispy/blocs/nav/bloc.dart';
import 'package:ispy/data/spied_model.dart';
import 'package:ispy/home_screen.dart';
import 'package:ispy/dark-theme.dart';


void main() {
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    print(notification.audioId);
    return true;
  });

  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocDelegate();
  Hive.registerAdapter(SpiedModelAdapter());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      BlocProvider(
        //AI is default player
        create: (context) => SearchBloc(CameraBloc(), SearchState.PLAYER_AI),
        child: App(),
      ),
    );
  });

}

class App extends StatelessWidget {
  App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),

        theme: darkTheme,
        locale: Locale('en'),
        onGenerateTitle: (BuildContext context) => 'welcome',
        supportedLocales: [
          const Locale('en'), // English
          const Locale('fr'), // French
          // ... other locales the app supports
        ],
        home: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            return BlocProvider(
                create: (context) => NavBloc(),
                child: HomeScreen(name: 'friend'));
          },
        ));
  }
}
