import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharedor/common_functions.dart';
import 'package:taroting/Interpretation/interpretation_controller.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/card/card_widget.dart';
import 'package:taroting/helpers/providers.dart';
import 'package:taroting/spread/spread_model.dart';

class InterpretationScreen extends StatelessWidget {
  InterpretationScreen({super.key, required this.card});

  TCard card;
  InterpretationType iType = InterpretationType.subject;
  SpreadModel spread = SpreadModel.init;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                      width: double.infinity,
                      height:
                          200, // Adjust the height according to your image size
                      child: CardWidget(card: card)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Handle button 1 click
                        },
                        child: const Text('Subject'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle button 2 click
                        },
                        child: Text('Button 2'),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                  height:
                      16), // Adjust the spacing between the image and the content below
              Consumer(builder: (context, WidgetRef ref, child) {
                ref.watch(watchForAnser);
                String answer = InterpretationController().answer;
                spread.setResult(iType, answer, card);
                return Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "When ${card.name} is in the ${enumToString(iType.toString())}:",
                          style: TextStyle(fontSize: 16)),
                      Text(answer),
                      SizedBox(height: 8),
                      // Add more widgets to display additional information
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
