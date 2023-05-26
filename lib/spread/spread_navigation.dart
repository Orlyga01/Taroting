import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharedor/common_functions.dart';
import 'package:taroting/Interpretation/interpretation_controller.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_controller.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/helpers/providers.dart';
import 'package:taroting/spread/spread_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpreadNavigation extends ConsumerStatefulWidget {
  SpreadModel spread;
  InterpretationType? iType;

  SpreadNavigation(this.spread, this.iType, {super.key});

  @override
  ConsumerState<SpreadNavigation> createState() => _SpreadNavigationState();
}

class _SpreadNavigationState extends ConsumerState<SpreadNavigation> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    // String? answer = ref.watch(watchForAnser);
    // if (answer != null && answer.length > 0) {
    //   widget.spread
    //       .setResult(widget.iType!, answer, TCardController().currentCard!);
    //   ref.read(watchSpreadChange).setSpread = widget.spread;
    // }
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(widget.spread.results!.length, (index) {
              InterpretationType newType =
                  widget.spread.results!.keys.elementAt(index);
              bool isCurrent = newType == widget.iType;
              bool full = widget.spread.results![newType]!.id.isNotEmpty;
              return ElevatedButton(
                  onPressed: () async {
                    if (isCurrent) return;
                    if (!full) {
                      TCard? card = await TCardController().getRandomCard(
                        widget.spread.getCardIds(),
                      );
                      if (card != null) {
                        ref.read(watchSpreadChange).updateSpread(newType, card);
                      }
                      ref.read(watchSpreadChange).getInterpretation(newType);
                    } else {
                      ref.read(watchSpreadChange).switchToExistingType(newType);
                    }
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isCurrent ? Colors.transparent : Colors.white,
                      elevation: isCurrent ? 0 : 4.0,
                      padding: const EdgeInsets.all(5)),
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
                        enumToString(widget.spread.results!.keys
                            .elementAt(index)
                            .toString()),
                        // .capitalize(),
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ));
            }))
      ],
    );
  }
}
