import 'common_types.dart';
import 'turn_order.dart';
import 'matching_mode.dart';

class ModifiedMemoryGameModel {
  final TurnOrder _playerHandler;
  final MatchingMode _gridHandler;

  ModifiedMemoryGameModel ({
    required TurnOrder playerHandler,
    required MatchingMode gridHandler
  }):
    _playerHandler = playerHandler,
    _gridHandler = gridHandler
  {
    if (_gridHandler.isInvalid) throw "Invalid grid";
  }

  Player get currentPlayer => _playerHandler.currentPlayer;

  int score(Player player) {
    return _playerHandler.score(player);
  }

  Player? get winner => isGameDone ? _playerHandler.higherScore : null;

  bool get isGameDone => _gridHandler.allMatched;

  bool selectToken(int row, int col) {
    if (
      (isGameDone) ||
      (!(0 <= row && row < rowCount) || !(0 <= col && col < colCount)) ||
      (_gridHandler.isFlipped(row, col)) ||
      (_gridHandler.tooManySelections)
    ) {
      return false;
    }

    _gridHandler.flip(row, col);
    _gridHandler.addSelection(row, col);
    if (_gridHandler.isMatch()) {
      _playerHandler.incrementScore();
    }
    return true;
  }

  bool confirmTurnEnd() {
    bool match = _gridHandler.isMatch();
    if (!isGameDone && _gridHandler.tooManySelections) {
      if (!match) {
        _gridHandler.unflipSelections();
      } else {
        _gridHandler.addMatch();
      }
      _playerHandler.nextTurn(match);
      _gridHandler.clearSelections();
      return true;
    }
    return false;
  }

  int? getTokenNumber(int row, int col) {
    if (!(0 <= row && row < rowCount) || !(0 <= col && col < colCount)){
      return null;
    }

    if (!_gridHandler.isFlipped(row, col)) {
      return null;
    }

    return _gridHandler.getTokenNumber(row, col);
  }

  int get rowCount => _gridHandler.rowCount;

  int get colCount => _gridHandler.colCount;
}
