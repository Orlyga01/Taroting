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

class SpreadNavigation extends StatelessWidget {
  InterpretationType iType;
  SpreadModel spread;
  SpreadNavigation(this.spread, this.iType, {super.key});
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(spread.results!.length, (index) {
              bool isCurrent = spread.results!.keys.elementAt(index) == iType;
              bool full = spread
                  .results![spread.results!.keys.elementAt(index)]!
                  .card
                  .id
                  .isNotEmpty;
              return ElevatedButton(
                  onPressed: () async {
                    if (isCurrent) return;
                    if (!full) {
                      //If we dont have the answer yet

                      var image =
                          await _picker.pickImage(source: ImageSource.camera);
                      TCard? card =
                          await TCardController().identifyTCard(image);
                      if (card != null) {
                        InterpretationController().getAnswer(
                            card, spread.results!.keys.elementAt(index));
                      }
                    }
                    final container = ProviderContainer();

                    container
                        .read(switchInterpretationType.notifier)
                        .switchInterpretationType(iType);
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
                        enumToString(
                            spread.results!.keys.elementAt(index).toString()),
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
