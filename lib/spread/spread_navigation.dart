import 'package:flutter/material.dart';
import 'package:sharedor/common_functions.dart';
import 'package:taroting/Interpretation/interpretation_controller.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_controller.dart';
import 'package:taroting/helpers/providers.dart';
import 'package:taroting/spread/spread_controller.dart';
import 'package:taroting/spread/spread_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpreadNavigation extends StatelessWidget {
  SpreadNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    // widget.spread = ref.watch(watchSpreadChange).getSpread;

    //iType = widget.spread.currentType;
    return Consumer(builder: (context, WidgetRef ref, child) {
      ref.watch(watchSpread);
      SpreadModel spread = SpreadController().currentSpread;
      return Column(
        children: [
          if (spread.isIninitState)
            const Padding(
                padding: EdgeInsets.only(top: 150, bottom: 40),
                child: Text(
                  "Position in the Spread:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(spread.results!.length, (index) {
                InterpretationType newType =
                    spread.results!.keys.elementAt(index);
                bool isCurrent = newType == spread.currentType;
                bool full = spread.results![newType]!.id.isNotEmpty;
                return ElevatedButton(
                    onPressed: () async {
                      if (isCurrent) return;

                      if (!full) {
                        SpreadController().currentSpread.currentType = newType;
                        if (spread.isRandom != false) {
                          loadCard(ref);

                          //      ref.read(watchSpread.notifier).spreadUpdate = spread;
                        } else {
                          ref.read(watchOpenCamera.notifier).setCameraState =
                              true;
                        }
                      } else {
                        SpreadController().setCurrentType = newType;
                        loadCard(ref);
                      }
                      //    ref.read(watchSpreadChange).switchToExistingType(newType);
                      // }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isCurrent ? Colors.transparent : Colors.white,
                        elevation: isCurrent ? 0 : 4.0,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 8)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        full && !isCurrent
                            ? const Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Icon(Icons.check,
                                    color: Colors.green, size: 20),
                              )
                            : const SizedBox.shrink(),
                        Text(
                          enumToString(
                              spread.results!.keys.elementAt(index).toString()),
                          // .capitalize(),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ));
              })),
          Wrap(
            spacing: 10.0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Select a random card',
              ),
              SwitchTR(
                isRandom: spread.isRandom ?? true,
                onChange: (bool? value) {
                  spread.isRandom = value;
                },
              ),
            ],
          ),
        ],
      );
    });
  }

  loadCard(WidgetRef ref) async {
    await SpreadController().loadCard(isRandom: true);
    ref.read(watchCard.notifier).cardLoaded = TCardController().currentCard;
    if (TCardController().currentCard != null) {
      String ans;
      try {
        await InterpretationController().getAnswer(
            TCardController().currentCard!,
            SpreadController().currentSpread.currentType!);
        CardInterpretation? answer = InterpretationController()
            .getInterpretationFromCard(TCardController().currentCard!,
                SpreadController().currentSpread.currentType!);
        ans = answer != null
            ? answer.interpretation
            : "Problem getting the interpretation";
        ref.read(watchAnswer.notifier).state = ans;
      } catch (e) {
        ans = "Problem getting the interpretation";
        ref.read(watchAnswer.notifier).state = ans;
      }
    }
  }
}

class SwitchTR extends StatefulWidget {
  Function(bool val) onChange;
  bool? isRandom;
  SwitchTR({this.isRandom, required this.onChange, super.key});

  @override
  State<SwitchTR> createState() => _SwitchTRState();
}

class _SwitchTRState extends State<SwitchTR> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text(
          'Select a random card',
        ),
        Switch(
          value: widget.isRandom ?? true,
          onChanged: (bool value) {
            widget.onChange(value);
            setState(() {
              widget.isRandom = value;
            });
          },
        ),
      ],
    );
  }
}
