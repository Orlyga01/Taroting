import 'dart:convert';
import 'dart:developer';

// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharedor/common_functions.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';

class InterpretationRepository {
  late CollectionReference _cardInterpretationCollection;
  // ignore: unused_field
  late DocumentReference? _dbTaskList;
  static final InterpretationRepository _dbTaskListRep =
      InterpretationRepository._internal();
  InterpretationRepository._internal();
  factory InterpretationRepository() {
    _dbTaskListRep._cardInterpretationCollection =
        FirebaseFirestore.instance.collection("interpretations");
    return _dbTaskListRep;
  }
  Future<CardInterpretation?> add(CardInterpretation cardInterpretation) async {
    // the cardInterpretation id will be the phone number
    try {
      await _cardInterpretationCollection
          .doc(cardInterpretation.id)
          .set(cardInterpretation.toJson());

      return cardInterpretation;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> delete(String cardInterpretationid) {
    return _cardInterpretationCollection.doc(cardInterpretationid).delete();
  }

  Future<CardInterpretation?> get(String? id) async {
    if (id == null || id.isEmpty) return null;
    print("ddd$id");
    try {
      DocumentSnapshot documentSnapshot =
          await _cardInterpretationCollection.doc(id).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        data['id'] = id;
        return CardInterpretation.fromJson(data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> update(String? id,
      [CardInterpretation? cardInterpretation,
      String? fieldName,
      dynamic fieldValue]) {
    if (fieldName != null) {
      if (id == null) {
        log("----------error===========id was not passed to update");
        throw "no cardInterpretation id";
      }

      return _cardInterpretationCollection
          .doc(id)
          .update({fieldName: fieldValue, "modifiedAt": DateTime.now()});
    } else {
      if (cardInterpretation == null) {
        log("----------error===========no cardInterpretation");
        throw "no cardInterpretation ";
      }

      cardInterpretation.modifiedAt = DateTime.now();
      return _cardInterpretationCollection
          .doc(cardInterpretation.id)
          .update(cardInterpretation.toJson());
    }
  }
}
