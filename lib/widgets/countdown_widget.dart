import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ispy/blocs/challenge/challenge_bloc.dart';


  class CountdownWidget extends StatelessWidget {

   final int time;
   final Function onComplete;
  CountdownWidget(this.time,this.onComplete);



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChallengeBloc, ChallengeState>(
    listener: (context, state) {
    // do stuff here based on BlocA's state
    }, builder: (context, state) {
    return Center(
    child: CircularCountDownTimer(
    // Countdown duration in Seconds
    duration: this.time??5,

    // Width of the Countdown Widget
    width: MediaQuery.of(context).size.width / 2,

    // Height of the Countdown Widget
    height: MediaQuery.of(context).size.height / 2,

    // Default Color for Countdown Timer
    color: Colors.white,

    // Filling Color for Countdown Timer
    fillColor: Colors.red,

    // Border Thickness of the Countdown Circle
    strokeWidth: 5.0,

    // Text Style for Countdown Text
    textStyle: TextStyle(
    fontSize: 22.0,
    color: Colors.white,
    fontWeight: FontWeight.bold),

    // true for reverse countdown (max to 0), false for forward countdown (0 to max)
    isReverse: true,

    // Function which will execute when the Countdown Ends
    onComplete:onComplete,
    ),
    );
    });
  }
}