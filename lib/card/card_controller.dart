import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:taroting/Interpretation/interpretation_controller.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/card/card_repository.dart';
import 'package:path/path.dart' as Path;

// import 'package:tflite/tflite.dart';

class TCardController {
  late String cardid;
  TCard? currentCard;
  static final TCardController _cardC = TCardController._internal();
  TCardController._internal();
  factory TCardController() {
    return _cardC;
  }

  Future<TCard?> identifyTCard(String imagePath) async {
    String? res = await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt",
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );
    List<dynamic>? output = await Tflite.runModelOnImage(
      path: imagePath,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    if (output != null && output.isNotEmpty) {
      return getCard(output[0]["label"].split(" ")[1]);
    } else {
      uploadFile(imagePath);
      throw ("not found");
    }
  }

  Future<TCard?> getCard(String cardid) async {
    TCard? card = await FirebaseTCardsRepository().get(cardid);
    if (card != null) {
      currentCard = card;
      await loadInterpretations();
      //  InterpretationController().getAnswer(card, InterpretationType.subject, );
    } else {
      print(cardid + " wasnt able to find in DB");
    }

    return card;
  }

  set switchCurrentCard(TCard card) => currentCard = card;
  loadInterpretations() async {
    List<CardInterpretation>? list = await InterpretationController()
        .getAllCardInterpretation(card: currentCard!);
    if (list != null) {
      currentCard!.interpretations = {
        for (CardInterpretation v in list) v.interpretationType: v
      };
    }
  }

  setAnswer(InterpretationType iType, String answer) {
    currentCard!.interpretations?[iType]!.interpretation = answer;
  }

  set addNewInterpretations(CardInterpretation inter) =>
      currentCard!.interpretations?[inter.interpretationType] = inter;

  TCard? get card => currentCard;
  Future<TCard?> getRandomCard(List<String>? exists) async {
    String? cardid;
    while (cardid == null) {
      cardid = randomCard();
      if (exists != null && exists.contains(cardid)) {
        cardid = null;
      } else {
        return getCard(cardid);
      }
    }
  }

  String randomCard() {
    List<String> series = [
      "Trump",
      "Cups",
      "Pentacles",
      "Swords",
      "Trump",
      "Wands",
      "Cups",
      "Pentacles",
      "Swords",
      "Trump",
      "Wands"
    ];
    List<int> positionPerSeries = [0, 0, 0, 0, 0, 7, 7, 7, 7, 7, 13];
    Random random = new Random();
    int randomNumber = random.nextInt(11);
    String serie = series[randomNumber];
    int position = positionPerSeries[randomNumber];
    randomNumber = random.nextInt(7);
    position = position + randomNumber;
    return serie + position.toString();
  }

  Future<String> uploadFile(String imagepath) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String finalUrl = "";
    //if person is deleted - need to clear this image - or when image changes - we need to remove this image
    Reference ref =
        storage.ref().child('notFound/${Path.basename(imagepath)}}');
    UploadTask uploadTask = ref.putFile(File(imagepath));
    await uploadTask;
    await ref.getDownloadURL().then((fileURL) {
      finalUrl = fileURL;
    }).catchError((onError) {
      throw onError;
    });
    return finalUrl;
  }
}
