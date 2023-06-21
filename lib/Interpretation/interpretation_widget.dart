import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharedor/common_functions.dart';
import 'package:taroting/Interpretation/interpretation_controller.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_controller.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/helpers/providers.dart';
import 'package:taroting/helpers/translations.dart';
import 'package:taroting/spread/spread_controller.dart';

class InterpretationWidget extends ConsumerStatefulWidget {
  InterpretationWidget({super.key});
  String? ans;

  @override
  ConsumerState<InterpretationWidget> createState() =>
      _InterpretationWidgetState();
}

class _InterpretationWidgetState extends ConsumerState<InterpretationWidget> {
  @override
  Widget build(BuildContext context) {
    ref.watch(watchCard);
    TCard? card = TCardController().currentCard;
    InterpretationType? iType = SpreadController().currentSpread.currentType;
    widget.ans = "";

    // TCard? card = TCardController().currentCard;
    return card == null
        ? const SizedBox.shrink()
        : FutureBuilder(
            future: getAnswer(card, iType),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(children: [
                  Row(
                    children: [
                      // IconButton(
                      //     onPressed: () {
                      //       changeLanguage(context);
                      //     },
                      //     icon: Icon(Icons.language)),
                      Text(
                        "${card.name} as the ${enumToString(iType.toString())}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  widget.ans != ""
                      ? Text(widget.ans!)
                      :  Text("${"Waiting".TR}...")
                ]);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            });
  }

  getAnswer(TCard? card, InterpretationType? iType) async {
    if (card != null) {
      try {
        await InterpretationController().getAnswer(card, iType!);

        CardInterpretation? answer = InterpretationController()
            .getInterpretationFromCard(TCardController().currentCard!, iType);
        widget.ans = answer != null
            ? answer.interpretation
            : "Problem getting the interpretation";
      } catch (e) {
        widget.ans = "Problem getting the interpretation error: $e";
        // ref.read(watchAnswer.notifier).state = wans;
      }
    }
  }
}
