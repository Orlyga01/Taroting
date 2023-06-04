import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharedor/common_functions.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/helpers/providers.dart';

class InterpretationWidget extends StatelessWidget {
  TCard? card;
  InterpretationType? iType;
  InterpretationWidget({
    this.card,
    this.iType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TCard? card = TCardController().currentCard;
    return card == null || iType == null
        ? const SizedBox.shrink()
        : Consumer(builder: (mcontext, WidgetRef ref, child) {
            String answer = ref.watch(watchAnswer);
            return Column(children: [
              Text(
                "${card!.name} as the ${enumToString(iType.toString())}",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              answer != "" ? Text(answer) : const Text("waiting...")
            ]);
          });
  }
}
