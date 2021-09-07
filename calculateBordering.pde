int[][] calculateBordering(boolean[][] board) {
  int[][] bordering = new int[board.length][board[0].length];
  for (int i=0; i<board.length; i++) {
    for (int j = 0; j<board[0].length; j++) {
      if (board[i][j]) {
        // square is a mine
        bordering[i][j] = -1;
      } else {
        // square may be adjacent to mines, check neighbours
        int numberBordering = 0;
        for (int k = -1; k < 2; k++) {
          for (int l = -1; l<2; l++) {
            // if neighbour is inside board and is a mine, add to numberBordering
            if (i+k >= 0 && i+k < board.length && j+l >= 0 && j+l < board[0].length) {
              if (board[i+k][j+l]) numberBordering++;
            }
          }
        }
        bordering[i][j] = numberBordering;
      }
    }
  }
  return bordering;
}
