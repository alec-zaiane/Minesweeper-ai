void uncoverTile(int xpos, int ypos) {
  if (firstClick) {
    // if this is the first click of the game, make sure the click is on a tile with 0 neighbouring mines
    println("generating");
    board = setupBoard(resolutionX, resolutionY, board, num_mines, xpos, ypos, 2);
    boardNeighbours = calculateBordering(board);
    println("generated");
    firstClick = false;
  }
  if (boardFlagged[xpos][ypos] && !gameLost && !gameWon) return;
  //lose condition
  if (board[xpos][ypos] == true) {
    if (gameLost == true || gameWon == true) {
      // TODO reset game
      println("resetting game");
      return;
    }
    gameLost = true;
  }
  if (!boardUncovered[xpos][ypos]) num_uncovered++;
  boardUncovered[xpos][ypos] = true;
  if (boardNeighbours[xpos][ypos] == 0) {
    // no neighbours means uncover every neighbour (since its impossible to be a mine)
    for (int i=-1; i<2; i++) {
      for (int j = -1; j<2; j++) {
        if (xpos+i >= 0 && xpos+i < boardUncovered.length && ypos+j >= 0 && ypos+j < boardUncovered[0].length) {
          if (!boardUncovered[xpos+i][ypos+j]) {
            uncoverTile(xpos+i, ypos+j);
          }
        }
      }
    }
  }
  // win condition
  if (resolutionX * resolutionY == num_mines + num_uncovered) {
    gameWon = true;
  }
}

void flagTile(int xpos, int ypos) {
  if (!boardUncovered[xpos][ypos]) boardFlagged[xpos][ypos] = !boardFlagged[xpos][ypos];
}
