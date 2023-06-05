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

  Future<TCard?> loadCard({bool? isRandom = false, TCard? card}) async {
    if (isRandom == true) {
      card = await TCardController().getRandomCard(
        currentSpread.getCardIds(),
      );
     if(card!= null)
      updateSpread(card);
    } else {}
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
