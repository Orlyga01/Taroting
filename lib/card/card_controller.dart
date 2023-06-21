import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taroting/Interpretation/interpretation_controller.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/card/card_repository.dart';
import 'package:path/path.dart' as Path;
import 'package:taroting/spread/spread_controller.dart';
import 'package:flutter/services.dart' show rootBundle;

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
    if (kDebugMode && !Platform.isIOS) {
      output = [
        {"label": "1 Cups1", "confidence": 0.9}
      ];
    }
    if (output != null && (output.isEmpty || output[0]["confidence"] < 0.6)) {
      String cardfound =
          output.length > 0 ? output[0]["label"].split(" ")[1] : "";
      String? imgPath = SpreadController().savedCroppedImg;
      if (imgPath != null) {
        uploadFile(imgPath, cardfound);
      }
    }
    if (output != null && output.isNotEmpty) {
      return getCard(output[0]["label"].split(" ")[1], SpreadController().iType!);
    } else {
      throw ("not found");
    }
  }

  Future<List<TCard>?> getCardsBySuit(Suit suit) async {
    return FirebaseTCardsRepository().getListBySuit(suit);
  }

  Future<TCard?> getCard(String cardid, InterpretationType iType) async {
    TCard? card = await FirebaseTCardsRepository().get(cardid);
    if (card != null) {
      currentCard = card;
      await loadInterpretations();
      InterpretationController().getAnswer(card, iType);
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

  void reset() {
    currentCard = null;
  }

  setAnswer(InterpretationType iType, String answer) {
    currentCard!.interpretations?[iType]!.interpretation = answer;
  }



  TCard? get card => currentCard;
  Future<TCard?> getRandomCard(List<String>? exists, InterpretationType iType) async {
    String? cardid;
    while (cardid == null) {
      cardid = randomCard();
      if (exists != null && exists.contains(cardid)) {
        cardid = null;
      } else {
        return getCard(cardid, iType);
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

  Future<String> uploadFile(String cardfound, [String? imagepath]) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    String finalUrl = cardfound + DateTime.now().toString();
    imagepath ??= SpreadController().savedCroppedImg;
    if (imagepath == null) return "";
    //if person is deleted - need to clear this image - or when image changes - we need to remove this image
    Reference ref = storage.ref().child('notFound/$finalUrl');
    UploadTask uploadTask = ref.putFile(File(imagepath));
    await uploadTask;
    await ref.getDownloadURL().then((fileURL) {
      finalUrl = fileURL;
    }).catchError((onError) {
      throw onError;
    });
    return finalUrl;
  }

  onTimeRun() async {
    List<TCard> cards = await FirebaseTCardsRepository().getAll() ?? [];
    FirebaseStorage storage = FirebaseStorage.instance;
    for (TCard card in cards) {
      final ByteData byteData =
          await rootBundle.load('assets/cards/${card.img}');
//final byteData = await asset.getByteData();

      File tempFile = File(
          "${(await getTemporaryDirectory()).path}/${'assets/cards/${card.img}'}");
      tempFile.create(recursive: true);
      await tempFile.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      //  file = await tempFile.writeAsBytes(
      //   byteData.buffer
      //       .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),);
      // final String fullPath = Uri.parse(assetData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes)).toFilePath();
      Reference ref = storage.ref().child('notFound/${card.id}/${card.img}');
      UploadTask uploadTask = ref.putFile(File(tempFile.path));
      await uploadTask;
    }
  }
}
