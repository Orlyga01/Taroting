import 'package:flutter/material.dart';
import 'package:sharedor/helpers/export_helpers.dart';
import 'package:taroting/card/card_controller.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/helpers/global_parameters.dart';

class SelectCardWidget extends StatefulWidget {
  Function(TCard card) onSelect;
  SelectCardWidget({super.key, required this.onSelect});

  @override
  State<SelectCardWidget> createState() => _SelectCardWidgetState();
}

class _SelectCardWidgetState extends State<SelectCardWidget> {
  @override
  late Map<Suit, List<double>> sizeMap = {};
  List<TCard>? list;
  Widget build(BuildContext context) {
    sizeMap[Suit.cups] = [80, 140, -10, 0];
    sizeMap[Suit.pentacles] = [50, 140, -100, 0];
    sizeMap[Suit.swords] = [70, 140, -150, 0];
    sizeMap[Suit.wands] = [70, 140, -220, 0];
    sizeMap[Suit.trump] = [80, 70, -10, -70];

    return list != null
        ? Container(
            color: Colors.white,
            width: double.maxFinite,
            height: GlobalParametersTar().screenSize.height * 0.7,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: list!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of columns
                mainAxisSpacing: 10.0, // Spacing between rows
                crossAxisSpacing: 10.0, // Spacing between columns
                childAspectRatio:
                    0.57, // Ratio between the width and height of grid items
              ),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: Colors
                      .blue, // You can customize the container appearance here
                  child: Center(
                      child: InkWell(
                    focusColor: Colors.white,
                    onTap: () async {
                      TCardController().getCard(list![index].id);
                      Navigator.of(context).pop();
                    },
                    child: Image.asset(
                      fit: BoxFit.contain,
                      "assets/cards/${list![index].img}",
                    ),
                  )),
                );
              },
            ),
          )
        : Container(
            child: Column(
              children: [
                Text("Click the suit:"),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(Suit.values.length - 1, (index) {
                      List<double> ints = sizeMap[Suit.values[index]]!;
                      return InkWell(
                          onTap: () async {
                            list = await TCardController()
                                .getCardsBySuit(Suit.values[index]);
                            print(list?.length);
                            setState(() {});
                          },
                          child: Center(
                            child: ClipRRect(
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
                                        scale: 1.2),
                                  ),
                                ],
                              ),
                            )),
                          ));
                    })),
                InkWell(
                    onTap: () {},
                    child: ClipRect(
                      child: SizedBox(
                        width: 70,
                        height: 100,
                        child: Image.asset('assets/cards/m00.jpg',
                            fit: BoxFit.cover, scale: 3),
                      ),
                    ))
              ],
            ),
          );
  }
}
