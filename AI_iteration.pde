void AI_iteration() {
  boolean changes_made = false;
  AI_sum_probs_mode = false;
  // if on first click, uncover the center tile
  if (firstClick) {
    uncoverTile(resolutionX/2, resolutionY/2);
  }
  // make a list of every uncovered tile
  // structure of int[] is {xpos,ypos,number of uncovered neighbours, number of flagged neighbours}
  ArrayList<int[]> tiles = new ArrayList<int[]>();
  for (int i=0; i<resolutionX; i++) {
    for (int j=0; j<resolutionY; j++) {
      int[] tile = {i, j, 0, 0};
      if (boardUncovered[i][j]) tiles.add(tile);
    }
  }
  // find states of neighbours for each tile on the list
  for (int i=0; i<tiles.size(); i++) {
    int[] tile = tiles.get(i);
    int numUncovered = -1; // offset for counting itself as a neighbour
    int numFlagged = 0;
    for (int j=-1; j<2; j++) {
      for (int k = -1; k<2; k++) {
        if (tile[0]+j >= 0 && tile[0]+j < resolutionX && tile[1]+k >= 0 && tile[1]+k < resolutionY) {
          if (boardUncovered[tile[0]+j][tile[1]+k]) numUncovered++;
          if (boardFlagged[tile[0]+j][tile[1]+k]) numFlagged++;
        }
      }
    }
    tile[2] = numUncovered;
    tile[3] = numFlagged;
    tiles.set(i, tile);
  }
  /* iterate through list,
   flag neighbours if theyre guaranteed to be mines
   uncover them if theyre guaraneed to be clear
   */
  for (int i=0; i<tiles.size(); i++) {
    int[] tile = tiles.get(i);
    int numPossibleNeighbours = 8;
    //case when tile is on edges
    if (tile[0] == 0 || tile [0] == resolutionX-1) {
      if (tile[1] == 0 || tile[1] == resolutionY-1) {
        numPossibleNeighbours = 3;
      } else {
        numPossibleNeighbours = 5;
      }
    } else if (tile[1] == 0 || tile[1] == resolutionY-1) {
      numPossibleNeighbours = 5;
    }
    // if tile has the same number of neighbours as neighbouring mines, flag all neighbours
    if (tile[2] + boardNeighbours[tile[0]][tile[1]] == numPossibleNeighbours) {
      //flag all covered neighbours
      for (int j=-1; j<2; j++) {
        for (int k = -1; k<2; k++) {
          if (tile[0]+j >= 0 && tile[0]+j < resolutionX && tile[1]+k >= 0 && tile[1]+k < resolutionY) {
            if (!boardUncovered[tile[0]+j][tile[1]+k]) {
              if (!boardFlagged[tile[0]+j][tile[1]+k]){ 
                flagTile(tile[0]+j, tile[1]+k);
                changes_made = true;
              }
            }
          }
        }
      }
    }
    // if tile has correct number of flags, and covered neighbours, uncover all unflagged neighbours
    if (tile[3] == boardNeighbours[tile[0]][tile[1]] && numPossibleNeighbours > tile[2]) {
      for (int j=-1; j<2; j++) {
        for (int k = -1; k<2; k++) {
          if (tile[0]+j >= 0 && tile[0]+j < resolutionX && tile[1]+k >= 0 && tile[1]+k < resolutionY) {
            if (!boardFlagged[tile[0]+j][tile[1]+k] && !boardUncovered[tile[0]+j][tile[1]+k]) {
              uncoverTile(tile[0]+j, tile[1]+k);
              changes_made = true;
            }
          }
        }
      }
    }
  }
  if(!changes_made) AI_sum_probs_mode = true;
  
  if(AI_sum_probs_mode){
    
  }
}
