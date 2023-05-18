import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:sharedor/common_functions.dart';
import 'package:sharedor/misc/model_class.dart';

class TCard extends ModelClass<TCard> {
  String name;
  String img;
  String arcana;
  String clasificationClass;
  Suit suit;
  String number;

  TCard({
    id,
    required this.number,
    required this.clasificationClass,
    required this.name,
    required this.img,
    required this.arcana,
    required this.suit,
    createdAt,
    modifiedAt,
  }) : super(id: id, createdAt: createdAt, modifiedAt: modifiedAt);

  static TCard get empty => TCard(
        number: '',
        name: '',
        arcana: '',
        suit: Suit.cups,
        clasificationClass: '',
        img: '',
      );

  @override
  TCard.fromJson(Map<String, dynamic> mjson)
      : name = '',
        number = '',
        arcana = '',
        suit = Suit.cups,
        img = '',
        clasificationClass = '' {
    super.fromJson(mjson);
    name = mjson['name'];
    clasificationClass = mjson['clasificationClass'];
    img = mjson['img'];
    arcana = mjson['arcana'];
    suit = enumFromString(mjson['suit'], Suit.values) ?? Suit.cups;
  }

  factory TCard.fromJ(Map<String, dynamic> mjson) {
    return TCard.fromJson(mjson);
  }

  List<TCard>? listFromJson(List<dynamic>? list) {
    return (list != null && list.isNotEmpty)
        ? list.map((task) => TCard.fromJson(task)).toList()
        : null;
  }
}

enum Suit { cups, pentacles, swords, trump, wands }

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

