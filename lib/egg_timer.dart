import 'dart:async';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'main.dart';

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

      _showNotification('开始计时');

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
      Future.delayed(Duration(milliseconds: 200)).then((e) {
        _showNotification('计时结束');
      });
      reset();
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
    state = EggTimerState.ready;
    _currentTime = const Duration(seconds: 0);
    lastStartTime = _currentTime;
    stopwatch.reset();

    if(null != onTimerUpdate) {
      onTimerUpdate();
    }

  }

  _showNotification(String reminderContent) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'eggtimer',
      '蛋蛋计时器',
      '用于蛋蛋计时器发送提醒',
      importance: Importance.Max,
      priority: Priority.High,
      ongoing: true,
      autoCancel: false,
      ticker: 'ticker',
      enableLights: true,
      color: Colors.amber,
      ledColor: Colors.redAccent,
      ledOnMs: 1000,
      ledOffMs: 500,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      '计时提醒',
      reminderContent,
      platformChannelSpecifics,
    );
  }

}

enum EggTimerState {
  ready,
  running,
  paused,
}