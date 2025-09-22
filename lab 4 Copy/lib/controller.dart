import 'package:flutter/material.dart';
import 'model.dart';
import 'common_types.dart';

class GameController extends ChangeNotifier {
  ModifiedMemoryGameModel? _model;
  
  ModifiedMemoryGameModel? get model => _model;
  
  // Constructor that takes a model as parameter
  GameController(ModifiedMemoryGameModel model) {
    _model = model;
    print('Controller: initialized with provided model');
    print('Controller: model is null? ${_model == null}');
    if (_model != null) {
      print('Controller: model grid size ${_model!.rowCount}x${_model!.colCount}');
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