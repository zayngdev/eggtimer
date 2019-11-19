import 'dart:async';
import 'package:audioplayers/audio_cache.dart';

class EggTimer{

  final Duration maxTime;
  final Function onTimerUpdate;
  final Stopwatch stopwatch = Stopwatch();
  Duration _currentTime = Duration(seconds: 0);
  Duration lastStartTime = const Duration(seconds: 0);
  EggTimerState state = EggTimerState.ready;


  var player = new AudioCache();


  EggTimer({
    this.maxTime,
    this.onTimerUpdate,
  });

  get currentTime {
    return _currentTime;
  }

  set currentTime(newTime) {
    if(state == EggTimerState.ready) {
      lastStartTime = currentTime;
      _currentTime = newTime;
    }
  }

  resume() {
    if( state != EggTimerState.running) {
      if( state == EggTimerState.ready) {
        _currentTime = _roundToTheNearestMinute(_currentTime);
        lastStartTime = _currentTime;
      }

      state = EggTimerState.running;
      stopwatch.start();

      _tick();
    }
  }

  _roundToTheNearestMinute(Duration duration){
    return new Duration(
      minutes: (duration.inSeconds / 60).round()
    );
  }

  pause() {
    if(state == EggTimerState.running){
      state = EggTimerState.paused;

      stopwatch.stop();

      if(null != onTimerUpdate) {
        onTimerUpdate();
      }
    }
  }

  _tick() {
    print('Current time: ${_currentTime.inSeconds}');
    _currentTime = lastStartTime - stopwatch.elapsed;

    if(_currentTime.inSeconds > 0) {
      if (_currentTime.inSeconds <= 3 && _currentTime.inSeconds >= 1) {
        player.play('pip.mp3');
      }
      Timer(const Duration(seconds: 1), _tick);

    } else {

      state = EggTimerState.ready;
      player.play('boop.mp3');

    }

    if(null != onTimerUpdate) {
      onTimerUpdate();
    }
  }

  restart() {
    if(state == EggTimerState.paused) {
      state = EggTimerState.running;
      _currentTime = lastStartTime;
      stopwatch.reset();
      stopwatch.start();

      _tick();
    }
  }

  reset() {
    if(state == EggTimerState.paused){
      state = EggTimerState.ready;
      _currentTime = const Duration(seconds: 0);
      lastStartTime = _currentTime;
      stopwatch.reset();

      if(null != onTimerUpdate) {
        onTimerUpdate();
      }
    }
  }

}

enum EggTimerState {
  ready,
  running,
  paused,
}