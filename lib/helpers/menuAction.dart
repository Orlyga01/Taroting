import 'package:flutter/material.dart';
import 'package:taroting/helpers/translations.dart';

class ActionMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'action1',
            child: Text('Translate'),
          ),
          PopupMenuItem<String>(
            value: 'action2',
            child: Text('Action 2'),
          ),
          PopupMenuItem<String>(
            value: 'action3',
            child: Text('Action 3'),
          ),
        ];
      },
      onSelected: (String value) {
        // Perform action based on the selected value
        switch (value) {
          case 'action1':
            translateAll(language: "he");
            break;
          case 'action2':
            // Perform action 2
            break;
          case 'action3':
            // Perform action 3
            break;
        }
      },
      child: Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
    );
  }
}
