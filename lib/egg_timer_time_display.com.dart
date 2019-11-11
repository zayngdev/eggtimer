import 'package:flutter/material.dart';
import 'package:egg_timer/egg_timer.dart';
import 'package:intl/intl.dart';

class EggTimerTimeDisplay extends StatefulWidget {

  final eggTimerState;
  final Duration selectionTime;
  final countDownTime;

  EggTimerTimeDisplay({
    this.eggTimerState,
    this.countDownTime = const Duration(seconds: 0),
    this.selectionTime = const Duration(seconds: 0),
  });

  @override
  _EggTimerTimeDisplayState createState() => _EggTimerTimeDisplayState();
}

class _EggTimerTimeDisplayState extends State<EggTimerTimeDisplay>
  with TickerProviderStateMixin  {

  final DateFormat selectionTimeFormat = DateFormat('mm');
  final DateFormat countDownTimeFormat = DateFormat('mm:ss');

  AnimationController selectionTimeSlideController;
  AnimationController countDonwTimeFadeController;

  get formattedSelectionTime {
    DateTime dateTime = DateTime(DateTime.now().year, 0, 0, 0, 0,
        widget.selectionTime.inSeconds);
    return selectionTimeFormat.format(dateTime);
  }

  get formattedCountdownTime {
    DateTime dateTime = DateTime(DateTime.now().year, 0, 0, 0, 0,
        widget.countDownTime.inSeconds);
    return countDownTimeFormat.format(dateTime);
  }


  @override
  void initState() {
    super.initState();

    selectionTimeSlideController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this)
    ..addListener(() {
      setState(() {
      });
    });

    countDonwTimeFadeController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this)
      ..addListener(() {
        setState(() {
        });
      });

    countDonwTimeFadeController.value = 1.0;
  }

  @override
  void dispose() {
    selectionTimeSlideController.dispose();
    countDonwTimeFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.eggTimerState == EggTimerState.ready) {
      selectionTimeSlideController.reverse();
      countDonwTimeFadeController.forward();
    } else {
      selectionTimeSlideController.forward();
      countDonwTimeFadeController.reverse();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 35.0),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Transform(
            transform: Matrix4.translationValues(
                0.0,
                -200 * selectionTimeSlideController.value,
                0.0),
            child: Text(
              formattedSelectionTime,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 5.0
              ),
            ),
          ),

          Opacity(
            opacity: 1.0 - countDonwTimeFadeController.value,
            child: Text(
              formattedCountdownTime,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 5.0
              ),
            ),
          ),
        ]
      ),
    );
  }
}
