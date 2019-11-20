import 'package:flutter/material.dart';
import 'package:egg_timer/egg_timer_knob.dart';
import 'package:fluttery_dart2/gestures.dart';

import 'egg_timer.dart';

class EggTimerDial extends StatefulWidget {
  final EggTimerState eggTimerState;
  final Duration currentTime;
  final Duration maxTime;
  final int ticksPerSection;
  final Function(Duration) onTimeSelected;
  final Function(Duration) onDialStopTurning;

  EggTimerDial({
    this.eggTimerState,
    this.currentTime = const Duration(minutes: 0),
    this.maxTime = const Duration(minutes: 35),
    this.ticksPerSection = 5,
    this.onTimeSelected,
    this.onDialStopTurning,
  });

  @override
  _EggTimerDialState createState() => _EggTimerDialState();
}

class _EggTimerDialState extends State<EggTimerDial>
    with TickerProviderStateMixin {
  static const RESET_SPEED_PERCENT_PER_SECOND = 4.0;

  EggTimerState prevEggTimerState;
  double previousRotationPercent = 0.0;
  AnimationController resetToZeroController;
  Animation resettingAnimation;

  _rotationPercent() {
    return widget.currentTime.inSeconds / widget.maxTime.inSeconds;
  }

  @override
  void initState() {
    super.initState();

    resetToZeroController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    resetToZeroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentTime.inSeconds == 0 &&
        prevEggTimerState != EggTimerState.ready) {
      resettingAnimation = Tween(begin: previousRotationPercent, end: 0)
          .animate(resetToZeroController)
            ..addListener(
                () => setState(() {})) // Every time animated redraw the widget
            ..addStatusListener((status) {
              // when the animation done, we need to notify the reset animation
              if (status == AnimationStatus.completed) {
                setState(() {
                  resettingAnimation = null;
                });
              }
            });
      resetToZeroController.duration = Duration(
        milliseconds:
            ((previousRotationPercent / RESET_SPEED_PERCENT_PER_SECOND) * 1000)
                .round(),
      );

      resetToZeroController.forward(from: 0.0);
    }
    prevEggTimerState = widget.eggTimerState;
    previousRotationPercent = _rotationPercent();

    return DialTurnGestureDector(
      currentTime: widget.currentTime,
      maxTime: widget.maxTime,
      onTimeSelected: widget.onTimeSelected,
      onDialStopTurning: widget.onDialStopTurning,
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(left: 30.0, right: 30),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              // Outer circle
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x44000000),
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                      offset: Offset(0.0, 1.0),
                    )
                  ]),

              child: Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: EdgeInsets.all(55),
                    child: CustomPaint(
                      painter: TickPainter(
                        tickCount: widget.maxTime.inMinutes,
                        ticksPerSection: widget.ticksPerSection,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(65.0),
                    child: EggTimerDialKnob(
                      rotationPercent: resettingAnimation == null
                          ? _rotationPercent()
                          : resettingAnimation.value,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DialTurnGestureDector extends StatefulWidget {
  final currentTime;
  final Duration maxTime;
  final child;

  final Function(Duration) onTimeSelected;

  final Function(Duration) onDialStopTurning;

  DialTurnGestureDector({
    this.currentTime,
    this.maxTime,
    this.child,
    this.onTimeSelected,
    this.onDialStopTurning,
  });

  @override
  _DialTurnGestureDectorState createState() => _DialTurnGestureDectorState();
}

class _DialTurnGestureDectorState extends State<DialTurnGestureDector> {
  PolarCoord startDragCoord;

  Duration startDragTime;
  Duration selectedTime;

  _onRadialDragStart(PolarCoord coord) {
    startDragCoord = coord;
    startDragTime = widget.currentTime;
  }

  _onRadialDragUpdate(PolarCoord coord) {
    if (startDragCoord != null) {

      final angleDiff = _makeAnglePositive(coord.angle
          - startDragCoord.angle);

      final anglePercent = angleDiff / (2 * 3.14);
      final timeDiffInSeconds =
          (anglePercent * widget.maxTime.inSeconds).round();
      selectedTime =
          Duration(seconds: startDragTime.inSeconds + timeDiffInSeconds);
      print('new time ${selectedTime.inMinutes}');

      widget.onTimeSelected(selectedTime);
    }
  }

  _makeAnglePositive(angle) {
    return angle >= 0.0
        ? angle
        : angle + 2 * 3.14;
  }

  onRadialDragEnd() {
    widget.onDialStopTurning(selectedTime);

    startDragCoord = null;
    startDragTime = null;
    selectedTime = null;
  }

  @override
  Widget build(BuildContext context) {
    return RadialDragGestureDetector(
      onRadialDragStart: _onRadialDragStart,
      onRadialDragUpdate: _onRadialDragUpdate,
      onRadialDragEnd: onRadialDragEnd,
      child: widget.child,
    );
  }
}

class TickPainter extends CustomPainter {
  final LONG_TICK = 14.0;
  final SHORT_TICK = 4.0;

  final tickCount;
  final ticksPerSection;
  final ticksInset;
  Paint tickPaint;
  TextPainter textPainter;
  final textStyle;

  TickPainter({
    this.tickCount = 35,
    this.ticksPerSection = 5,
    this.ticksInset = 0,
  })  : tickPaint = new Paint(),
        textPainter = TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ),
        textStyle = TextStyle(
          fontFamily: "AvenirLTStd-Black",
          color: Colors.black,
          fontSize: 15.0,
        ) {
    tickPaint.color = Colors.black;
    tickPaint.strokeWidth = 1.5;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    canvas.save();

    final radius = size.width / 2;
    for (int i = 0; i < tickCount; ++i) {
      final tickLength = i % ticksPerSection == 0 ? LONG_TICK : SHORT_TICK;

      canvas.drawLine(
          Offset(0.0, -radius), Offset(0.0, -radius - tickLength), tickPaint);

      if (i % ticksPerSection == 0) {
        // Paint text
        canvas.save();
        canvas.translate(0.0, -(size.width / 2) - 30.0);
        textPainter.text = TextSpan(
          text: '$i',
          style: textStyle,
        );

        // Layout the text
        textPainter.layout();

        // Figure out which quadrant the text is in
        final tickPercent = i / tickCount;
        var quadrant;
        if (tickPercent < 0.25) {
          quadrant = 1;
        } else if (tickPercent < 0.5) {
          quadrant = 4;
        } else if (tickPercent < 0.75) {
          quadrant = 3;
        } else {
          quadrant = 2;
        }

        switch (quadrant) {
          case 4:
            canvas.rotate(-3.14 / 2);
            break;
          case 2:
          case 3:
            canvas.rotate(3.14 / 2);
            break;
        }

        textPainter.paint(
            canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));

        canvas.restore();
      }

      canvas.rotate(2 * 3.14 / tickCount);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
