import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taroting/Interpretation/interpretation_controller.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_controller.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/spread/spread_model.dart';

// final watchForAnser1 =
//     ChangeNotifierProvider.autoDispose<AnswerState1>((ref) => AnswerState1());

// class AnswerState1 extends ChangeNotifier {
//   String _answer = "loading";
//   void setNotifyCardStatusChange(String answer) {
//     _answer = answer;
//     notifyListeners();
//   }

//   String get getAnswer => _answer;
// }
final watchSpreadChange =
    ChangeNotifierProvider<SpreadNotifier>((ref) => SpreadNotifier());

class SpreadNotifier extends ChangeNotifier {
  SpreadModel _spread = SpreadModel.init;
  InterpretationType? _iType;
  bool _showCamera = false;
  set setSpread(SpreadModel spread) {
    _spread = spread;
  }

  set setType(InterpretationType iType) {
    _iType = iType;
    notifyListeners();
  }

  void updateSpread(InterpretationType iType, TCard card) {
    _iType = iType;
    _spread.results![iType] = card;
    notifyListeners();
  }

  set switchCameraOn(bool on) => _showCamera = on;
  void switchToExistingType(InterpretationType iType) {
    _iType = iType;
    TCardController().switchCurrentCard = _spread.results![iType]!;
    notifyListeners();
  }

  void getInterpretation(InterpretationType iType) async {
    await InterpretationController().getAnswer(_spread.results![iType]!, iType);
    _spread.results![iType] = TCardController().currentCard!;
    notifyListeners();
  }

  void notifyChange() => notifyListeners();

  SpreadModel get getSpread => _spread;
  InterpretationType? get getiType => _iType;
  bool get showCamera => _showCamera;
}

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

  //String _answer = "loading";
  void setNotifyCardStatusChange() {
    state = TCardController().currentCard;
  }

  set cardLoaded(TCard? card) => state = card;

  // String get getAnswer => _answer;
}

final switchInterpretationType =
    NotifierProvider<InterpretationState, InterpretationType?>(
        () => InterpretationState());

class InterpretationState extends Notifier<InterpretationType?> {
  @override
  InterpretationType? build() {
    return null;
  }

  //String _answer = "loading";
  void switchInterpretationType(InterpretationType iType) {
    state = iType;
  }

  // String get getAnswer => _answer;
}

List<CameraDescription> _cameras = [];
