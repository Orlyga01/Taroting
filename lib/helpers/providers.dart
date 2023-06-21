import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taroting/Interpretation/interpretation_controller.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_controller.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/spread/spread_controller.dart';
import 'package:taroting/spread/spread_model.dart';

final watchForAnser =
    NotifierProvider<AnswerState, String?>(() => AnswerState());

class AnswerState extends Notifier<String?> {
  @override
  String? build() {
    null;
  }

  //String _answer = "loading";
  void setNotifyCardStatusChange(String answer) {
    state = answer;
  }
}

final watchCard = NotifierProvider<CardState, TCard?>(() => CardState());

class CardState extends Notifier<TCard?> {
  @override
  TCard? build() {
    return null;
  }

  set cardLoaded(TCard? card) => state = card;
}

final watchRandom = NotifierProvider<RandomState, bool>(() => RandomState());

class RandomState extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  set processRandom(bool on) => state = on;
}
final watchRefresh = NotifierProvider<RefreshState, bool>(() => RefreshState());

class RefreshState extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  set doRefresh(bool on) => state = on;
}
final watchOpenCamera =
    NotifierProvider<CameraState, bool>(() => CameraState());

class CameraState extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  set setCameraState(bool on) => state = on;
}

final watchAnswer = StateProvider<String>((ref) => "");

List<CameraDescription> _cameras = [];

final watchSpreadFullView =
    NotifierProvider<FullViewStateState, bool>(() => FullViewStateState());

class FullViewStateState extends Notifier<bool> {
  @override
  bool build() {
    return true;
  }

  set setFullViewState(bool on) => state = on;
}
