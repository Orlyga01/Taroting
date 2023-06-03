import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharedor/common_functions.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_controller.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/helpers/providers.dart';
import 'package:taroting/spread/spread_controller.dart';
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
    // widget.spread = ref.watch(watchSpreadChange).getSpread;
    widget.iType = ref.watch(watchSpreadChange).getiType;
    widget.spread = SpreadController().currentSpread;
    return Column(
      children: [
        if (widget.spread.isIninitState)
          const Padding(
              padding: EdgeInsets.only(top: 150, bottom: 40),
              child: Text(
                "Position in the Spread:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
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
                      if (widget.spread.isRandom != false) {
                        TCard? card = await TCardController().getRandomCard(
                          widget.spread.getCardIds(),
                        );
                        ref.read(watchCard.notifier).cardLoaded = card;
                      } else {
                        ref.read(watchSpreadChange).switchCameraOn = true;
                      }
                    }
                    ref.read(watchSpreadChange).switchToExistingType(newType);
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
                        enumToString(widget.spread.results!.keys
                            .elementAt(index)
                            .toString()),
                        // .capitalize(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ));
            })),
        CheckboxListTile(
          title: const Text(
            'Select a random card',
          ),
          value: widget.spread.isRandom ?? true,
          onChanged: (bool? value) {
            widget.spread.isRandom = value ?? false;
            setState(() {});
          },
        ),
      ],
    );
  }
}
