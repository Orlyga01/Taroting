import 'package:cloud_firestore/cloud_firestore.dart';
import 'card_model.dart';

class FirebaseUserCardsRepository {
  late String userid;
  late DocumentReference _userDoc;
  late FirebaseFirestore _db;
  static final FirebaseUserCardsRepository _dbUserCards =
      FirebaseUserCardsRepository._internal();
  FirebaseUserCardsRepository._internal();
  factory FirebaseUserCardsRepository({required String userid}) {
    _dbUserCards.userid = userid;
    _dbUserCards._db = FirebaseFirestore.instance;
    _dbUserCards._userDoc = _dbUserCards._db.collection("users").doc("123");
    return _dbUserCards;
  }
  Future<void> addInitialCardsList({List<Card>? cards}) async {
    if (cards == null) {
      WriteBatch batch = _db.batch();
      cards = [];
      for (var element in CardType.values) {
        int? imp = CardTypes[element]!.importance;
        if (imp != null && imp > 5) {
          cards.add(
            Card.empty
              ..type = element
              ..title = CardTypes[element]!.name!,
          );
        }
      }
      List<Map<String, dynamic>> toSave = [];
      for (var element in cards) {
        toSave.add(element.toJson());
      }
      return _userDoc.update({"cards": toSave});
      // batch.commit();
    }
  }

  Future<void> add(Card card) {
    return _userDoc.update({
      "cards": FieldValue.arrayUnion([card.toJson()])
      //return _userDoc.set(card.toJson());
    });
  }

// This includes all actions such as add update and remove
  Future<void> update(List<Card> lcards) async {
    // // return _userDoc.set(card.toJson());
    // // final int index = lcards.indexWhere(( (card) =>card.id == card.id));
    // // if (index > -1 ) {

    // // }
    // WriteBatch batch = _db.batch();
    // //batch.set();
    // // _userDoc.cards.where("cards", "array-contains", card.toJson());
    // Map<String, dynamic> cardJ = card.toJson();
    // batch.update(_userDoc, {
    //   "cards": FieldValue.arrayRemove([cardJ])
    // });
    // batch.update(_userDoc, {
    //   "cards": FieldValue.arrayUnion([cardJ])
    // });
    // _userDoc.update({
    //   "cards": FieldValue.arrayUnion([
    //     {
    //       "Price": 3000,
    //       "Paid": true,
    //     }
    //   ])
    // });
  }
}
