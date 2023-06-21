import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taroting/Interpretation/interpretation_controller.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_controller.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/helpers/providers.dart';
import 'package:taroting/spread/spread_model.dart';

class SpreadController {
  late SpreadModel _currentSpread = SpreadModel.init;
  String? _photoImagePath = "";

  static final SpreadController _cardC = SpreadController._internal();
  SpreadController._internal();
  factory SpreadController() {
    return _cardC;
  }
  void updateSpread(TCard card) {
    // if _currentSpread.prevType != null
    _currentSpread.results![_currentSpread.currentType!] = card;
    TCardController().currentCard = card;
  }

  set saveCroppedImg(String? path) => _photoImagePath = path;
  String? get savedCroppedImg => _photoImagePath;

  set isRandom(bool isRandom) => _currentSpread.isRandom = isRandom;
  bool get isRandom => _currentSpread.isRandom ?? false;

  TCard? getCardInSpread() {
    bool hasCard =
        _currentSpread.results![_currentSpread.currentType]!.id.isNotEmpty;
    return hasCard ? _currentSpread.results![_currentSpread.currentType] : null;
  }

  Future<TCard?> loadCard(
      {TCard? card, InterpretationType? iType, required WidgetRef ref}) async {
    _currentSpread.prevType = _currentSpread.currentType;
    _currentSpread.currentType = iType ?? _currentSpread.currentType;
    card = getCardInSpread();
    if (card != null) {
      TCardController().switchCurrentCard = card;
    } else {
      if (_currentSpread.isRandom == true) {
        card = await TCardController().getRandomCard(
            _currentSpread.getCardIds(), _currentSpread.currentType!);
        if (card != null) updateSpread(card);
      }
    }
    ref.read(watchCard.notifier).cardLoaded = TCardController().currentCard;
    return card;
  }

  void addNewInterpretations(
          CardInterpretation inter, InterpretationType iType) =>
      _currentSpread
          .results![iType]!.interpretations?[inter.interpretationType] = inter;
  void resetSpread() =>
      {_currentSpread = SpreadModel.init, TCardController().reset};
  void set setSpread(SpreadModel spread) => _currentSpread = spread;
  void set setCurrentType(InterpretationType? type) {
    _currentSpread.prevType = _currentSpread.currentType;
    _currentSpread.currentType = type;
    TCardController().currentCard = _currentSpread.results![type];
  }

  Future<void> setRandomSpread(WidgetRef ref) async {
    _currentSpread.isRandom = true;
    for (InterpretationType type in InterpretationType.values) {
      await loadCard(iType: type, ref: ref);
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }

  SpreadModel get currentSpread => _currentSpread;
  InterpretationType? get iType => _currentSpread.currentType;
}
