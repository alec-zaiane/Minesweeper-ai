boolean[][] setupBoard(int resX, int resY, boolean[][]board, int numMines, int pingX, int pingY, int pingRad){
  board = new boolean[resX][resY];
  for(int i = 0; i<numMines; i++){
    int randX = int(random(0,resX));
    int randY = int(random(0,resY));
    if(board[randX][randY] == true || dist(randX,randY,pingX,pingY) < pingRad){
      i--;
    }else{
      board[randX][randY] = true;
    }
  }
  return board;
}
