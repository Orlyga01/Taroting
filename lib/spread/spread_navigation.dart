import 'package:flutter/material.dart';
import 'package:sharedor/common_functions.dart';
import 'package:taroting/Interpretation/interpretation_controller.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_controller.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/helpers/providers.dart';
import 'package:taroting/helpers/translations.dart';
import 'package:taroting/spread/spread_controller.dart';
import 'package:taroting/spread/spread_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpreadNavigation extends ConsumerStatefulWidget {
  SpreadNavigation({super.key});

  @override
  ConsumerState<SpreadNavigation> createState() => _SpreadNavigationState();
  bool showCamera = false;
}

class _SpreadNavigationState extends ConsumerState<SpreadNavigation> {
  @override
  Widget build(
    BuildContext context,
  ) {
    SpreadModel spread = SpreadController().currentSpread;
    widget.showCamera = ref.watch(watchOpenCamera);

    return widget.showCamera
        ? const SizedBox.shrink()
        : Column(children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(spread.results!.length, (index) {
                  InterpretationType newType =
                      spread.results!.keys.elementAt(index);
                  bool isCurrent =
                      newType == spread.currentType && !spread.isIninitState;
                  bool full = spread.results![newType]!.id.isNotEmpty;
                  return ElevatedButton(
                      onPressed: () async {
                        bool isinnerCurrent = newType == spread.currentType &&
                            !spread.isIninitState;
                        if (isinnerCurrent) return;

                        TCard? cr = await SpreadController()
                            .loadCard(iType: newType, ref: ref);
                        if (spread.isRandom != true && cr == null) {
                          //if there is no card yet and its not random then we need to show the camera
                          ref.read(watchOpenCamera.notifier).setCameraState =
                              true;
                        }
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isCurrent ? Colors.transparent : Colors.white,
                          elevation: isCurrent ? 0 : 4.0,
                          padding: EdgeInsets.symmetric(
                              vertical: 5, horizontal: full ? 10 : 20)),
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
                            enumToString(spread.results!.keys
                                    .elementAt(index)
                                    .toString())
                                .TR,
                            // .capitalize(),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 11),
                          ),
                        ],
                      ));
                })),
          ]);
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
          value: widget.isRandom ?? false,
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
