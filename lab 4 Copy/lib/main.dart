import 'package:flutter/material.dart';
import 'package:cs150lab04/common_types.dart';
import 'package:cs150lab04/model.dart';
import 'package:cs150lab04/controller.dart';
import 'package:cs150lab04/view.dart';
import 'package:cs150lab04/tester.dart';

// flutter run -a <R> -a <C> -a <S> -a <matching-mode> -a <turn-order>

void main(List<String> args) {
  if (args.length != 5) return;
  
  int R = int.parse(args[0]);
  int C = int.parse(args[1]);
  int S = int.parse(args[2]);
  String matching_mode = args[3];
  String turn_order = args[4];

  MatchingModeTag matchingModeTag;
  switch (matching_mode) {
    case ('regular'):
      matchingModeTag = MatchingModeTag.regular;
    case ('extra1'):
      matchingModeTag = MatchingModeTag.extra1;
    case('extra2'):
      matchingModeTag = MatchingModeTag.extra2;
    default:
      return;
  }

  TurnOrderTag turnOrderTag;
  switch (turn_order) {
    case ('roundrobin'):
      turnOrderTag = TurnOrderTag.roundRobin;
    case ('untilincorrect'):
      turnOrderTag = TurnOrderTag.untilIncorrect;
    default:
      return;
  }

  ModifiedMemoryGameModel? model = make(R, C, S, matchingModeTag, turnOrderTag);
  if (model == null) return;

  // initialize game controller with the model
  final controller = GameController(model);

  // run app
  runApp(ModifiedMemoryGameApp(controller: controller));
}
