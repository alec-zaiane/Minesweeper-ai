void drawBoard(int[][] neighbours, boolean[][]uncovered, boolean[][] flagged) {
  for (int i=0; i<neighbours.length; i++) {
    for (int j=0; j<neighbours[0].length; j++) {
      if(uncovered[i][j] == false || neighbours[i][j] == -1) {fill(240);     
      }
      else{
        int nbrs = neighbours[i][j];
        if(nbrs == 0) fill(64);
        else if(nbrs == 1) fill(#0341fc);
        else if(nbrs == 2) fill(#fca103);
        else if(nbrs == 3) fill(#51039e);
        else if(nbrs == 4) fill(#d90000);
        else if(nbrs == 5) fill(#00db8b);
        else if(nbrs == 6) fill(#dbc500);
        else if(nbrs == 7) fill(#8a602c);
        else if(nbrs == 8) fill(#9babaa);
      }
      strokeWeight(1);
      stroke(0);
      rectMode(CORNER);
      rect(i*squareSize,j*squareSize,squareSize,squareSize);
      if(flagged[i][j]){
        ellipseMode(CENTER);
        fill(255,0,0);
        ellipse(i*squareSize+squareSize/2,j*squareSize+squareSize/2,squareSize/4,squareSize/4);
      }
      if(uncovered[i][j] && neighbours[i][j] == -1){
        ellipseMode(CENTER);
        fill(255,0,0);
        ellipse(i*squareSize+squareSize/2,j*squareSize+squareSize/2,squareSize/2,squareSize/2);
      }
      if(neighbours[i][j] > 0 && uncovered[i][j]){
        textAlign(CENTER,CENTER);
        textSize(squareSize*0.8);
        fill(0);
        text(neighbours[i][j],i*squareSize+squareSize/2,j*squareSize+squareSize/2);
      }
    }
  }
}
