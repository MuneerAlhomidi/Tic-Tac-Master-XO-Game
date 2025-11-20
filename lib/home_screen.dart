import 'package:flutter/material.dart';
import 'package:tic_tac_to/game_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSwitched = false;
  bool gameOver = false;
  String _activePlayer = '';
  int turn = 0;
  String result = '';
  Game game = Game();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait
            ? Column(children: [...firstBlock(), expanded(), ...lastBlock()])
            : Row(
                children: [
                  Expanded(
                    
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [...firstBlock(),const SizedBox(height: 30,), ...lastBlock()],
                    ),
                  ),
                   expanded(),
                ],
              ),
      ),
    );
  }

  List<Widget> lastBlock() {
    return [
      Text(
        result,
        style: const TextStyle(color: Colors.white, fontSize: 42),
        textAlign: TextAlign.center,
      ),
       const SizedBox(height: 30,),
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            resetGame();
          });
        },
        icon: const Icon(Icons.replay),
        label: const Text('Repeat the game'),
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            Theme.of(context).splashColor,
          ),
        ),
      ),
    ];
  }

  List<Widget> firstBlock() {
    return [
      SwitchListTile.adaptive(
        title: const Text(
          'Turn on/off Tow Player',
          style: TextStyle(color: Colors.white, fontSize: 28),
          textAlign: TextAlign.center,
        ),
        value: isSwitched,
        onChanged: (bool value) {
          setState(() {
            isSwitched = value;
          });
        },
      ),
      Text(
        "It's $_activePlayer turn".toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 42),
        textAlign: TextAlign.center,
      ),
    ];
  }

  Expanded expanded() {
    return Expanded(
      child: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 1.2,
        children: List.generate(
          9,
          (index) => InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: gameOver ? null : () => onTap(index, context),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).shadowColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                Player.playerX.contains(index)
                    ? 'X'
                    : Player.playerO.contains(index)
                    ? 'O'
                    : '',

                style: TextStyle(
                  color: Player.playerX.contains(index)
                      ? Colors.blue
                      : Colors.pink,
                  fontSize: 52,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void resetGame() {
    Player.playerO.clear();
    Player.playerX.clear();
    _activePlayer = 'X';
    turn = 0;
    result = '';
    gameOver = false;
  }

  void onTap(int index, BuildContext context) {
    if (gameOver) return;
    if (!Player.playerX.contains(index) && !Player.playerO.contains(index)) {
      game.playGame(index, _activePlayer);
      updateState(context);

      if (!isSwitched && !gameOver && turn != 8) {
        Future.delayed(const Duration(milliseconds: 300), () async {
          await game.autoPlayers(_activePlayer);
          if (!mounted) return;
          updateState(context);
        });
      }
    }
  }

  void updateState(BuildContext context) {
    return setState(() {
      String winnerPlayer = game.checkWinner();
      if (winnerPlayer != '') {
        gameOver = true;

        result = '$winnerPlayer Is The winner';
        showEndDialog(context, result);
      } else if (turn == 8) {
        gameOver = true;
        result = 'It\'s Drawer';
        showEndDialog(context, result);
      } else {
        turn++;
        _activePlayer = _activePlayer == 'X' ? 'O' : 'X';
      }
    });
  }

  void showEndDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Game Over'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                resetGame();
              });
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }
}
