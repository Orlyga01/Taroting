import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/helpers/providers.dart';
import 'package:taroting/helpers/translations.dart';

class CardWidget extends ConsumerWidget {
  TCard? card;
  CardWidget({super.key, this.card});
  //bool showCamera = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final card = ref.watch(watchCard);
    // showCamera = ref.watch(watchOpenCamera);

    return card == null // || showCamera == true
        ? SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 150),
                    // width: double.infinity,
                    // height: 200, // Adjust the height according to your image size
                    child: Image.asset(
                      'assets/cards/${card.img}', // Replace with your image path
                      fit: BoxFit.contain,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(card.name.TR,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Text(card.arcana.TR),
                            // Text(
                            //   "ABCDEFGHIJKLMNOP",
                            //   style: TextStyle(
                            //       fontFamily: "ZodiacSigns", fontSize: 30, fontWeight: FontWeight.bold),
                            // )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
  }
}
