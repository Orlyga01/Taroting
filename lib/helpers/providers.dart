import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taroting/Interpretation/interpretation_controller.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_controller.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/spread/spread_controller.dart';
import 'package:taroting/spread/spread_model.dart';

// final watchSpread =
//     NotifierProvider<SpreadState, SpreadModel?>(() => SpreadState());

// class SpreadState extends Notifier<SpreadModel?> {
//   @override
//   SpreadModel? build() {
//     SpreadModel.init;
//   }

//   void set spreadUpdate(SpreadModel spread) =>
//       state = SpreadController().currentSpread;
//   // String get getAnswer => _answer;
// }

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

  // String get getAnswer => _answer;
}

final watchCard = NotifierProvider<CardState, TCard?>(() => CardState());

class CardState extends Notifier<TCard?> {
  @override
  TCard? build() {
    return null;
  }

  set cardLoaded(TCard? card) => state = card;
  // String get getAnswer => _answer;
}

final watchOpenCamera =
    NotifierProvider<CameraState, bool>(() => CameraState());

class CameraState extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  set setCameraState(bool on) => state = on;
  // String get getAnswer => _answer;
}

final watchAnswer = StateProvider<String>((ref) => "");

List<CameraDescription> _cameras = [];
