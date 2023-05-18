import 'dart:async';
import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharedor/common_functions.dart';
import 'package:sharedor/helpers/global_parameters.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/Interpretation/interpretation_repository.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/keys.dart';

class InterpretationController {
  late String? cardid;
  static final InterpretationController _interC =
      InterpretationController._internal();
  InterpretationController._internal();
  factory InterpretationController({String? cardid}) {
    _interC.cardid = cardid;
    return _interC;
  }
  Future<String?> getAnswer(TCard card, InterpretationType iType) async {
    CardInterpretation? answer;
    try {
      answer = await getInterpretationFromDB(card, iType);
      if (answer == null) {
        final chatGpt = ChatGpt(apiKey: chatgpt);
        final request = CompletionRequest(messages: [
          Message(
              role: "system",
              content:
                  "In tarot reading when I get ${card.name} as the ${enumToString(iType.toString())}, what does it mean? ${GlobalParameters().languageName}")
        ], maxTokens: 4000, model: ChatGptModel.gpt35Turbo);
        final AsyncCompletionResponse? result =
            await chatGpt.createChatCompletion(request);
        if (result != null && result.choices?.first.message?.content != null) {
          InterpretationRepository().add(CardInterpretation(
              cardId: card.id,
              interpretation: result.choices!.first.message!.content,
              interpretationType: iType));
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<CardInterpretation?> getInterpretationFromDB(
    TCard card,
    InterpretationType iType,
  ) async {
    String id = card.id +
        enumToString(iType.toString()) +
        (GlobalParameters().language);
    return InterpretationRepository().get(CardInterpretation.buildId(
        card.id, iType, GlobalParameters().language));
  }
}
