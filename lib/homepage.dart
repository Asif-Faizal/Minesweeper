// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:minesweeper/bomb.dart';
import 'package:minesweeper/numberedbox.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//variables
  int numberOfSquares = 9 * 9;
  int numberInEachRow = 9;
  //number of bombs around, revealed = true/false
  var squareStatus = [];
  //bomb locations
  final random = Random();
  final List<int> bombLocations = generateBombLocations();

  static List<int> generateBombLocations() {
    final random = Random();
    return List.generate(5, (_) => random.nextInt(81) + 1);
  }

  bool bombsRevealed = false;

  @override
  void restartGame() {
    setState(() {
      bombsRevealed = false;
      for (int i = 0; i < numberOfSquares; i++) {
        squareStatus[i][1] = false;
      }
    });
  }

  void initState() {
    super.initState();
    //initially, each square has 0 bombs around but not revealed, unless it is in the first coloumn
    for (int i = 0; i < numberOfSquares; i++) {
      squareStatus.add([0, false]);
    }
    scanBombs();
  }

  void revealBoxNumbers(int index) {
    if (squareStatus[index][0] != 0) {
      setState(() {
        squareStatus[index][1] = true;
      });
      //if box is 0
    } else if (squareStatus[index][0] == 0) {
      setState(() {
        squareStatus[index][1] = true;
        //reveal left box
        if (index % numberInEachRow != 0) {
          //if nxt box isn't revealed and is 0 then redo
          if (squareStatus[index - 1][0] == 0 &&
              squareStatus[index - 1][1] == false) {
            revealBoxNumbers(index - 1);
          }
          //reveal left box
          squareStatus[index - 1][1] = true;
        }
        //reveal top left box
        if (index % numberInEachRow != 0 && index >= numberInEachRow) {
          //if nxt box isn't revealed and is 0 then redo
          if (squareStatus[index - 1 - numberInEachRow][0] == 0 &&
              squareStatus[index - 1 - numberInEachRow][1] == false) {
            revealBoxNumbers(index - 1 - numberInEachRow);
          }
          //reveal top left box
          squareStatus[index - 1 - numberInEachRow][1] = true;
        }
        //reveal top box
        if (index >= numberInEachRow) {
          //if nxt box isn't revealed and is 0 then redo
          if (squareStatus[index - numberInEachRow][0] == 0 &&
              squareStatus[index - numberInEachRow][1] == false) {
            revealBoxNumbers(index - numberInEachRow);
          }
          //reveal top box
          squareStatus[index - numberInEachRow][1] = true;
        }
        //reveal top right box
        if (index >= numberInEachRow &&
            index % numberInEachRow != numberInEachRow - 1) {
          //if nxt box isn't revealed and is 0 then redo
          if (squareStatus[index + 1 - numberInEachRow][0] == 0 &&
              squareStatus[index + 1 - numberInEachRow][1] == false) {
            revealBoxNumbers(index - 1);
          }
          //reveal top right box
          squareStatus[index + 1 - numberInEachRow][1] = true;
        }
        //reveal right box
        if (index % numberInEachRow != numberInEachRow - 1) {
          //if nxt box isn't revealed and is 0 then redo
          if (squareStatus[index + 1][0] == 0 &&
              squareStatus[index + 1][1] == false) {
            revealBoxNumbers(index + 1);
          }
          //reveal right box
          squareStatus[index + 1][1] = true;
        }
        //reveal bottom right box
        if (index < numberOfSquares - numberInEachRow &&
            index % numberInEachRow != numberInEachRow - 1) {
          //if nxt box isn't revealed and is 0 then redo
          if (squareStatus[index + 1 + numberInEachRow][0] == 0 &&
              squareStatus[index + 1 + numberInEachRow][1] == false) {
            revealBoxNumbers(index + 1 + numberInEachRow);
          }
          //reveal bottom right box
          squareStatus[index + 1 + numberInEachRow][1] = true;
        }
        //reveal bottom box
        if (index < numberOfSquares - numberInEachRow) {
          //if nxt box isn't revealed and is 0 then redo
          if (squareStatus[index + numberInEachRow][0] == 0 &&
              squareStatus[index + numberInEachRow][1] == false) {
            revealBoxNumbers(index + numberInEachRow);
          }
          //reveal bottom box
          squareStatus[index + numberInEachRow][1] = true;
        }
        //reveal bottom left box
        if (index < numberOfSquares - numberInEachRow &&
            index % numberInEachRow != 0) {
          //if nxt box isn't revealed and is 0 then redo
          if (squareStatus[index - 1 + numberInEachRow][0] == 0 &&
              squareStatus[index - 1 + numberInEachRow][1] == false) {
            revealBoxNumbers(index - 1);
          }
          //reveal bottom left box
          squareStatus[index - 1 + numberInEachRow][1] = true;
        }
      });
    }
  }

  void scanBombs() {
    for (int i = 0; i < numberOfSquares; i++) {
      //there are no bombs around initially
      int numberOfBombsAround = 0;
      //chech weather bombs around it about eight surrounding boxes
      //check square to the left
      if (bombLocations.contains(i - 1) && i % numberInEachRow != 0) {
        numberOfBombsAround++;
      }
      //check square to top left
      if (bombLocations.contains(i - 1 - numberInEachRow) &&
          i % numberInEachRow != 0 &&
          i >= numberInEachRow) {
        numberOfBombsAround++;
      }
      //check square to the top
      if (bombLocations.contains(i - numberInEachRow) && i >= numberInEachRow) {
        numberOfBombsAround++;
      }
      //check square to top right
      if (bombLocations.contains(i + 1 - numberInEachRow) &&
          i >= numberInEachRow &&
          i % numberInEachRow != numberInEachRow - 1) {
        numberOfBombsAround++;
      }
      //check square to right
      if (bombLocations.contains(i + 1) &&
          i % numberInEachRow != numberInEachRow - 1) {
        numberOfBombsAround++;
      }
      //check square to bottom right
      if (bombLocations.contains(i + 1 + numberInEachRow) &&
          i % numberInEachRow != numberInEachRow - 1 &&
          i < numberOfSquares - numberInEachRow) {
        numberOfBombsAround++;
      }
      //check square to bottom
      if (bombLocations.contains(i + numberInEachRow) &&
          i < numberOfSquares - numberInEachRow) {
        numberOfBombsAround++;
      }
      //check square to bottom left
      if (bombLocations.contains(i - 1 + numberInEachRow) &&
          i < numberOfSquares - numberInEachRow &&
          i % numberInEachRow != 0) {
        numberOfBombsAround++;
      }
      //add total number of bombs around to square status
      setState(() {
        squareStatus[i][0] = numberOfBombsAround;
      });
    }
  }

  void playerLost(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.grey[700],
          title: Center(
              child: Text(
            'YOU LOST!',
            style: TextStyle(color: Colors.white),
          )),
          actions: [
            Center(
              child: MaterialButton(
                  onPressed: () {
                    restartGame();
                    Navigator.pop(context);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                        color: Colors.grey[300],
                        child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Icon(
                              Icons.refresh,
                              size: 30,
                            ))),
                  )),
            )
          ],
        );
      },
    );
  }

  void playerWon() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.grey[700],
          title: Center(
              child: Text(
            'YOU WON!',
            style: TextStyle(color: Colors.white),
          )),
          actions: [
            Center(
              child: MaterialButton(
                  onPressed: () {
                    restartGame();
                    Navigator.pop(context);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                        color: Colors.grey[300],
                        child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Icon(
                              Icons.refresh,
                              size: 30,
                            ))),
                  )),
            )
          ],
        );
      },
    );
  }

  void checkWinner() {
    int unrevealedBoxes = 0;
    for (int i = 0; i < numberOfSquares; i++) {
      if (squareStatus[i][1] == false) {
        unrevealedBoxes++;
      }
    }
    if (unrevealedBoxes == bombLocations.length) {
      playerWon();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          //game atats and menu
          Container(
            height: 150,
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      bombLocations.length.toString(),
                      style: TextStyle(fontSize: 40),
                    ),
                    Text('B O M B'),
                  ],
                ),
                GestureDetector(
                  onTap: restartGame,
                  child: Card(
                    margin: EdgeInsets.all(2),
                    child: Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                    color: Colors.grey[800],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '10',
                      style: TextStyle(fontSize: 40),
                    ),
                    Text('T I M E'),
                  ],
                )
              ],
            ),
          ),
          //grid
          Expanded(
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: numberOfSquares,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: numberInEachRow),
                  itemBuilder: (context, index) {
                    if (bombLocations.contains(index)) {
                      return MyBomb(
                        revealed: bombsRevealed,
                        function: () {
                          setState(() {
                            bombsRevealed = true;
                          });
                          playerLost(context);
                          //taps on the bomb the player losses
                        },
                      );
                    } else {
                      return MyNumberBox(
                        child: squareStatus[index][0],
                        revealed: squareStatus[index][1],
                        function: () {
                          //reveale the current box
                          revealBoxNumbers(index);
                          checkWinner();
                        },
                      );
                    }
                  }))
        ],
      ),
    );
  }
}
