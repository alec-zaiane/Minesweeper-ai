void AI_iteration() {
  // if on first click, uncover the center tile
  if (firstClick) {
    uncoverTile(resolutionX/2, resolutionY/2);
  }
  // make a list of every uncovered tile
  // structure of int[] is {xpos,ypos,number of uncovered neighbours, number of flagged neighbours}
  ArrayList<int[]> tiles = new ArrayList<int[]>();
  for (int i=0; i<resolutionX; i++) {
    for (int j=0; j<resolutionY; j++) {
      int[] tile = {i, j, 0};
      if (boardUncovered[i][j]) tiles.add(tile);
    }
  }
  // find states of neighbours for each tile on the list
  for (int i=0; i<tiles.size(); i++) {
    for (int j=-1; j<2; j++) {
      for (int k = -1; k<2; k++) {
        ;
      }
    }
  }

  /* iterate through list,
   flag neighbours if theyre guaranteed to be mines
   uncover them if theyre guaraneed to be clear
   */
}
