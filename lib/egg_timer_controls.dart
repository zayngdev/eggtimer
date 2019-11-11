import 'package:flutter/material.dart';
import 'package:egg_timer/egg_timer.dart';

import 'egg_timer_button.dart';

class EggTimerControls extends StatefulWidget {
  final EggTimerState eggTimerState;
  final Function() onPause;
  final Function() onResume;
  final Function() onRestart;
  final Function() onReset;



  EggTimerControls({
    this.eggTimerState,
    this.onPause,
    this.onRestart,
    this.onResume,
    this.onReset,
  });

  @override
  _EggTimerControlsState createState() => _EggTimerControlsState();
}

class _EggTimerControlsState extends State<EggTimerControls>
  with TickerProviderStateMixin  {
  AnimationController pauseResumeSliderController;
  AnimationController restartResetFadeController;

  @override
  void initState() {
    super.initState();

    pauseResumeSliderController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this
    )
    ..addListener((){
      setState(() {
      });
    });

    pauseResumeSliderController.value = 1.0;

    restartResetFadeController = AnimationController(
        duration: Duration(milliseconds: 150),
        vsync: this
    )
      ..addListener((){
        setState(() {
        });
      });
    restartResetFadeController.value = 1.0;
  }

  @override
  void dispose() {
    pauseResumeSliderController.dispose();
    restartResetFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch(widget.eggTimerState){
      case EggTimerState.ready:
        pauseResumeSliderController.forward();
        restartResetFadeController.forward();
        break;
      case EggTimerState.running:
        pauseResumeSliderController.reverse();
        restartResetFadeController.forward();
        break;
      case EggTimerState.paused:
        pauseResumeSliderController.reverse();
        restartResetFadeController.reverse();
        break;
    }


    return   Column(
        children: <Widget>[
          Opacity(
            opacity: 1.0 - restartResetFadeController.value,
            child: Row(
              children: <Widget>[
                EggTimerButton(
                  icon: Icons.refresh,
                  text: "重新开始",
                  onPressed: widget.onRestart,
                ),
                Expanded(child: Container(),),
                EggTimerButton(
                  icon: Icons.arrow_back,
                  text: "重置",
                  onPressed: widget.onReset,
                ),
              ],
            ),
          ),
          Transform(
            transform: Matrix4.translationValues(
                0.0,
                100 * pauseResumeSliderController.value,
                0.0),
            child: EggTimerButton(
              icon: (widget.eggTimerState == EggTimerState.running)
                ? Icons.pause : Icons.play_arrow,
              text: (widget.eggTimerState == EggTimerState.running)
                ? "暂停"
                : "恢复",
              onPressed: widget.eggTimerState == EggTimerState.running
                ? widget.onPause
                  : widget.onResume
            ),
          ),
        ]
    );
  }
}
