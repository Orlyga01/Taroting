import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharedor/export_common.dart';
import 'card_model.dart';

class FirebaseTCardsRepository {
  late String cardid;
  late CollectionReference<Map<String, dynamic>> _cardDoc;
  late FirebaseFirestore _db;
  static final FirebaseTCardsRepository _dbTCard =
      FirebaseTCardsRepository._internal();
  FirebaseTCardsRepository._internal();
  factory FirebaseTCardsRepository() {
    _dbTCard._db = FirebaseFirestore.instance;
    _dbTCard._cardDoc = _dbTCard._db.collection("cards");
    return _dbTCard;
  }

  Future<TCard?> get(String? id) async {
    if (id == null || id.isEmpty) return null;
    try {
      DocumentSnapshot documentSnapshot = await _cardDoc.doc(id).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        data['id'] = id;
        return TCard.fromJson(data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TCard>?> getListBySuit(Suit suit) async {
    String ssuit = enumToString(suit.toString());

    try {
      List<TCard> documentSnapshot = await _cardDoc
          .where("suit", isEqualTo: ssuit.capitalize())
          .get()
          .then((value) => value.docs
              .map((doc) => TCard.fromJson(doc.data()..["id"] = doc.id))
              .toList());

      return documentSnapshot;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TCard>?> getAll() async {
    try {
      List<TCard> documentSnapshot = await _cardDoc.get().then((value) => value
          .docs
          .map((doc) => TCard.fromJson(doc.data()..["id"] = doc.id))
          .toList());

      return documentSnapshot;
    } catch (e) {
      rethrow;
    }
  }
}
