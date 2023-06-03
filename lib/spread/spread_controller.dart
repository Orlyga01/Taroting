import 'package:taroting/Interpretation/interpretation_model.dart';
import 'package:taroting/card/card_model.dart';
import 'package:taroting/spread/spread_model.dart';

class SpreadController {
  late SpreadModel _currentSpread;
  static final SpreadController _cardC = SpreadController._internal();
  SpreadController._internal();
  factory SpreadController() {
    _cardC._currentSpread = SpreadModel.init;
    return _cardC;
  }
  void updateSpread(InterpretationType iType, TCard card) {
    _currentSpread.results![iType] = card;
  }

  void set setSpread(SpreadModel spread) => _currentSpread = spread;
  SpreadModel get currentSpread => _currentSpread;
}
