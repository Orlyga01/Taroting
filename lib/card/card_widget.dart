import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taroting/card/card_model.dart';

class CardWidget extends ConsumerWidget {
  TCard? card;
  CardWidget({super.key, this.card});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return card == null
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
                      'assets/cards/${card!.img}', // Replace with your image path
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
                              child: Text(card!.name,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Text(card!.arcana),
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
