import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller.dart';
import 'common_types.dart';

class ModifiedMemoryGameApp extends StatelessWidget {
  final GameController controller;
  
  const ModifiedMemoryGameApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: MaterialApp(
        title: 'Modified Memory Game',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const GameView(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modified Memory Game'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<GameController>(
        builder: (context, controller, child) {
          if (controller.model == null) {
            return const Center(
              child: Text(
                'Invalid game configuration',
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
            );
          }
          
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                _buildScoreBoard(controller),
                const SizedBox(height: 10),
                _buildCurrentPlayerInfo(controller),
                const SizedBox(height: 20),
                _buildGameGrid(controller),
                const SizedBox(height: 20),
                _buildActionButtons(controller),
                _buildGameStatus(controller),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildScoreBoard(GameController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'Player 1: ${controller.getScore(Player.p1) ?? 0}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          'Player 2: ${controller.getScore(Player.p2) ?? 0}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildCurrentPlayerInfo(GameController controller) {
    if (controller.isGameDone) {
      return Container();
    }
    
    String playerName = controller.currentPlayer == Player.p1 ? 'Player 1' : 'Player 2';
    
    return Text(
      'Current Turn: $playerName',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildGameGrid(GameController controller) {
    return Center(
      child: Container(
        width: 300,
        height: 300,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: controller.colCount,
            childAspectRatio: 1.0,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: controller.rowCount * controller.colCount,
          itemBuilder: (context, index) {
            int row = index ~/ controller.colCount;
            int col = index % controller.colCount;
            return _buildToken(controller, row, col);
          },
        ),
      ),
    );
  }

  Widget _buildToken(GameController controller, int row, int col) {
    bool isFlipped = controller.isTokenFlipped(row, col);
    bool isSelected = controller.isTokenSelected(row, col);
    int? tokenNumber = controller.getTokenNumber(row, col);
    
    Color backgroundColor;
    String displayText;
    
    if (isFlipped) {
      backgroundColor = isSelected ? Colors.orange : Colors.yellow;
      displayText = tokenNumber?.toString() ?? '';
    } else {
      backgroundColor = Colors.grey;
      displayText = '';
    }
    
    return GestureDetector(
      onTap: () {
        if (!controller.isGameDone) {
          controller.selectToken(row, col);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            displayText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(GameController controller) {
    if (controller.isGameDone) {
      return Container();
    }
    
    // Only show the confirm button when the player is ready to confirm their turn
    if (!controller.awaitingConfirmation) {
      return Container();
    }
    
    return ElevatedButton(
      onPressed: () {
        controller.confirmTurnEnd();
      },
      child: const Text('Confirm Turn'),
    );
  }

  Widget _buildGameStatus(GameController controller) {
    if (!controller.isGameDone) {
      return Container();
    }
    
    Player? winner = controller.winner;
    String statusText;
    
    if (winner != null) {
      String winnerName = winner == Player.p1 ? 'Player 1' : 'Player 2';
      statusText = '$winnerName wins!';
    } else {
      statusText = 'Draw';
    }
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        statusText,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}