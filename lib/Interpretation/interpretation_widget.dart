import 'package:flutter/material.dart';
import 'package:sharedor/common_functions.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/spread/spread_model.dart';

class InterpretationWidget extends StatelessWidget {
  TCard card;
  InterpretationType iType;
  InterpretationWidget(this.card, this.iType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        "${card.name} as the ${enumToString(iType.toString())}",
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      Text(card.interpretations[iType]!.interpretation)
    ]);
  }
}
