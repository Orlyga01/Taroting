import 'package:flutter/material.dart';
import 'package:sharedor/common_functions.dart';
import 'package:taroting/Interpretation/interpretation_controller.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_controller.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/helpers/global_parameters.dart';
import 'package:taroting/helpers/providers.dart';
import 'package:taroting/spread/card_in_spread.dart';
import 'package:taroting/spread/spread_controller.dart';
import 'package:taroting/spread/spread_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpreadNavigationFull extends ConsumerStatefulWidget {
  SpreadNavigationFull({super.key});

  @override
  ConsumerState<SpreadNavigationFull> createState() =>
      _SpreadNavigationFullState();
  bool showCamera = false;
}

class _SpreadNavigationFullState extends ConsumerState<SpreadNavigationFull> {
  @override
  Widget build(
    BuildContext context,
  ) {
    SpreadModel spread = SpreadController().currentSpread;
    widget.showCamera = ref.watch(watchOpenCamera);

    return widget.showCamera
        ? const SizedBox.shrink()
        : Container(
            width: double.infinity,
            height: GlobalParametersTar().screenSize.height * 0.8,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background.jpg"),
                  fit: BoxFit.cover),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: GlobalParametersTar().screenSize.width / 3.5,
                ),
                Center(
                    child:
                        CardInSpreadWidget(iType: InterpretationType.subject)),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CardInSpreadWidget(iType: InterpretationType.past),
                    CardInSpreadWidget(iType: InterpretationType.present),
                    CardInSpreadWidget(iType: InterpretationType.future),
                  ],
                )
              ],
            ));
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
