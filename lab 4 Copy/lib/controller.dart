import 'package:flutter/material.dart';
import 'model.dart';
import 'common_types.dart';
import 'turn_order.dart';
import 'matching_mode.dart';

class GameController extends ChangeNotifier {
  ModifiedMemoryGameModel? _model;
  
  ModifiedMemoryGameModel? get model => _model;
  
  void initializeGame({
    required int rows,
    required int cols,
    required int seed,
    required MatchingModeTag matchingMode,
    required TurnOrderTag turnOrder,
  }) {
    print('Controller: making game with rows=$rows, cols=$cols, seed=$seed, matchingMode=$matchingMode, turnOrder=$turnOrder');
    try {
      // grid contraints validation
      int tokensPerGroup = _getTokensPerGroup(matchingMode);
      if ((rows * cols) % tokensPerGroup != 0) {
        throw Exception('Invalid grid');
      }
      
     
      TurnOrder playerHandler = _createTurnOrder(turnOrder);
      
      
      MatchingMode gridHandler = _createMatchingMode(matchingMode, rows, cols, seed);
      
      _model = ModifiedMemoryGameModel(
        playerHandler: playerHandler,
        gridHandler: gridHandler,
      );
      print('Controller: model initialized successfully');
      notifyListeners();
    } catch (e) {
      // invalid grid 
      print('Controller: model initialization failed: $e');
      _model = null;
      notifyListeners();
    }
  }
  
  TurnOrder _createTurnOrder(TurnOrderTag turnOrder) {
    switch (turnOrder) {
      case TurnOrderTag.roundRobin:
        return TurnOrder();
      case TurnOrderTag.untilIncorrect:
        return TurnOrder_UntilIncorrect();
    }
  }
  
  MatchingMode _createMatchingMode(MatchingModeTag matchingMode, int rows, int cols, int seed) {
    switch (matchingMode) {
      case MatchingModeTag.regular:
        return MatchingMode(R: rows, C: cols, S: seed);
      case MatchingModeTag.extra1:
        return MatchingMode_Extra1(R: rows, C: cols, S: seed);
      case MatchingModeTag.extra2:
        return MatchingMode_Extra2(R: rows, C: cols, S: seed);
    }
  }
  
  int _getTokensPerGroup(MatchingModeTag matchingMode) {
    switch (matchingMode) {
      case MatchingModeTag.regular:
        return 2;
      case MatchingModeTag.extra1:
      case MatchingModeTag.extra2:
        return 3;
    }
  }
  
  bool selectToken(int row, int col) {
    if (_model == null) return false;
    
    bool result = _model!.selectToken(row, col);
    if (result) {
      notifyListeners();
    }
    return result;
  }
  
  bool confirmTurnEnd() {
    if (_model == null) return false;
    
    bool result = _model!.confirmTurnEnd();
    if (result) {
      notifyListeners();
    }
    return result;
  }
  
  
  Player? get currentPlayer => _model?.currentPlayer;
  Player? get winner => _model?.winner;
  int? getScore(Player player) => _model?.score(player);
  bool get isGameDone => _model?.isGameDone ?? false;
  bool get awaitingConfirmation {
    
    return _model != null && !isGameDone;
  }
  int? getTokenNumber(int row, int col) => _model?.getTokenNumber(row, col);
  bool isTokenFlipped(int row, int col) {
    


    if (_model == null) return false;
    
    // check bounds
    if (row < 0 || row >= rowCount || col < 0 || col >= colCount) {
      return false;
    }
    
   
    return _model!.getTokenNumber(row, col) == null;
  }
  bool isTokenSelected(int row, int col) {
    return false;
  }
  int get rowCount => _model?.rowCount ?? 0;
  int get colCount => _model?.colCount ?? 0;
}