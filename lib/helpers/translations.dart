import 'package:taroting/helpers/global_parameters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taroting/helpers/google_cloud_translate_api.dart';

extension TranslateTxt on String {
  String get TR {
    //if (GlobalParametersTar().language == "en") return this;

    return GlobalParametersTar().translations[this] ?? this;
    //if (GlobalParametersTar().language == "en") return this;

    //addToFile(this, this);
  }
}

translateAll({String? language}) async {
  String nLang = language ?? GlobalParametersTar().language;
  CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection("app_translation");
  List<String> forTranslate = [];
  forTranslate = await _collection.get().then((snapshot) {
    return snapshot.docs.map((doc) => doc.id).toList();
  });
  try {
    String? translated =
        // "לאחר שיש קלף בכל עמדה, לחץ על הקלף כדי לקבל את הפרשנות של הקלף במיקום הנבחר שלו<>לחץ על כל עמדה, של נושא, עבר, הווה ועתיד, וצלם את הקלף שבחרת<> כוסות<>עתיד<>יש לכם חפיסת טארוט רוכב, או לחלופין בחרו בבחירה אקראית<>אם הקלף המוצג אינו הקלף בתמונה, אנא בחרו אותו ביד על ידי לחיצה על 3 הנקודות<>הוראות<>מינורי Arcana<>עבר<>חומשים<>אנא בחר את הכרטיס שלך:<>הווה<>איפוס<>בחר ארבעה כרטיסים, הראשון יייצג את הנושא, והשאר מייצג את העבר, ההווה והעתיד הקשורים לנושא< >ערבב את חפיסת הקלפים תוך חשיבה והתרכזות בנושא<>ששת שרביטים<>נושא<>חרבות<>חשבו על נושא שתרצו לקבל הדרכה ל<>טראמפ<>שרביטים<>כמו<> c4J32ztoxCgG0lSZcXum";
        await TranslationApi.translate(forTranslate.join('<>'), nLang);
    List<String> translatedLs = translated.replaceAll("< >", "<>").split('<>');
    if (translatedLs.length != forTranslate.length) return;
    for (int i = 0; i < forTranslate.length; i++) {
      addToFile(forTranslate[i], translatedLs[i], language: nLang);
    }
  } catch (e) {
    print(e);
  }
}

Future<Map<String, String>> getTranslations() async {
  String lang = GlobalParametersTar().language;
  Map<String, String> translations = {};
  CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection("app_translation");
  List<String> forTranslate = [];
  final tm = await _collection.get().then((snapshot) {
    return snapshot.docs
        .map((doc) => translations[doc.id] = doc[lang] ?? doc.id);
  });
  return translations;
}

addToFile(String str, String translated, {String? language}) {
  String nLang = language ?? GlobalParametersTar().language;

  CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection("app_translation");
  _collection.doc(str).set({});
  _collection.doc(str).set({nLang: translated});
}
