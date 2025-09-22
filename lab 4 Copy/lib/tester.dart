import 'model.dart';
import 'common_types.dart';
import 'matching_mode.dart';
import 'turn_order.dart';

ModifiedMemoryGameModel? make(int r, int c, int s, MatchingModeTag matchingModeTag, TurnOrderTag turnOrderTag) {
    
    TurnOrder playerHandler;
    switch (turnOrderTag) {
        case (TurnOrderTag.roundRobin):
            playerHandler = TurnOrder();
        case (TurnOrderTag.untilIncorrect):
            playerHandler = TurnOrder_UntilIncorrect();
    }

    MatchingMode gridHandler;
    switch (matchingModeTag) {
        case (MatchingModeTag.regular):
            gridHandler = MatchingMode(R: r, C: c, S: s);
        case (MatchingModeTag.extra1):
            gridHandler = MatchingMode_Extra1(R: r, C: c, S: s);
        case (MatchingModeTag.extra2):
            gridHandler = MatchingMode_Extra2(R: r, C: c, S: s);
    }

    if (gridHandler.isInvalid) return null;

    ModifiedMemoryGameModel model = ModifiedMemoryGameModel(playerHandler: playerHandler, gridHandler: gridHandler);
    return model;
}