import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:sharedor/common_functions.dart';
import 'package:sharedor/misc/model_class.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';

class TCard {
  String name;
  String img;
  String arcana;
  Suit suit;
  String number;
  String id;
  String? Astrology;
  Map<InterpretationType, CardInterpretation>? interpretations; //added
  TCard({
    required this.id,
    required this.number,
    required this.name,
    required this.img,
    required this.arcana,
    required this.suit,
    this.Astrology,
    createdAt,
    modifiedAt,
  });

  static TCard get empty => TCard(
      number: '',
      name: '',
      arcana: '',
      suit: Suit.cups,
      img: '',
      id: '',
      Astrology: '');

  @override
  TCard.fromJson(Map<String, dynamic> mjson)
      : name = '',
        number = '',
        arcana = '',
        suit = Suit.cups,
        img = '',
        Astrology = '',
        id = '' {
    id = mjson['id'];
    name = mjson['name'];

    img = mjson['img'];
    arcana = mjson['arcana'];
    Astrology = mjson['Astrology'];
    suit = enumFromString(mjson['suit'], Suit.values) ?? Suit.cups;
  }
  String? getInterByType(InterpretationType iType) =>
      interpretations?[iType]?.interpretation;
  factory TCard.fromJ(Map<String, dynamic> mjson) {
    return TCard.fromJson(mjson);
  }

  List<TCard>? listFromJson(List<dynamic>? list) {
    return (list != null && list.isNotEmpty)
        ? list.map((task) => TCard.fromJson(task)).toList()
        : null;
  }

  // String convertAstrology() {
  //   List<String> ast = Astrology.split(",");
  //   String ret = "";
  //   Map<String, String> mapper = {"Cancer": "D","Scorpio": "", "Pisces": "L", "Capricorn":"", "Taurus":"", "Virgo": "", "Libra":"", "Aquarius":"", "Leo":"", };
  //   for(String sign in ast) {

  //   }
  // }
}

enum Suit { cups, pentacles, swords, wands, trump }

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

// ignore: non_constant_identifier_names

