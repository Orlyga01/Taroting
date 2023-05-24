import 'dart:async';
import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharedor/common_functions.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/Interpretation/interpretation_repository.dart';
import 'package:taroting/card/card_controller.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/helpers/global_parameters.dart';
import 'package:taroting/helpers/providers.dart';
import 'package:taroting/keys.dart';

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

    if (savedAnswer != null) {
      answer = savedAnswer.interpretation;
    } else {
      try {
        final chatGpt = ChatGpt(apiKey: chatgpt);
        final request = CompletionRequest(messages: [
          Message(
              role: "system",
              content:
                  "In tarot reading when I get ${card.name} as the ${enumToString(iType.toString())}, what does it mean? ${GlobalParametersTar().languageName}")
        ], maxTokens: 4000, model: ChatGptModel.gpt35Turbo);
        final AsyncCompletionResponse? result =
            await chatGpt.createChatCompletion(request);
        if (result != null && result.choices?.first.message?.content != null) {
          CardInterpretation ci = CardInterpretation(
              cardid: card.id,
              interpretation: result.choices!.first.message!.content,
              interpretationType: iType,
              language: GlobalParametersTar().language);
          InterpretationRepository().add(ci);
          TCardController().addNewInterpretations = ci;
          answer = ci.interpretation;
        }
      } catch (e) {
        rethrow;
      }
    }
    final container = ProviderContainer();

    container.read(watchForAnser.notifier).setNotifyCardStatusChange(answer);
    _answer = answer;
    _iType = iType;
  }

  CardInterpretation? getInterpretationFromCard(
    TCard card,
    InterpretationType iType,
  ) {
    String interId = CardInterpretation.buildId(
        card.id, iType, GlobalParametersTar().language);
    return card.interpretations[interId];
  }

  Future<List<CardInterpretation>?> getAllCardInterpretation({
    required TCard card,
  }) async {
    return InterpretationRepository()
        .getAllByCard(card.id, GlobalParametersTar().language);
  }
}
