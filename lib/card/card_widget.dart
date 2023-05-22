import 'package:flutter/material.dart';
import 'package:taroting/card/card_model.dart';

class CardWidget extends StatelessWidget {
  final TCard card;
  const CardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 200),
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
                        child: Text(card.name,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Text(card.arcana)
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
