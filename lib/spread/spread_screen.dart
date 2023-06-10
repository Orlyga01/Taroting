import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/Interpretation/interpretation_widget.dart';
import 'package:taroting/card/camera.dart';
import 'package:taroting/card/card_controller.dart';
import 'package:taroting/card/card_widget.dart';
import 'package:taroting/helpers/providers.dart';
import 'package:taroting/spread/spread_controller.dart';
import 'package:taroting/spread/spread_model.dart';
import 'package:taroting/spread/spread_navigation.dart';
import 'package:taroting/card/select_card_widget.dart';

class SpreadScreen extends StatelessWidget {
  SpreadScreen({super.key});
  SpreadModel spread = SpreadModel.init..isRandom = false;

  InterpretationType? iType;
  bool showCamera = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (consumercontext, WidgetRef ref, child) {
      showCamera = ref.watch(watchOpenCamera);

      List<Widget> children = getListWidgets(context);
      return Scaffold(
          body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: children.length,
                  itemBuilder: (context, index) {
                    return children[index];
                  })));
    });
  }

  List<Widget> getListWidgets(context) {
    List<Widget> list;
    list = [
      CaptureCameraWidget(),
      SpreadNavigation(),
    ];
    if (showCamera == false) {
      if (SpreadController().isRandom != true && TCardController().currentCard != null) {
        
        list = list +
            [
              
              Container(
                color: Colors.grey.shade200,
                padding: EdgeInsets.all(8),
                child: Wrap(
                  children: [
                    Text("This is not the correct card?"),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              // return object of type Dialog

                              return AlertDialog(
                                title: SelectCardWidget(),
                              );
                            });
                      },
                      child: Text("Get the card",
                          style: const TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 4.0,
                      ),
                    )
                  ],
                ),
              )
            ];
      }
      list = list +
          [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Container(
                  width: double.infinity,
                  height: 160, // Adjust the height according to your image size
                  child: CardWidget(card: spread.results![iType])),
            ),
            InterpretationWidget()
          ];
    }
    return list;
  }
}
