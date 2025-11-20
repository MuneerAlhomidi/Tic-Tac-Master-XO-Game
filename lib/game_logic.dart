import 'dart:math';

class Player {
  static const x = 'X';
  static const o = 'O';

  static List<int> playerX = [];
  static List<int> playerO = [];
}

class Game {
  List<List<int>> winnerCombinations = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];
  playGame(int index, String activePlayer) {
    if (activePlayer == 'X') {
      Player.playerX.add(index);
    } else {
      Player.playerO.add(index);
    }
  }

  checkWinner() {
    String winner = '';

    for (var combo in winnerCombinations) {
      bool xWins = combo.every((i) => Player.playerX.contains(i));
      bool oWins = combo.every((i) => Player.playerO.contains(i));

      if (xWins) {
        winner = 'X';
      } else if (oWins) {
        winner = 'O';
      }
    }

    return winner;
  }

  Future<void> autoPlayers(String activePlayer) async {
    // ------------- 1-------------
    List<int> myCells = (activePlayer == 'X') ? Player.playerX : Player.playerO;
    List<int> oppCells = (activePlayer == 'X')
        ? Player.playerO
        : Player.playerX;

    // ------------- 2.  -------------
    List<int> emptyCells = [];
    for (int i = 0; i < 9; i++) {
      if (!Player.playerX.contains(i) && !Player.playerO.contains(i)) {
        emptyCells.add(i);
      }
    }

    // ---------------------  ---------------------
    Future<bool> tryToPlay(int index) async {
      if (emptyCells.contains(index)) {
        await playGame(index, activePlayer);
        return true;
      }
      return false;
    }

    // ------------- -------------
    for (var combo in winnerCombinations) {
      int count = combo.where((i) => myCells.contains(i)).length;
      int empty = combo.where((i) => emptyCells.contains(i)).length;

      if (count == 2 && empty == 1) {
        int playIndex = combo.firstWhere((i) => emptyCells.contains(i));
        await tryToPlay(playIndex);
        return;
      }
    }

    // ------------- 4 -------------
    for (var combo in winnerCombinations) {
      int count = combo.where((i) => oppCells.contains(i)).length;
      int empty = combo.where((i) => emptyCells.contains(i)).length;

      if (count == 2 && empty == 1) {
        int playIndex = combo.firstWhere((i) => emptyCells.contains(i));
        await tryToPlay(playIndex);
        return;
      }
    }

    // ------------- 5.  -------------
    if (await tryToPlay(4)) return;

    // ------------- 6.  -------------
    List<int> corners = [0, 2, 6, 8];

    for (int corner in corners) {
      if (await tryToPlay(corner)) return;
    }

    // ------------- 7.-------------
    if (emptyCells.isNotEmpty) {
      Random rnd = Random();
      int randomIndex = emptyCells[rnd.nextInt(emptyCells.length)];
      await tryToPlay(randomIndex);
    }
  }
}

extension ContainAll on List<int> {
  bool containAll(int i, int y, [z]) {
    if (z == null) {
      return contains(i) && contains(y);
    } else {
      return contains(i) && contains(y) && contains(z);
    }
  }
}
