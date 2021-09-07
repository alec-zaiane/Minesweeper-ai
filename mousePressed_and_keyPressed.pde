void mousePressed(){
  int clickedX = mouseX/squareSize;
  int clickedY = mouseY/squareSize;
  if(mouseButton == LEFT){
    uncoverTile(clickedX,clickedY);
  }
  else if (mouseButton == RIGHT){
    flagTile(clickedX,clickedY);
  }
}

void keyPressed(){
  if(key == ' '){
     AI_active = !AI_active;
     println("AI active: "+AI_active);
  }
}
