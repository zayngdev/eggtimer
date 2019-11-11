import 'package:flutter/material.dart';
import 'package:egg_timer/egg_timer_controls.dart';
import 'package:egg_timer/egg_timer_dial.dart';
import 'package:egg_timer/egg_timer_time_display.com.dart';

import 'egg_timer.dart';
import 'egg_timer_knob.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  EggTimer eggTimer;

  _MyHomePageState() {
    eggTimer = EggTimer(
      maxTime: const Duration(minutes: 35),
      onTimerUpdate: _onTimerUpdate,
    );
  }

  _onTimeSelected(Duration newTime) {
    setState(() {
      eggTimer.currentTime = newTime;
    });
  }

  _onDialStopTurning(Duration newTime) {
    setState(() {
      eggTimer.currentTime = newTime;
      eggTimer.resume();
    });
  }

  _onTimerUpdate() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
        )),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top:30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                EggTimerTimeDisplay(
                  eggTimerState: eggTimer.state,
                  selectionTime: eggTimer.lastStartTime,
                  countDownTime: eggTimer.currentTime,
                ),
                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: EggTimerDial(
                    eggTimerState: eggTimer.state,
                    currentTime: eggTimer.currentTime,
                    maxTime: eggTimer.maxTime,
                    ticksPerSection: 5,
                    onTimeSelected: _onTimeSelected,
                    onDialStopTurning: _onDialStopTurning
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                EggTimerControls(
                  eggTimerState: eggTimer.state,
                  onPause: () {
                    setState(() {
                      eggTimer.pause();
                    });
                  },
                  onResume: () {
                    setState(() {
                      eggTimer.resume();
                    });
                  },
                  onRestart: (){
                    setState(() {
                      eggTimer.restart();
                    });
                  },
                  onReset: () {
                    setState(() {
                      eggTimer.reset();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
