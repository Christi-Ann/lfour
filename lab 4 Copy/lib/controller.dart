import 'package:flutter/material.dart';
import 'model.dart';
import 'common_types.dart';
import 'tester.dart';


class GameController extends ChangeNotifier {
  ModifiedMemoryGameModel? _model;
  List<Offset> _selectedTokens = [];
  MatchingModeTag? _currentMatchingMode;
  
 
  ModifiedMemoryGameModel? get model => _model;
  
 
  GameController([ModifiedMemoryGameModel? model, MatchingModeTag? matchingMode]) {
    if (model != null) {
      _model = model;
    }
    if (matchingMode != null) {
      _currentMatchingMode = matchingMode;
    }
  }
  
  
  void initializeGame({
    required int rows,
    required int cols,
    required int seed,
    required MatchingModeTag matchingMode,
    required TurnOrderTag turnOrder,
  }) {
    print('Controller: Initializing memory game with rows=$rows, cols=$cols, seed=$seed, matchingMode=$matchingMode, turnOrder=$turnOrder');
    
    
    _currentMatchingMode = matchingMode;
    
    _selectedTokens.clear();
    
    
    notifyListeners();
  }
  
  
  bool selectToken(int row, int col) {
    if (_model == null) {
      print('Controller: Cannot select token - model is null');
      return false;
    }
    
    
    bool success = _model!.selectToken(row, col);
    
    if (success) {
      _selectedTokens.add(Offset(col.toDouble(), row.toDouble()));
      //print('Controller: Token selected at ($row, $col)');
      notifyListeners();
    } 
    
    return success;
  }
  
  
  bool confirmTurnEnd() {
    if (_model == null) {
      return false;
    }
    
    
    bool success = _model!.confirmTurnEnd();
    
    if (success) {
      _selectedTokens.clear();
      notifyListeners();
    }
    
    return success;
  }
  

  void resetGame() {
    if (_model != null) {
      _selectedTokens.clear();
      notifyListeners();
    }
  }
  
 
 
  Player? get currentPlayer => _model?.currentPlayer;

  Player? get winner => _model?.winner;
  

  int getScore(Player player) => _model?.score(player) ?? 0;
  
  bool get isGameDone => _model?.isGameDone ?? false;
  
  
  int? getTokenNumber(int row, int col) {
    if (_model == null) return null;
    return _model!.getTokenNumber(row, col);
  }
  
  
  bool isTokenFlipped(int row, int col) {
    if (_model == null) return false;
    return _model!.getTokenNumber(row, col) != null;
  }
  
  
  int get rowCount => _model?.rowCount ?? 0;
 
  int get colCount => _model?.colCount ?? 0;
  
 
//for UI:
  bool isTokenSelected(int row, int col) {
    return _selectedTokens.any((offset) => 
        offset.dx == col.toDouble() && offset.dy == row.toDouble());
  }

  bool get canConfirmTurn {
    if (_model == null || isGameDone) return false;
    return _selectedTokens.isNotEmpty;
  }

  bool get awaitingConfirmation {
    if (_model == null || isGameDone) return false;
    
    int selectedCount = _selectedTokens.length;
   
    if (selectedCount == 0) return false;
    
    MatchingModeTag detectedMode = _detectMatchingMode();
    
    
    switch (detectedMode) {
      case MatchingModeTag.regular:
        return selectedCount >= 2;
        

        //extra1 still needs to be fixed
      case MatchingModeTag.extra1:
        return selectedCount >= 3;
        
      case MatchingModeTag.extra2:
        if (selectedCount < 2) {
          return false;
        } else if (selectedCount == 2) {
          int firstRow = _selectedTokens[0].dy.toInt();
          int firstCol = _selectedTokens[0].dx.toInt();
          int secondRow = _selectedTokens[1].dy.toInt();
          int secondCol = _selectedTokens[1].dx.toInt();
          
          int? firstValue = getTokenNumber(firstRow, firstCol);
          int? secondValue = getTokenNumber(secondRow, secondCol);
          
          if (firstValue != null && secondValue != null) {
            return firstValue != secondValue;
          }
          return false;
        } else {
          return selectedCount >= 3;
        }
    }
  }
  
 
  MatchingModeTag _detectMatchingMode() {
    if (_currentMatchingMode != null) {
      return _currentMatchingMode!;
    }
    
  
    int totalCells = rowCount * colCount;
    
    
    if (totalCells % 2 == 0 && totalCells % 3 != 0) {
      return MatchingModeTag.regular;
    }
    
    
    if (totalCells % 3 == 0) {
      if (_selectedTokens.length == 2) {
        int firstRow = _selectedTokens[0].dy.toInt();
        int firstCol = _selectedTokens[0].dx.toInt();
        int secondRow = _selectedTokens[1].dy.toInt();
        int secondCol = _selectedTokens[1].dx.toInt();
        
        int? firstValue = getTokenNumber(firstRow, firstCol);
        int? secondValue = getTokenNumber(secondRow, secondCol);
        
        if (firstValue != null && secondValue != null) {
          if (firstValue == secondValue) {
            return MatchingModeTag.extra2;
          } else {
            return MatchingModeTag.extra2;
          }
        }
      }
      
      
      return MatchingModeTag.extra1;
    }
    
    return MatchingModeTag.regular;
  }
  
  
  List<Offset> get selectedTokens => List.unmodifiable(_selectedTokens);
  
  int get selectedTokenCount => _selectedTokens.length;
  
  bool get isValidGame => _model != null;
}