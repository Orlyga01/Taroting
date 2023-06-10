import 'dart:async';
import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:sharedor/common_functions.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/Interpretation/interpretation_repository.dart';
import 'package:taroting/card/card_controller.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/helpers/global_parameters.dart';
import 'package:taroting/helpers/google_cloud_translate_api.dart';
import 'package:taroting/keys.dart';
import 'package:taroting/spread/spread_controller.dart';
import 'package:google_translator/google_translator.dart';

class InterpretationController {
  late String? cardid;
  String? _answer;
  InterpretationType? _iType;
  static final InterpretationController _interC =
      InterpretationController._internal();
  InterpretationController._internal();
  factory InterpretationController({String? cardid}) {
    _interC.cardid = cardid;
    return _interC;
  }
  get answer => _answer;
  get iType => _iType;
  Future<void> getAnswer(TCard card, InterpretationType iType) async {
    String answer = "";

    CardInterpretation? savedAnswer = getInterpretationFromCard(card, iType);
    if (card.id.isEmpty) return;
    if (savedAnswer != null) {
      _answer = savedAnswer.interpretation;
      _iType = iType;
      return;
    }
//if we found in english then just do the translation and save to db
    if (GlobalParametersTar().language != "en") {
      CardInterpretation? enAnswer = await getInterpretation(card, iType, "en");
      if (enAnswer != null) {
        try {
          _answer = await TranslationApi.translate(
              enAnswer.interpretation, GlobalParametersTar().language);
          _iType = iType;
          afterGetAnswerFromThirdParty(card, _answer!);
          return;
        } catch (e) {
          rethrow;
        }
      }
    }
// we dont have the answer in English
    try {
      final chatGpt = ChatGpt(apiKey: chatgpt);

      final request = CompletionRequest(
        messages: [
          Message(
              role: "system",
              content:
                  "In tarot reading when I get ${card.name} as the ${enumToString(iType.toString())}, what does it mean? ")
        ],
        maxTokens: 4000,
        model: ChatGptModel.gpt35Turbo,
      );
      final AsyncCompletionResponse? result =
          await chatGpt.createChatCompletion(request);
      if (result != null && result.choices?.first.message?.content != null) {
        //Save the English version
        afterGetAnswerFromThirdParty(
            card, result.choices!.first.message!.content, "en");
        _answer = await TranslationApi.translate(
            result.choices!.first.message!.content,
            GlobalParametersTar().language);
        afterGetAnswerFromThirdParty(
            card, result.choices!.first.message!.content);
      }
    } catch (e) {
      rethrow;
    }
  }

  afterGetAnswerFromThirdParty(TCard card, String answer, [String? language]) {
    CardInterpretation ci = CardInterpretation(
        cardid: card.id,
        interpretation: answer,
        interpretationType: iType,
        language: language ?? GlobalParametersTar().language);
    InterpretationRepository().add(ci);
    TCardController().addNewInterpretations = ci;
    SpreadController().updateSpread(TCardController().currentCard!);
    _answer = answer;
  }

  CardInterpretation? getInterpretationFromCard(
    TCard card,
    InterpretationType iType,
  ) {
    String interId = CardInterpretation.buildId(
        card.id, iType, GlobalParametersTar().language);
    print("look for anser in card:  $interId");
    return card.interpretations != null ? card.interpretations![iType] : null;
  }

  Future<CardInterpretation?> getInterpretation(
      TCard card, InterpretationType iType,
      [String? language]) async {
    String interId = CardInterpretation.buildId(
        card.id, iType, language ?? GlobalParametersTar().language);
    return InterpretationRepository().get(interId);
  }

  Future<List<CardInterpretation>?> getAllCardInterpretation({
    required TCard card,
  }) async {
    return InterpretationRepository()
        .getAllByCard(card.id, GlobalParametersTar().language);
  }
}
      // "translatedText": "דף הגביעים בקריאה בטארוט מייצג בדרך כלל אדם צעיר או אנרגיה צעירה שהוא רגשי, יצירתי ואינטואיטיבי. כרטיס זה יכול לציין הודעה או חדשות הקשורות לאהבה, מערכות יחסים או פרויקטים יצירתיים. זה עשוי גם להצביע על צורך לנצל את האנרגיה הרגשית והיצירתית שלך כדי להכניס יותר שמחה והגשמה לחייך. דף הגביעים יכול לייצג גם התחלה חדשה או התחלה חדשה בתחומים אלו."
