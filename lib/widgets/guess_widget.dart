import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ispy/blocs/guess/bloc.dart';
import 'package:ispy/blocs/nav/bloc.dart';
import 'package:ispy/blocs/search/bloc.dart';
import 'package:ispy/guess_screen.dart';
import 'package:ispy/widgets/button_widget.dart';
import 'package:ispy/widgets/clue_widget.dart';
import 'package:ispy/widgets/spinner_widget.dart';

class GuessWidget extends StatefulWidget {
  final String label;
  final Function onClick;
  GuessWidget({this.label,this.onClick,Key key}) : super(key: key);

  @override
  _GuessWidgetState createState() => _GuessWidgetState(label,onClick);
}

class _GuessWidgetState extends State<GuessWidget> with TickerProviderStateMixin {
  String label;
  Function onClick;
  _GuessWidgetState(this.label,this.onClick);

  @override
  Widget build(BuildContext context) {
    ParticleOptions particleOptions = ParticleOptions(
      image: Image.asset('assets/star.png'),
      spawnOpacity: 0.0,
      opacityChangeRate: 0.5,
      minOpacity: 0.1,
      maxOpacity: 0.5,
      spawnMinSpeed: 10.0,
      spawnMaxSpeed: 100.0,
      spawnMinRadius: 1.0,
      spawnMaxRadius: 200.0,
      particleCount: 150,
      baseColor: Colors.blueAccent
    );

    var particlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    return AnimatedBackground(
      behaviour: RandomParticleBehaviour(
          options:particleOptions,
      paint: particlePaint),
      vsync: this,
      child: BlocBuilder<GuessBloc, GuessState>(
          builder: (context, state) {
            if(state is StartGuessState){

              return

                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Center(child: TriesWidget(state.numTries)),
                    ClueWidget(state.spiedModel.word),
                    ButtonWidget(MaterialCommunityIcons.microphone_outline,label,onClick,backgroundColor: Colors.black54,)


                  ],
                );
            }else if(state is VoiceProcessedState){
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Center(child: TriesWidget(state.numTries)),
                  ClueWidget(state.spiedModel.word),
                  ButtonWidget(MaterialCommunityIcons.microphone_outline,label, onClick,backgroundColor: Colors.black54,)
                  ,
                  (state.guessWord==null?Container():RichText(
                    text: TextSpan(
                      text: 'You answered : ',
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                            text: state.guessWord,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ))

                ],
              );
            }

            return Container();

          }
      ),
    )

    ;
  }
}