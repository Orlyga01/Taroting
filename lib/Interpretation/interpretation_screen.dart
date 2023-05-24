import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharedor/common_functions.dart';
import 'package:taroting/Interpretation/interpretation_controller.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/Interpretation/interpretation_widget.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/card/card_widget.dart';
import 'package:taroting/helpers/providers.dart';
import 'package:taroting/spread/spread_model.dart';
import 'package:taroting/spread/spread_navigation.dart';
import 'package:taroting/spread/spread_widget.dart';

class InterpretationScreen extends StatelessWidget {
  InterpretationScreen({super.key, required this.card});

  TCard card;
  InterpretationType iType = InterpretationType.subject;
  SpreadModel spread = SpreadModel.init;
  @override
  Widget build(BuildContext context) {
    List<Widget> children = getListWidgets();
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: children.length,
                itemBuilder: (context, index) {
                  return children[index];
                })));
  }

  List<Widget> getListWidgets() {
    return [
      Consumer(builder: (context, WidgetRef ref, child) {
        ref.watch(watchForAnser);
        String? answer = InterpretationController().answer;
        if (answer != null) {
          spread.setResult(iType, answer, card);
          spread.setResult(InterpretationType.future, answer, card);
        }
        return SpreadNavigation(spread, iType);
      }),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Container(
            width: double.infinity,
            height: 120, // Adjust the height according to your image size
            child: CardWidget(card: card)),
      ),
      Consumer(builder: (context, WidgetRef ref, child) {
        ref.watch(watchForAnser);
        String? answer = InterpretationController().answer;
        if (answer != null) {
          iType = InterpretationController().iType;
        }
        return answer != null
            ? InterpretationWidget(card, iType)
            : const SizedBox.shrink();
      })
    ];
  }
}
