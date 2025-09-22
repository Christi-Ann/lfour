import 'dart:math';
// This handles stuff related to the grid

class Token {
  final int _value;
  bool _flippedUp;

  Token({required int value}):
    _value = value,
    _flippedUp = false;

  int get value => _value;
  bool get isFlippedUp => _flippedUp;

  void flip() {
    _flippedUp = !_flippedUp;
  }
}

class MatchingMode {
  final int _R;
  final int _C;
  late List<List<Token>> _grid;
  late List<Token> _turnSelections; // List of selections during a turn
  late int _matchedFlips; // Number of tokens matched

  MatchingMode ({
    required int R,
    required int C,
    required int S,
  }):
    _R = R,
    _C = C
  {
    Random rand = Random(S);
    int n = _R * _C;
    
    if (n%2 != 0) {
      _grid = [];
    } else {
      int m = n ~/ 2;
      List<int> gridArray = [];
      for (int i = 0; i < m; i++) {
        gridArray.add(i+1);
        gridArray.add(i+1);
      }
      for (int i = 0; i < n-1; i++) {
        int k = rand.nextInt(n-i) + i;
        int tmp = gridArray[i];
        gridArray[i] = gridArray[k];
        gridArray[k] = tmp;
      }
      _grid = List.generate(
        R,
        (r) => List.generate(
          C, (c) => Token(value: gridArray[r*C + c])
        )
      );
    }
    
    _turnSelections = [];
    _matchedFlips = 0;
  }

  bool get allMatched => _matchedFlips == _R * _C;

  int get rowCount => _R;

  int get colCount => _C;

  bool isFlipped(int row, int col) {
    return _grid[row][col].isFlippedUp;
  }

  bool get tooManySelections => _turnSelections.length >= 2;

  void flip(int row, int col) {
    _grid[row][col].flip();
  }

  bool isMatch() {
    if (_turnSelections.length != 2) return false;
    
    final int base = _turnSelections[0].value;
    return _turnSelections.every((token) => token.value == base);
  }

  void addMatch() {
    _matchedFlips += 2;
  }

  int getTokenNumber(int row, int col) {
    return _grid[row][col].value;
  }

  void addSelection(int row, int col) {
    _turnSelections.add(_grid[row][col]);
  }

  void clearSelections() {
    _turnSelections = [];
  }

  void unflipSelections() {
    for (Token token in _turnSelections) {
      token.flip();
    }
  }

  bool get isInvalid => _grid.isEmpty;
}

class MatchingMode_Extra1 extends MatchingMode {

  MatchingMode_Extra1 ({
    required int R,
    required int C,
    required int S,
  }): super(R: R, C: C, S: S) 
  {
    Random rand = Random(S);
    int n = _R * _C;

    if (n%3 != 0) {
      _grid = [];
    } else {
      int m = n ~/ 3;
      List<int> gridArray = [];
      for (int i = 0; i < m; i++) {
        gridArray.add(i+1);
        gridArray.add(i+1);
        gridArray.add(i+1);
      }
      for (int i = 0; i < n-1; i++) {
        int k = rand.nextInt(n-i) + i;
        int tmp = gridArray[i];
        gridArray[i] = gridArray[k];
        gridArray[k] = tmp;
      }
      _grid = List.generate(
        R,
        (r) => List.generate(
          C, (c) => Token(value: gridArray[r*C + c])
        )
      );
    }

    _turnSelections = [];
    _matchedFlips = 0;
  }

  @override
  bool get tooManySelections => _turnSelections.length >= 3;

  @override
  bool isMatch() {
    if (_turnSelections.length != 3) return false;

    final int base = _turnSelections[0].value;
    return _turnSelections.every((token) => token.value == base);
  }

  @override
  void addMatch() {
    _matchedFlips += 3;
  }
}

class MatchingMode_Extra2 extends MatchingMode_Extra1 {
  
  MatchingMode_Extra2 ({
    required int R,
    required int C,
    required int S
  }): super(R: R, C: C, S: S);

  @override
  bool get tooManySelections => 
    (_turnSelections.length < 2) ? false :
    (_turnSelections.length == 2 && _turnSelections[0].value == _turnSelections[1].value) ? false :
    true;
}