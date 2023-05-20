import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final watchForAnser =
    ChangeNotifierProvider.autoDispose<AnswerState>((ref) => AnswerState());

class AnswerState extends ChangeNotifier {
  String _answer = "loading";
  void setNotifyCardStatusChange(String answer) {
    _answer = answer;
    notifyListeners();
  }

  String get getAnswer => _answer;
}
