import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taroting/Interpretation/interpretation_controller.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/card/card_repository.dart';
// import 'package:tflite/tflite.dart';

class TCardController {
  late String cardid;
  late TCard currentCard;
  static final TCardController _cardC = TCardController._internal();
  TCardController._internal();
  factory TCardController() {
    return _cardC;
  }

  Future<TCard?> identifyTCard(XFile? image) async {
    if (image == null) return null;
    String? res = await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt",
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    if (output != null && output[0]["confidence"] > 0.8) {
      return FirebaseTCardsRepository().get(output[0]["label"]);
    } else {
      throw ("not found");
    }
  }

  Future<TCard?> getCard(String cardid) async {
    TCard? card = await FirebaseTCardsRepository().get(cardid);
    if (card != null) {
      currentCard = card;
      await loadInterpretations();
      InterpretationController().getAnswer(card, InterpretationType.subject);
    }
    return card;
  }

  loadInterpretations() async {
    List<CardInterpretation>? list = await InterpretationController()
        .getAllCardInterpretation(card: currentCard);
    if (list != null) {
      card.interpretations = {for (CardInterpretation v in list) v.id: v};
    }
  }

  set addNewInterpretations(CardInterpretation inter) =>
      card.interpretations[inter.id] = inter;

  TCard get card => currentCard;
}
