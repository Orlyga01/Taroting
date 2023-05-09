import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taroting/card/card_model.dart';

class CardController {
  static final CardController _cardC = CardController._internal();
  // FirebaseMeetingRepository _meetingRepository = FirebaseMeetingRepository();

  CardController._internal();
  factory CardController() {
    return _cardC;
  }
  final listCard = StreamController<List<Card>>();
  Stream<List<Card>> get getCards => listCard.stream;
  List<Card> _list = Card.getBasicCardList();

  void setCurrentCardList(List<Card> list) {
    _list = list;
    listCard.add(_list);
  }

  // Future<void> saveCard() async {
  //   final menu = locator.get<UserListController>().menu;
  //   try {
  //     locator.get<FamilyController>().updateFamily(
  //         fieldName: "menuJson", fieldValue: Card.toJson(menu));
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  void dispose() {
    listCard.close();
  }

  Future<void> updateCards(List<Card> list) async {
    //Do update menu then sink
    // we want that new or recently updated would always be the first in the list
    _list = list;
    listCard.sink.add(_list);
  }

  // Card getCardById(String cardId) {
  //   return BeUserController()
  //       .user
  //       .cards
  //       .firstWhere((element) => element.id == cardId);
  // }

  
}
