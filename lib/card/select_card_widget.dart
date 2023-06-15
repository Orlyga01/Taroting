import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharedor/common_functions.dart';
import 'package:sharedor/helpers/export_helpers.dart';
import 'package:taroting/card/card_controller.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/helpers/global_parameters.dart';
import 'package:taroting/helpers/providers.dart';
import 'package:taroting/spread/spread_controller.dart';

class SelectCardWidget extends StatefulWidget {
  SelectCardWidget({
    super.key,
  });

  @override
  State<SelectCardWidget> createState() => _SelectCardWidgetState();
}

class _SelectCardWidgetState extends State<SelectCardWidget> {
  @override
  late Map<Suit, List<double>> sizeMap = {};
  List<TCard>? list;
  Widget build(BuildContext context) {
    sizeMap[Suit.pentacles] = [80, 80, -15, -75, 1];
    sizeMap[Suit.cups] = [50, 80, -100, -40, 1.2];
    sizeMap[Suit.swords] = [70, 80, -120, 0, 1.45];
    sizeMap[Suit.wands] = [70, 80, -180, 0, 1.45];
    sizeMap[Suit.trump] = [80, 70, -10, -70, 1.5];

    return list != null
        ? Container(
            color: Colors.white,
            width: double.maxFinite,
            height: GlobalParametersTar().screenSize.height * 0.7,
            child: Consumer(builder: (consumercontext, WidgetRef ref, child) {
              return GridView.builder(
                shrinkWrap: true,
                itemCount: list!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns
                  mainAxisSpacing: 10.0, // Spacing between rows
                  crossAxisSpacing: 10.0, // Spacing between columns
                  childAspectRatio:
                      0.57, // Ratio between the width and height of grid items
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: Center(
                        child: InkWell(
                      focusColor: Colors.white,
                      onTap: () async {
                        TCardController().getCard(list![index].id);
                        SpreadController().updateSpread(list![index]);
                        ref.read(watchCard.notifier).cardLoaded =
                            TCardController().currentCard;
                        TCardController().uploadFile(list![index].id);
                        Navigator.of(context).pop();
                      },
                      child: Image.asset(
                        fit: BoxFit.contain,
                        "assets/cards/${list![index].img}",
                      ),
                    )),
                  );
                },
              );
            }),
          )
        : Container(
            color: Colors.white,
            width: double.maxFinite,
            height: GlobalParametersTar().screenSize.height * 0.7,
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: Suit.values.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  mainAxisSpacing: 10.0, // Spacing between rows
                  crossAxisSpacing: 10.0, // Spacing between columns
                  childAspectRatio:
                      1, // Ratio between the width and height of grid items
                ),
                itemBuilder: (BuildContext context, int index) {
                  List<double> ints = sizeMap[Suit.values[index]]!;
                  return OutlinedButton(
                      // style: ButtonStyle(backgroundColor: Colors.white),
                      onPressed: () async {
                        list = await TCardController()
                            .getCardsBySuit(Suit.values[index]);
                        print(list?.length);
                        setState(() {});
                      },
                      child: Column(
                        children: [
                          Center(
                              child: Text(
                                  enumToString(Suit.values[index].toString()),
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black))),
                          Center(
                            child: Suit.values[index] == Suit.trump
                                ? ClipRect(
                                    child: SizedBox(
                                      width: 70,
                                      height: 80,
                                      child: Image.asset('assets/cards/m00.jpg',
                                          fit: BoxFit.contain, scale: 3),
                                    ),
                                  )
                                : ClipRRect(
                                    child: SizedBox(
                                    width: ints[
                                        0], // Define the width of the visible part
                                    height: ints[
                                        1], // Define the height of the visible part
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: ints[2],
                                          top: ints[
                                              3], // Define the x-position to adjust the visible part
                                          child: Image.asset(
                                              'assets/images/suits.jpg',
                                              fit: BoxFit.cover,
                                              scale: ints[4]),
                                        ),
                                      ],
                                    ),
                                  )),
                          ),
                        ],
                      ));
                }),
          );
  }
}
