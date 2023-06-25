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
import 'package:taroting/spread/spread_navigation_full.dart';

class SpreadScreen extends StatelessWidget {
  SpreadScreen({super.key});
  SpreadModel spread = SpreadModel.init..isRandom = false;

  InterpretationType? iType;
  bool showCamera = false;
  bool showSpreadFull = true;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (consumercontext, WidgetRef ref, child) {
      showCamera = ref.watch(watchOpenCamera);
      showSpreadFull = ref.watch(watchSpreadFullView);
      List<Widget> children = getListWidgets(context, ref);
      return Scaffold(
          body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: showSpreadFull || showCamera ? 0 : 20.0),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: children.length,
            itemBuilder: (context, index) {
              return children[index];
            }),
      ));
    });
  }

  List<Widget> getListWidgets(context, ref) {
    List<Widget> list = [];
    if (showSpreadFull != true && showCamera == false) {
      list = [
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
              onPressed: () {
                ref.read(watchSpreadFullView.notifier).setFullViewState = true;
              },
              icon: const Icon(Icons.arrow_back)),
        )
      ];
    }
    list = list +
        [
          !showCamera
              ? showSpreadFull
                  ? SpreadNavigationFull()
                  : SpreadNavigation()
              : CaptureCameraWidget(),
        ];
    if (showCamera == false && showSpreadFull == false) {
      // if (SpreadController().isRandom != true &&
      //     TCardController().currentCard != null) {
      //   list = list +
      //       [
      //         Container(
      //           color: Colors.grey.shade200,
      //           padding: EdgeInsets.all(8),
      //           child: Wrap(
      //             children: [
      //               Text("This is not the correct card?"),
      //               SizedBox(
      //                 width: 20,
      //               ),
      //               ElevatedButton(
      //                 onPressed: () {
      //                   showDialog(
      //                       context: context,
      //                       builder: (_) {
      //                         // return object of type Dialog

      //                         return AlertDialog(
      //                           title: SelectCardWidget(
      //                             chooseCard: true,
      //                           ),
      //                         );
      //                       });
      //                 },
      //                 child: Text("Get the card",
      //                     style: const TextStyle(color: Colors.black)),
      //                 style: ElevatedButton.styleFrom(
      //                   backgroundColor: Colors.white,
      //                   elevation: 4.0,
      //                 ),
      //               )
      //             ],
      //           ),
      //         )
      //       ];
      // }
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
