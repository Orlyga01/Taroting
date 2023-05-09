import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sharedor/common_functions.dart';
import 'package:sharedor/misc/model_class.dart';

class Card extends ModelClass<Card> {
  String name;
  String img;
  String arcana;
  String clasificationClass;
  Suit suit;
  String number;

  Card({
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

  static Card get empty => Card(
        number: '',
        name: '',
        arcana: '',
        suit: Suit.cups,
        clasificationClass: '',
        img: '',
      );

  @override
  Card.fromJson(Map<String, dynamic> mjson)
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

  factory Card.fromJ(Map<String, dynamic> mjson) {
    return Card.fromJson(mjson);
  }

  List<Card>? listFromJson(List<dynamic>? list) {
    return (list != null && list.isNotEmpty)
        ? list.map((task) => Card.fromJson(task)).toList()
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

