import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_model.dart';

class SpreadModel {
  SpreadType type;
  Map<InterpretationType, SpreadResultModel>? results;

  SpreadModel({required this.type, this.results});
  static SpreadModel get init => SpreadModel(type: SpreadType.ppf, results: {
        InterpretationType.subject: SpreadResultModel(
          "",
          TCard.empty,
        ),
        InterpretationType.past: SpreadResultModel(
          "",
          TCard.empty,
        ),
        InterpretationType.present: SpreadResultModel(
          "",
          TCard.empty,
        ),
        InterpretationType.future: SpreadResultModel(
          "",
          TCard.empty,
        )
      });

  void setResult(InterpretationType iType, String inter, TCard card) =>
      results![iType] = SpreadResultModel(inter, card);
}

enum SpreadType { ppf }

class SpreadResultModel {
  String inter;
  TCard card;
  SpreadResultModel(this.inter, this.card);
}
