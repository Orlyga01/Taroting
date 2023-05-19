import 'package:flutter/material.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/card/card_widget.dart';

class InterpretationScreen extends StatelessWidget {
  TCard card;
  InterpretationScreen({required this.card, Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                        width: double.infinity,
                        height:
                            300, // Adjust the height according to your image size
                        child: CardWidget(card: card)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
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
                  ),
                ],
              ),
              SizedBox(
                  height:
                      16), // Adjust the spacing between the image and the content below
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'More Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    // Add more widgets to display additional information
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
