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
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                height: 200, // Adjust the height according to your image size
                child: Image.asset(
                  'assets/cards/${card.img}', // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        Text(card.arcana)
      ],
    );
  }
}
