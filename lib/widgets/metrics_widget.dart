import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ispy/blocs/sensors/sensors_bloc.dart';
import 'package:ispy/widgets/spinner_widget.dart';

class MetricsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SensorsBloc, SensorsState>(

        builder: (context, state) {
          print(state);
          if(state is SensorsStartedState){

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround ,
              children: [

                Text('acc: '+state.accelerometer.values.toList().join(','),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.lightBlueAccent.withOpacity(0.3),
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Digital"
                  )),
                Text('gyro: '+state.gyroscope.values.toList().join(','),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.lightBlueAccent.withOpacity(0.3),
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Digital"
                    )),

                Text('usr acc: '+state.userAccelerometer.values.toList().join(','),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.lightBlueAccent.withOpacity(0.3),
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Digital"
                    )),

              ],
            );


          }else{
            return Text('Initializing');
          }
        }
    );
  }
}
