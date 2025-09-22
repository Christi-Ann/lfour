import 'package:flutter_test/flutter_test.dart';
import 'package:cs150lab04/common_types.dart';
import 'package:cs150lab04/model.dart';
import 'package:cs150lab04/matching_mode.dart';
import 'package:cs150lab04/turn_order.dart';
import 'package:cs150lab04/tester.dart';
// flutter test --coverage && genhtml coverage/lcov.info -o coverage/html
void main() {
  test("Constructor", () {
    ModifiedMemoryGameModel? model = make(3, 4, 150, MatchingModeTag.regular, TurnOrderTag.roundRobin);
    expect(model, isNotNull);
    model!;

    expect(model.currentPlayer, Player.p1);
    expect(model.score(Player.p1), 0);
    expect(model.score(Player.p2), 0);
    expect(model.winner, null);
    expect(model.isGameDone, false);
    expect(model.rowCount, 3);
    expect(model.colCount, 4);

    List<List<int>> expected_tokens = [
      [6, 4, 5, 4],
      [3, 2, 3, 1],
      [6, 2, 5, 1]
    ];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 4; j++) {
        expect(model.getTokenNumber(i, j), null);
        expect(model.selectToken(i, j), true);
        expect(model.getTokenNumber(i, j), expected_tokens[i][j]);
        model.confirmTurnEnd();
      }
    }
  });

  test("Invalid Regular Grid", () {
    ModifiedMemoryGameModel? model = make(5, 5, 150, MatchingModeTag.regular, TurnOrderTag.roundRobin);
    expect(model, null);

    MatchingMode gridHandler = MatchingMode(R: 5, C: 5, S: 150);
    TurnOrder playerHandler = TurnOrder();
    expect(
      () => ModifiedMemoryGameModel(playerHandler: playerHandler, gridHandler: gridHandler),
      throwsA(equals("Invalid grid"))
    );
  });

  test("Invalid Extra Grid", () {
    ModifiedMemoryGameModel? model = make(2, 2, 150, MatchingModeTag.extra1, TurnOrderTag.roundRobin);
    expect(model, null);

    MatchingMode gridHandler = MatchingMode_Extra1(R: 2, C: 2, S: 150);
    TurnOrder playerHandler = TurnOrder();
    expect(
      () => ModifiedMemoryGameModel(playerHandler: playerHandler, gridHandler: gridHandler),
      throwsA(equals("Invalid grid"))
    );
  });


  test("TurnOrder - RoundRobin - next player if matched", () {
    ModifiedMemoryGameModel? model = make(3, 4, 150, MatchingModeTag.regular, TurnOrderTag.roundRobin);
    List<List<int>> expected_tokens = [
      [6, 4, 5, 4],
      [3, 2, 3, 1],
      [6, 2, 5, 1]
    ];
    expect(model, isNotNull);
    model!;

    expect(model.selectToken(2, 3), true);
    expect(model.currentPlayer, Player.p1);
    expect(model.confirmTurnEnd(), false);
    expect(model.currentPlayer, Player.p1);
    expect(model.score(Player.p1), 0);
    expect(model.winner, null);
    
    expect(model.selectToken(1, 3), true);
    expect(model.currentPlayer, Player.p1);
    expect(model.selectToken(1, 1), false);
    expect(model.confirmTurnEnd(), true);
    expect(model.currentPlayer, Player.p2);
    expect(model.score(Player.p1), 1);
    expect(model.winner, null);
  });

  test("TurnOrder - RoundRobin - next player if not matched", () {
    ModifiedMemoryGameModel? model = make(3, 4, 150, MatchingModeTag.regular, TurnOrderTag.roundRobin);
    List<List<int>> expected_tokens = [
      [6, 4, 5, 4],
      [3, 2, 3, 1],
      [6, 2, 5, 1]
    ];
    expect(model, isNotNull);
    model!;

    expect(model.selectToken(2, 3), true);
    expect(model.currentPlayer, Player.p1);
    expect(model.confirmTurnEnd(), false);
    expect(model.currentPlayer, Player.p1);
    expect(model.score(Player.p1), 0);
    expect(model.winner, null);
    
    expect(model.selectToken(0, 0), true);
    expect(model.currentPlayer, Player.p1);
    expect(model.selectToken(1, 1), false);
    expect(model.confirmTurnEnd(), true);
    expect(model.currentPlayer, Player.p2);
    expect(model.score(Player.p1), 0);
    expect(model.winner, null);
  });

  test("TurnOrder - UntilIncorrect - not next player if matched", () {
    ModifiedMemoryGameModel? model = make(3, 4, 150, MatchingModeTag.regular, TurnOrderTag.untilIncorrect);
    List<List<int>> expected_tokens = [
      [6, 4, 5, 4],
      [3, 2, 3, 1],
      [6, 2, 5, 1]
    ];
    expect(model, isNotNull);
    model!;

    expect(model.selectToken(2, 3), true);
    expect(model.currentPlayer, Player.p1);
    expect(model.confirmTurnEnd(), false);
    expect(model.currentPlayer, Player.p1);
    expect(model.score(Player.p1), 0);
    expect(model.winner, null);
    
    expect(model.selectToken(1, 3), true);
    expect(model.currentPlayer, Player.p1);
    expect(model.selectToken(1, 1), false);
    expect(model.confirmTurnEnd(), true);
    expect(model.currentPlayer, Player.p1);
    expect(model.score(Player.p1), 1);
    expect(model.winner, null);
  });

  test("TurnOrder - UntilIncorrect - next player if not matched", () {
    ModifiedMemoryGameModel? model = make(3, 4, 150, MatchingModeTag.regular, TurnOrderTag.untilIncorrect);
    List<List<int>> expected_tokens = [
      [6, 4, 5, 4],
      [3, 2, 3, 1],
      [6, 2, 5, 1]
    ];
    expect(model, isNotNull);
    model!;

    expect(model.selectToken(2, 3), true);
    expect(model.currentPlayer, Player.p1);
    expect(model.confirmTurnEnd(), false);
    expect(model.currentPlayer, Player.p1);
    expect(model.score(Player.p1), 0);
    expect(model.winner, null);
    
    expect(model.selectToken(0, 0), true);
    expect(model.currentPlayer, Player.p1);
    expect(model.selectToken(1, 1), false);
    expect(model.confirmTurnEnd(), true);
    expect(model.currentPlayer, Player.p2);
    expect(model.score(Player.p1), 0);
    expect(model.winner, null);
  });

  test("Winner", () {
    ModifiedMemoryGameModel? model = make(2, 3, 150, MatchingModeTag.regular, TurnOrderTag.roundRobin);
    List<List<int>> expected_tokens = [
      [3, 1, 1],
      [2, 2, 3]
    ];
    expect(model, isNotNull);
    model!;

    expect(model.selectToken(0, 1), true);
    expect(model.selectToken(0, 2), true);
    expect(model.score(Player.p1), 1);
    expect(model.score(Player.p2), 0);
    expect(model.confirmTurnEnd(), true);

    
    expect(model.selectToken(1, 0), true);
    expect(model.selectToken(1, 1), true);
    expect(model.score(Player.p1), 1);
    expect(model.score(Player.p2), 1);
    expect(model.confirmTurnEnd(), true);


    expect(model.selectToken(0, 0), true);
    expect(model.selectToken(1, 2), true);
    expect(model.score(Player.p1), 2);
    expect(model.score(Player.p2), 1);
    expect(model.confirmTurnEnd(), true);
    
    expect(model.isGameDone, true);
    expect(model.winner, Player.p1);
    expect(model.selectToken(0, 0), false);
  });

  test("selecting out of bounds", () {
    ModifiedMemoryGameModel? model = make(3, 4, 150, MatchingModeTag.regular, TurnOrderTag.roundRobin);
    List<List<int>> expected_tokens = [
      [6, 4, 5, 4],
      [3, 2, 3, 1],
      [6, 2, 5, 1]
    ];
    expect(model, isNotNull);
    model!;

    expect(model.selectToken(100, 100), false);
  });

  test("MatchingMode - Regular - matching turn", () {
    ModifiedMemoryGameModel? model = make(3, 4, 150, MatchingModeTag.regular, TurnOrderTag.roundRobin);
    List<List<int>> expected_tokens = [
      [6, 4, 5, 4],
      [3, 2, 3, 1],
      [6, 2, 5, 1]
    ];
    expect(model, isNotNull);
    model!;

    expect(model.getTokenNumber(2, 3), null);
    expect(model.selectToken(2, 3), true);
    expect(model.getTokenNumber(2, 3), 1);
    expect(model.confirmTurnEnd(), false);
    expect(model.selectToken(2, 3), false);
    expect(model.confirmTurnEnd(), false);

    expect(model.getTokenNumber(1, 3), null);
    expect(model.selectToken(1, 3), true);
    expect(model.getTokenNumber(1, 3), 1);
    expect(model.selectToken(0, 0), false);
    expect(model.confirmTurnEnd(), true);
    expect(model.getTokenNumber(2, 3), 1);
    expect(model.getTokenNumber(1, 3), 1);

    expect(model.score(Player.p1), 1);
  });

  test("MatchingMode - Regular - non-matching turn", () {
    ModifiedMemoryGameModel? model = make(3, 4, 150, MatchingModeTag.regular, TurnOrderTag.roundRobin);
    List<List<int>> expected_tokens = [
      [6, 4, 5, 4],
      [3, 2, 3, 1],
      [6, 2, 5, 1]
    ];
    expect(model, isNotNull);
    model!;

    expect(model.getTokenNumber(2, 3), null);
    expect(model.selectToken(2, 3), true);
    expect(model.getTokenNumber(2, 3), 1);
    expect(model.confirmTurnEnd(), false);
    expect(model.selectToken(2, 3), false);
    expect(model.confirmTurnEnd(), false);

    expect(model.getTokenNumber(0, 3), null);
    expect(model.selectToken(0, 3), true);
    expect(model.getTokenNumber(0, 3), 4);
    expect(model.selectToken(0, 0), false);
    expect(model.confirmTurnEnd(), true);
    expect(model.getTokenNumber(2, 3), null);
    expect(model.getTokenNumber(0, 3), null);

    expect(model.score(Player.p1), 0);
  });

  test("MatchingMode - Extra1 - matching turn", (){
    ModifiedMemoryGameModel? model = make(3, 4, 150, MatchingModeTag.extra1, TurnOrderTag.roundRobin);
    List<List<int>> expected_tokens = [
      [4, 3, 3, 3],
      [2, 1, 2, 1],
      [4, 2, 4, 1]
    ];
    expect(model, isNotNull);
    model!;

    expect(model.getTokenNumber(2, 3), null);
    expect(model.selectToken(2, 3), true);
    expect(model.getTokenNumber(2, 3), 1);
    expect(model.confirmTurnEnd(), false);
    expect(model.selectToken(2, 3), false);
    expect(model.confirmTurnEnd(), false);

    expect(model.getTokenNumber(1, 3), null);
    expect(model.selectToken(1, 3), true);
    expect(model.getTokenNumber(1, 3), 1);
    expect(model.selectToken(2, 3), false);
    expect(model.selectToken(1, 3), false);
    expect(model.confirmTurnEnd(), false);

    expect(model.getTokenNumber(2, 3), 1);
    expect(model.getTokenNumber(1, 3), 1);

    expect(model.getTokenNumber(1, 1), null);
    expect(model.selectToken(1, 1), true);
    expect(model.getTokenNumber(1, 1), 1);
    expect(model.selectToken(2, 3), false);
    expect(model.selectToken(1, 3), false);
    expect(model.selectToken(1, 1), false);
    expect(model.selectToken(0, 0), false);
    expect(model.confirmTurnEnd(), true);

    expect(model.getTokenNumber(2, 3), 1);
    expect(model.getTokenNumber(1, 3), 1);
    expect(model.getTokenNumber(1, 1), 1);

    expect(model.score(Player.p1), 1);
  });

  test("MatchingMode - Extra1 - non-matching turn", (){
    ModifiedMemoryGameModel? model = make(3, 4, 150, MatchingModeTag.extra1, TurnOrderTag.roundRobin);
    List<List<int>> expected_tokens = [
      [4, 3, 3, 3],
      [2, 1, 2, 1],
      [4, 2, 4, 1]
    ];
    expect(model, isNotNull);
    model!;

    expect(model.getTokenNumber(2, 3), null);
    expect(model.selectToken(2, 3), true);
    expect(model.getTokenNumber(2, 3), 1);
    expect(model.confirmTurnEnd(), false);
    expect(model.selectToken(2, 3), false);
    expect(model.confirmTurnEnd(), false);

    expect(model.getTokenNumber(1, 3), null);
    expect(model.selectToken(1, 3), true);
    expect(model.getTokenNumber(1, 3), 1);
    expect(model.selectToken(2, 3), false);
    expect(model.selectToken(1, 3), false);
    expect(model.confirmTurnEnd(), false);

    expect(model.getTokenNumber(2, 3), 1);
    expect(model.getTokenNumber(1, 3), 1);

    expect(model.getTokenNumber(0, 0), null);
    expect(model.selectToken(0, 0), true);
    expect(model.getTokenNumber(0, 0), 4);
    expect(model.selectToken(2, 3), false);
    expect(model.selectToken(1, 3), false);
    expect(model.selectToken(0, 0), false);
    expect(model.selectToken(1, 1), false);
    expect(model.confirmTurnEnd(), true);

    expect(model.getTokenNumber(2, 3), null);
    expect(model.getTokenNumber(1, 3), null);
    expect(model.getTokenNumber(1, 1), null);

    expect(model.score(Player.p1), 0);
  });

  test("MatchingMode - Extra1 - matching turn", (){
    ModifiedMemoryGameModel? model = make(3, 4, 150, MatchingModeTag.extra2, TurnOrderTag.roundRobin);
    List<List<int>> expected_tokens = [
      [4, 3, 3, 3],
      [2, 1, 2, 1],
      [4, 2, 4, 1]
    ];
    expect(model, isNotNull);
    model!;

    expect(model.getTokenNumber(2, 3), null);
    expect(model.selectToken(2, 3), true);
    expect(model.getTokenNumber(2, 3), 1);
    expect(model.confirmTurnEnd(), false);
    expect(model.selectToken(2, 3), false);
    expect(model.confirmTurnEnd(), false);

    expect(model.getTokenNumber(1, 3), null);
    expect(model.selectToken(1, 3), true);
    expect(model.getTokenNumber(1, 3), 1);
    expect(model.selectToken(2, 3), false);
    expect(model.selectToken(1, 3), false);
    expect(model.confirmTurnEnd(), false);

    expect(model.getTokenNumber(2, 3), 1);
    expect(model.getTokenNumber(1, 3), 1);

    expect(model.getTokenNumber(1, 1), null);
    expect(model.selectToken(1, 1), true);
    expect(model.getTokenNumber(1, 1), 1);
    expect(model.selectToken(2, 3), false);
    expect(model.selectToken(1, 3), false);
    expect(model.selectToken(1, 1), false);
    expect(model.selectToken(0, 0), false);
    expect(model.confirmTurnEnd(), true);

    expect(model.getTokenNumber(2, 3), 1);
    expect(model.getTokenNumber(1, 3), 1);
    expect(model.getTokenNumber(1, 1), 1);

    expect(model.score(Player.p1), 1);
  });

  test("MatchingMode - Extra2 - non-matching turn on three selections", (){
    ModifiedMemoryGameModel? model = make(3, 4, 150, MatchingModeTag.extra2, TurnOrderTag.roundRobin);
    List<List<int>> expected_tokens = [
      [4, 3, 3, 3],
      [2, 1, 2, 1],
      [4, 2, 4, 1]
    ];
    expect(model, isNotNull);
    model!;

    expect(model.getTokenNumber(2, 3), null);
    expect(model.selectToken(2, 3), true);
    expect(model.getTokenNumber(2, 3), 1);
    expect(model.confirmTurnEnd(), false);
    expect(model.selectToken(2, 3), false);
    expect(model.confirmTurnEnd(), false);

    expect(model.getTokenNumber(1, 3), null);
    expect(model.selectToken(1, 3), true);
    expect(model.getTokenNumber(1, 3), 1);
    expect(model.selectToken(2, 3), false);
    expect(model.selectToken(1, 3), false);
    expect(model.confirmTurnEnd(), false);

    expect(model.getTokenNumber(2, 3), 1);
    expect(model.getTokenNumber(1, 3), 1);

    expect(model.getTokenNumber(0, 0), null);
    expect(model.selectToken(0, 0), true);
    expect(model.getTokenNumber(0, 0), 4);
    expect(model.selectToken(2, 3), false);
    expect(model.selectToken(1, 3), false);
    expect(model.selectToken(0, 0), false);
    expect(model.selectToken(1, 1), false);
    expect(model.confirmTurnEnd(), true);

    expect(model.getTokenNumber(2, 3), null);
    expect(model.getTokenNumber(1, 3), null);
    expect(model.getTokenNumber(1, 1), null);

    expect(model.score(Player.p1), 0);
  });  

  test("MatchingMode - Extra2 - non-matching turn on two selections", () {
    ModifiedMemoryGameModel? model = make(3, 4, 150, MatchingModeTag.extra2, TurnOrderTag.roundRobin);
    List<List<int>> expected_tokens = [
      [4, 3, 3, 3],
      [2, 1, 2, 1],
      [4, 2, 4, 1]
    ];
    expect(model, isNotNull);
    model!;

    expect(model.getTokenNumber(2, 3), null);
    expect(model.selectToken(2, 3), true);
    expect(model.getTokenNumber(2, 3), 1);
    expect(model.confirmTurnEnd(), false);
    expect(model.selectToken(2, 3), false);
    expect(model.confirmTurnEnd(), false);

    expect(model.getTokenNumber(0, 3), null);
    expect(model.selectToken(0, 3), true);
    expect(model.getTokenNumber(0, 3), 3);
    expect(model.selectToken(0, 0), false);
    expect(model.confirmTurnEnd(), true);

    expect(model.getTokenNumber(2, 3), null);
    expect(model.getTokenNumber(1, 3), null);

    expect(model.score(Player.p1), 0);
  });
}