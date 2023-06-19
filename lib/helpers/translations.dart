import 'package:taroting/helpers/global_parameters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, Map<String, String>> translations = {
  "Subject": {"he": "הנושא"},
  "Past": {"he": "עבר"}
};

extension TranslateTxt on String {
  String get TR {
    String t = this;
    if (translations[this] != null &&
        translations[this]![GlobalParametersTar().language] != null) {
      return translations[this]![GlobalParametersTar().language]!;
    }
    addToFile(this, this);
    return this;
  }
}

addToFile(String str, String translated) {
  CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection("app_translation");
  _collection
      .doc(str)
      .collection("langs")
      .doc(GlobalParametersTar().language)
      .set({
    "txt": translated,
    "processed": false,
    "modifiedDate": DateTime.now()
  });
}
