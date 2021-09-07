int resolutionX = 25;
int resolutionY = 25;
int num_mines = 80;
int num_uncovered = 0;
boolean firstClick = true;
boolean[][] board;
boolean[][] boardUncovered = new boolean[resolutionX][resolutionY];
boolean[][] boardFlagged = new boolean[resolutionX][resolutionY];
int[][] boardNeighbours;
int squareSize = 25;

boolean gameWon = false;
boolean gameLost = false;

//AI variables
boolean AI_active = false;


void settings() {
  size(resolutionX*squareSize, resolutionY*squareSize);
}
void setup() {
  board = setupBoard(resolutionX, resolutionY, board, num_mines, 0, 0, 0);
  boardNeighbours = calculateBordering(board);
}


void draw() {
  if (AI_active) AI_iteration();
  drawBoard(boardNeighbours, boardUncovered, boardFlagged);
  if (gameWon && !gameLost) {
    fill(2, 227, 21, 128);
    rectMode(CORNERS);
    rect(0, 0, width, height);
    textAlign(CENTER, CENTER);
    fill(0);
    textSize(50);
    text("You win!", width/2, height/2-20);
    textSize(20);
    fill(30);
    text("Click a mine to restart", width/2, height/2+20);
  }
  if (gameLost) {
    fill(227, 40, 2, 128);
    rectMode(CORNERS);
    rect(0, 0, width, height);
    textAlign(CENTER, CENTER);
    fill(0);
    textSize(50);
    text("You lose :(", width/2, height/2-20);
    textSize(20);
    fill(30);
    text("Click a mine to restart", width/2, height/2+20);
  }
}
