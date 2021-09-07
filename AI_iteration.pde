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
              if (!boardFlagged[tile[0]+j][tile[1]+k]) {
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
  if (!changes_made) AI_sum_probs_mode = true;

  if (AI_sum_probs_mode && AI_guesses) {
    println("Guessing mode:");
    // Create a new grid holding the probability of a mine being in that location
    float[][] mineProbs = new float[resolutionX][resolutionY];
    boolean[][] analyzed =  new boolean[resolutionX][resolutionY];
    // for every uncovered tile, check to see if it has unflagged neigbouring mines,
    //    if so, add (number of unflagged mines)/(number of covered neighbours) to every covered neighbour
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
      int flaggedNeighbours = 0;
      int coveredNeighbours = 0;
      for (int j = -1; j<2; j++) {
        for (int k=-1; k<2; k++) {
          if (tile[0]+j >= 0 && tile[0]+j < resolutionX && tile[1]+k >= 0 && tile[1]+k < resolutionY) {
            if (boardFlagged[tile[0]+j][tile[1]+k]) {
              flaggedNeighbours ++;
            } else if (!boardUncovered[tile[0]+j][tile[1]+k]) {
              coveredNeighbours ++;
            }
          }
        }
      }
      for (int j = -1; j<2; j++) {
        for (int k=-1; k<2; k++) {
          if (tile[0]+j >= 0 && tile[0]+j < resolutionX && tile[1]+k >= 0 && tile[1]+k < resolutionY) {
            if (!boardFlagged[tile[0]+j][tile[1]+k] && !boardUncovered[tile[0]+j][tile[1]+k]) {
              if (coveredNeighbours != 0) {
                mineProbs[tile[0]+j][tile[1]+k] += float((boardNeighbours[tile[0]][tile[1]] - flaggedNeighbours))/float(coveredNeighbours);
                analyzed[tile[0]+j][tile[1]+k] = true;
              }
            }
          }
        }
      }
    }
    // uncover any tiles with 0 probability, if there are none, uncover tile with lowest probability of being a mine
    // must stick to only analyzed tiles, unseen tiles will have "0" probability because they werent affected
    float lowestProb = 1000;
    int[] lowestProbCoords = {-1, -1};
    boolean uncoveredZero = false;
    for (int i=0; i<mineProbs.length; i++) {
      for (int j=0; j<mineProbs[0].length; j++) {
        if(analyzed[i][j] && mineProbs[i][j] == 0){
          uncoverTile(i,j);
          uncoveredZero = true;
        }
        if (analyzed[i][j] && mineProbs[i][j] < lowestProb && mineProbs[i][j] != 0) {
          lowestProbCoords[0] = i;
          lowestProbCoords[1] = j;
          lowestProb = mineProbs[i][j]; 
        }
      }
    }
    if (!uncoveredZero) {
      if (lowestProbCoords[0] != -1) {
        //TODO find out why probability can be negative
        //      LowestProb has to be > 1?
        println("AI guessing, "+((1.0-lowestProb)*100.0)+"% chance of success");
        game_ai_success_chance *= 1.0-lowestProb;
        println(game_ai_success_chance*100.0+"% chance to have gotten this far");
        uncoverTile(lowestProbCoords[0], lowestProbCoords[1]);
      } else {
        println("Error in guessing");
      }
    }
  }
}
