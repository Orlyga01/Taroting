import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharedor/common_functions.dart';
import 'package:sharedor/widgets/alerts.dart';
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
    return Column(
      children: [
        if (widget.spread.isIninitState)
          Padding(
              padding: const EdgeInsets.only(top: 150, bottom: 20),
              child: Text(
                "Select The card position in the Spread:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    TCard? card;
                    if (!full) {
                      if (widget.spread.isRandom == true) {
                        card = await TCardController().getRandomCard(
                          widget.spread.getCardIds(),
                        );
                      } else {
                        var image =
                            await _picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          CroppedFile? cropped = await ImageCropper().cropImage(
                            sourcePath: image.path,
                            maxHeight: 500,
                            maxWidth: 200,
                            aspectRatio:
                                CropAspectRatio(ratioX: 535, ratioY: 924),
                            compressQuality: 100,
                            compressFormat: ImageCompressFormat.jpg,
                          );
                          if (cropped != null)
                            card = await TCardController()
                                .identifyTCard(cropped.path);
                        }
                      }

                      if (card != null) {
                        ref.read(watchSpreadChange).updateSpread(newType, card);
                        ref.read(watchSpreadChange).getInterpretation(newType);
                      } else {
                        showAlertDialog(
                            " Sorry - the card was not found. Please take a picture again.",
                            context);
                      }
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
            })),
        CheckboxListTile(
          title: Text(
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
