import 'package:flutter/material.dart';
import 'package:sharedor/common_functions.dart';
import 'package:taroting/Interpretation/interpretation_controller.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_controller.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/helpers/global_parameters.dart';
import 'package:taroting/helpers/providers.dart';
import 'package:taroting/helpers/translations.dart';
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
    widget.showCamera = ref.watch(watchOpenCamera);
    SpreadModel spread = SpreadController().currentSpread;
    List<Widget> children = getListWidgets(context);

    return widget.showCamera
        ? const SizedBox.shrink()
        : SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: children.length,
                itemBuilder: (context, index) {
                  return children[index];
                }),
          );
  }

  List<Widget> getListWidgets(context) {
    List<Widget> list;
    SpreadModel spread = SpreadController().currentSpread;
    double screenHeight = GlobalParametersTar().screenSize.height * 0.8;
    list = [
      Container(
          width: double.infinity,
          height: screenHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.1,
              ),
              Center(
                  child: CardInSpreadWidget(
                      iType: InterpretationType.subject,
                      card: spread.results?[InterpretationType.subject])),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CardInSpreadWidget(
                      iType: InterpretationType.past,
                      card: spread.results?[InterpretationType.past]),
                  CardInSpreadWidget(
                      iType: InterpretationType.present,
                      card: spread.results?[InterpretationType.present]),
                  CardInSpreadWidget(
                      iType: InterpretationType.future,
                      card: spread.results?[InterpretationType.future]),
                ],
              )
            ],
          )),
      Container(
        color: const Color.fromARGB(255, 48, 8, 8),
        height: 50,
        child: Row(children: [
          TextButton.icon(
              icon: const Icon(Icons.refresh,
                  color: Color.fromARGB(255, 236, 227, 142)),
              onPressed: () async {
                SpreadController().resetSpread();
                ref.read(watchRefresh.notifier).doRefresh = true;
                await Future.delayed(const Duration(milliseconds: 200));

                ref.read(watchRefresh.notifier).doRefresh = false;
              },
              label: const Text(
                "Reset",
                style: TextStyle(color: Color.fromARGB(255, 236, 227, 142)),
              )),
          const Expanded(child: SizedBox()),
          RandomIconButton()
        ]),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("${'Instrcutions'.TR}:"),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: RichText(
            text: const TextSpan(
                style: TextStyle(fontSize: 12, color: Colors.black),
                children: [
              TextSpan(
                  text:
                      "1. Think about a subject you would like to have some guidance for.\n\n"),
              TextSpan(
                  text:
                      "2. Have a a Rider Tarot deck, or Alternatively choose the Random selection.\n\n"),
              TextSpan(
                  text:
                      "3. Shuffle the deck of cards while thinking and consentrating about the subject.\n\n"),
              TextSpan(
                  text:
                      "4. Select four cards, the first would represent the subject, and the rest represents the past, present and future that are related to the subject.\n\n"),
              TextSpan(
                  text:
                      "5. Click each position, of subject, past, present and future, and take a photo of the card you've selected.\n\n"),
              TextSpan(
                  text:
                      "5.1. If the card that is shown is not the card in the photo, please select it by hand by clicking the 3 dots.\n\n"),
              TextSpan(
                  text:
                      "6. After there's a card in each position, click the card to get the interpretation of the card in its selected position.\n\n")
            ])),
      )
    ];
    return list;
  }
}

class RandomIconButton extends ConsumerWidget {
  RandomIconButton({super.key});
  bool randomInProcess = false;
  @override
  Widget build(BuildContext context, ref) {
    randomInProcess = ref.watch(watchRandom);
    return TextButton.icon(
        icon: randomInProcess
            ? const CircularProgressIndicator(
                color: Color.fromARGB(255, 236, 227, 142))
            : Image.asset('assets/images/spreadIcon.png'),
        onPressed: () async {
          SpreadController().resetSpread();
          ref.read(watchRefresh.notifier).doRefresh = true;
          await Future.delayed(const Duration(milliseconds: 200));

          ref.read(watchRefresh.notifier).doRefresh = false;

          ref.read(watchRandom.notifier).processRandom = true;
          await SpreadController().setRandomSpread(ref);
          ref.read(watchRandom.notifier).processRandom = false;
        },
        label: const Text(
          "Random Card Selection",
          style: TextStyle(color: Color.fromARGB(255, 236, 227, 142)),
        ));
  }
}
