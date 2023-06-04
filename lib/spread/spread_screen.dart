import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/Interpretation/interpretation_widget.dart';
import 'package:taroting/card/camera.dart';
import 'package:taroting/card/card_controller.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/card/card_widget.dart';
import 'package:taroting/helpers/providers.dart';
import 'package:taroting/spread/spread_controller.dart';
import 'package:taroting/spread/spread_model.dart';
import 'package:taroting/spread/spread_navigation.dart';

class SpreadScreen extends StatelessWidget {
  SpreadScreen({super.key});
  SpreadModel spread = SpreadModel.init..isRandom = true;

  InterpretationType? iType;
  bool showCamera = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (consumercontext, WidgetRef ref, child) {
      final card = ref.watch(watchCard);
      iType = SpreadController().iType;
      showCamera = ref.watch(watchOpenCamera);

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
    });
  }

  List<Widget> getListWidgets() {
    return showCamera
        ? [CaptureCameraWidget()]
        : [
            SpreadNavigation(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Container(
                  width: double.infinity,
                  height: 160, // Adjust the height according to your image size
                  child: CardWidget(card: spread.results![iType])),
            ),
            InterpretationWidget(
              card: spread.results![iType],
              iType: iType,
            )
          ];
  }
}
