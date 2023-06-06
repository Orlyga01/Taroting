import 'package:taroting/Interpretation/interpretation_controller.dart';
import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_controller.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/spread/spread_model.dart';

class SpreadController {
  late SpreadModel _currentSpread = SpreadModel.init;

  static final SpreadController _cardC = SpreadController._internal();
  SpreadController._internal();
  factory SpreadController() {
    return _cardC;
  }
  void updateSpread(TCard card) {
    _currentSpread.results![_currentSpread.currentType!] = card;
    TCardController().currentCard = card;
  }

  set isRandom(bool isRandom) => _currentSpread.isRandom = isRandom;
  TCard? getCardInSpread() {
    bool hasCard =
        _currentSpread.results![_currentSpread.currentType]!.id.isNotEmpty;
    return hasCard ? _currentSpread.results![_currentSpread.currentType] : null;
  }

  Future<TCard?> loadCard(
      { TCard? card, InterpretationType? iType}) async {
    _currentSpread.currentType = iType ?? _currentSpread.currentType;
    card = getCardInSpread();
    if (card != null) {
      TCardController().switchCurrentCard = card;
    } else {
      if (_currentSpread.isRandom == true) {
        card = await TCardController().getRandomCard(
          _currentSpread.getCardIds(),
        );
        if (card != null) updateSpread(card);
      }
    }
    return card;
  }

  void set setSpread(SpreadModel spread) => _currentSpread = spread;
  void set setCurrentType(InterpretationType type) {
    _currentSpread.currentType = type;
    TCardController().currentCard = _currentSpread.results![type];
  }

  SpreadModel get currentSpread => _currentSpread;
  InterpretationType? get iType => _currentSpread.currentType;
}
