import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:sharedor/common_functions.dart';
import 'package:sharedor/misc/model_class.dart';

class CardInterpretation extends ModelClass<CardInterpretation> {
  String cardid;
  InterpretationType interpretationType;
  String interpretation;
  String? language;

  CardInterpretation({
    id = "",
    required this.cardid,
    required this.interpretation,
    this.language,
    required this.interpretationType,
    createdAt,
    modifiedAt,
  }) : super(createdAt: createdAt, modifiedAt: modifiedAt);
  String buildIdInter() => buildId(cardid, interpretationType, language);
  static String buildId(
          String cardid, InterpretationType iType, String? language) =>
      cardid + enumToString(iType.toString()) + (language ?? "en");
  static CardInterpretation get empty => CardInterpretation(
      cardid: '',
      interpretation: '',
      language: '',
      interpretationType: InterpretationType.subject);

  @override
  CardInterpretation.fromJson(Map<String, dynamic> mjson)
      : cardid = '',
        interpretation = '',
        language = '',
        interpretationType = InterpretationType.subject {
    super.fromJson(mjson);
    cardid = mjson['cardid'];
    interpretation = mjson['interpretation'];
    language = mjson['language'];
    interpretationType = enumFromString(
            mjson['interpretationType'], InterpretationType.values) ??
        InterpretationType.subject;
  }

  factory CardInterpretation.fromJ(Map<String, dynamic> mjson) {
    return CardInterpretation.fromJson(mjson);
  }

  List<CardInterpretation>? listFromJson(List<dynamic>? list) {
    return (list != null && list.isNotEmpty)
        ? list.map((task) => CardInterpretation.fromJson(task)).toList()
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['id'] = buildId(cardid, interpretationType, language);
    data['cardid'] = cardid;
    data['language'] = language;
    data['interpretation'] = interpretation;
    data['interpretationType'] = enumToString(interpretationType.toString());
    return data;
  }
}

enum InterpretationType { subject, past, present, future }

class GenericInfoEnum {
  final String? name;
  final String? img;
  final IconData? icon;
  final bool? singleton;
  final int? importance;
  GenericInfoEnum(
      {this.importance,
      this.name,
      this.singleton = false,
      this.img,
      this.icon});
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
