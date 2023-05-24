import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';

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

final watchForAnser =
    NotifierProvider<AnswerState, String>(() => AnswerState());

class AnswerState extends Notifier<String> {
  @override
  String build() {
    return "loading";
  }

  //String _answer = "loading";
  void setNotifyCardStatusChange(String answer) {
    state = answer;
  }

  // String get getAnswer => _answer;
}

final switchInterpretationType =
    NotifierProvider<InterpretationState, InterpretationType>(
        () => InterpretationState());

class InterpretationState extends Notifier<InterpretationType> {
  @override
  InterpretationType build() {
    return InterpretationType.subject;
  }

  //String _answer = "loading";
  void switchInterpretationType(InterpretationType iType) {
    state = iType;
  }

  // String get getAnswer => _answer;
}
