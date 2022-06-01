import 'package:flutter/foundation.dart';

class PlayerData extends ChangeNotifier {
  int _lives = 3;

  int get lives => _lives;
  set lives(int value) {
    if (value <= 3 && value >= 0) {
      _lives = value;
      notifyListeners();
    }
  }

  int _currentScore = 0;

  int get currentScore => _currentScore;
  set currentScore(int value) {
    _currentScore = value;
    notifyListeners();
  }
}
