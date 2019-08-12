/* RADIOACTIVE MINESWEEPER - MADE BY JOSEFINE KLINTBERG 2018 */

/* Change the appearance of the game */
int boxsize = 40; //Change the size of the boxes
int rowsAndcols = 20; //Change the number of rows and columns
int numbBombs = rowsAndcols*rowsAndcols/5; //Change the number of bombs

//Note if changing of boxsize and/or rowsAndcols, remember to change canvas size in setup()

PImage winning, losing;
int columns, rows;
color[][] colors;
boolean[][] mines;
int saved_i = -1;
int saved_j = -1;
boolean lost = false, winningscreen = false;
int bombscorrect = 0;
int neighbourMineCount;
int SIZE = rowsAndcols*rowsAndcols+1;

//Saving the state of each square
boolean Mine[] = new boolean[SIZE];
boolean Flags[] = new boolean[SIZE];
boolean Opened[] = new boolean[SIZE];
int minecount[] = new int[SIZE];


 
void setup() {
  
  //Setup the board
  int boardsize = boxsize*rowsAndcols;
  size(800, 800); //Size of canvas is boardsize*boardsize
  columns = rows = rowsAndcols;
  colors = new color[columns][rows];
  frameRate(60);
  
  //Load in the winning and losing images
  String lost = "https://jklintan.github.io/Minesweeper/img/losingscreen";
  String w = "https://jklintan.github.io/Minesweeper/img/winningscreen";
  winning = loadImage(w, "png");
  losing = loadImage(lost, "png");
  
  //Generating random numbers for placing of the mines
  for(int i = 0; i < numbBombs; i++){
    int randnr1 = int(random(0, rowsAndcols-1));
    int randnr2 = int(random(0, rowsAndcols-1));
    //colors[randnr1][randnr2] = color(200); //to see where bombs are when debugging
    
    //If no mine placed at that position before place it, else generate new bomb
    int MineIndex = (randnr1*(rowsAndcols))+randnr2; 
    if(MineIndex > rowsAndcols*rowsAndcols-1){ //Check if index out of range
      i--;
    }else{
      if(Mine[MineIndex] != true){
        Mine[MineIndex] = true;
      }else
        i--;
      }
    }
  
  //Calculation of neighbourMineCount and drawing the board
    for (int i=0 ; i < SIZE; i++) {
      if(Mine[i] == true){
        if(i == 0){
          minecount[i+1] ++;
          minecount[i+rowsAndcols]++;
          minecount[i+(rowsAndcols+1)]++;
        }
        else if(i == rowsAndcols-1)
        {
          minecount[i-1]++;
          minecount[i+rowsAndcols]++;
          minecount[i+(rowsAndcols-1)]++;
        }
        else if(i == (rowsAndcols*rowsAndcols - rowsAndcols)){
          minecount[i-rowsAndcols]++;
          minecount[i-(rowsAndcols-1)]++;
          minecount[i+1]++;
        }
        else if(i == (rowsAndcols*rowsAndcols-1))
        {
          minecount[i-1] ++;
          minecount[i-rowsAndcols]++;
          minecount[i-(rowsAndcols+1)]++;
        }
        else if((i%rowsAndcols == 9) && i != (rowsAndcols-1) && i != (rowsAndcols*rowsAndcols-1)){
          minecount[i-1]++;
          minecount[i-rowsAndcols]++;
          minecount[i-(rowsAndcols+1)]++;
          minecount[i+(rowsAndcols-1)]++;
          minecount[i+rowsAndcols]++;
        }
        else if((i%rowsAndcols == 0) && i != 0 && i != (rowsAndcols*rowsAndcols - rowsAndcols)){
          minecount[i+1]++;
          minecount[i-(rowsAndcols-1)]++;
          minecount[i-rowsAndcols]++;
          minecount[i+rowsAndcols]++;
          minecount[i+(rowsAndcols+1)]++;
        }
        else if( i > 0 && i < (rowsAndcols-1)){
          minecount[i-1]++;
          minecount[i+1]++;
          minecount[i+(rowsAndcols-1)]++;
          minecount[i+rowsAndcols]++;
          minecount[i+(rowsAndcols+1)]++;
        }
        else if(i > (rowsAndcols*rowsAndcols - rowsAndcols) && i < (rowsAndcols*rowsAndcols - 1)){
          minecount[i-1]++;
          minecount[i+1]++;
          minecount[i-(rowsAndcols-1)]++;
          minecount[i-rowsAndcols]++;
          minecount[i-(rowsAndcols+1)]++;
        }
        else{
          minecount[i-(rowsAndcols-1)]++;
          minecount[i-rowsAndcols]++;
          minecount[i-(rowsAndcols+1)]++;
          minecount[i-1]++;
          minecount[i+1]++;
          minecount[i+(rowsAndcols-1)]++;
          minecount[i+rowsAndcols]++;
          minecount[i+(rowsAndcols+1)]++;
        }  
      }
    }
    
    for (int i=0; i<SIZE; i++) {
      if(Mine[i] == true){
        minecount[i] = 0;
    }
    }
    
  for (int i=0; i<columns; i++) {
      for (int j=0; j<rows; j++) {
        int x = i*boxsize;
        int y = j*boxsize;
        
        //Debugging purposes
        //fill(200);
        //rect(i*boxsize, j*boxsize, boxsize, boxsize);
        //fill(255);
        //text(minecount[(i*10)+j], x + boxsize / 2, y + boxsize / 2);
        
        colors[i][j] = color(255, 204, 0);
      }
  }
  
}
  
//Updating function
void draw() {
  
  //Check if lost
  if(lost){
    image(losing, 0, 0);
    //background(40, 223, 40);
    //fill(0);
    //text("You lost", 220,220);
  }else if(bombscorrect == numbBombs){
    //Check if all tiles are opened
    if(winningscreen == true){
        image(winning, 0, 0);
        //background(255, 204, 0);
        //fill(0);
        //text("You won", 220,220);
     }else if(winningscreen == false){ 
        checktile(); //Keep checking
     }
  }else {
    checktile(); //Keep checking
  }
  
}
 
//Event handler for user
void mousePressed() {
  //Check which square the user pressed
  for (int i=0; i<columns; i++) {
    for (int j=0; j<rows; j++) {
      int x = i*boxsize;
      int y = j*boxsize;
      if(mouseX > x && mouseX < (x + boxsize) && mouseY > y && mouseY < (y + boxsize) && (mouseButton == LEFT)) {
        
        //Check if surrounding cells = 0, then open them also
        if(minecount[i*rowsAndcols+j]==0){
          checksurround(i, j);
        }
        
        //If pressed square has bomb
        if(Mine[((i*rowsAndcols)+j)] == true){
          colors[i][j] = color(0);
          lost = true;
        }
        else if(Flags[(i*rowsAndcols)+j] == true) //If already flagged, open up
        {
          fill(0);
          text(minecount[(i*10)+j], x + boxsize / 2 - 4, y + boxsize / 2 +4);
          colors[i][j] = color(200);
          Flags[(i*rowsAndcols)+j] = false;
          colors[i][j] = color(0);
          Opened[(i*rowsAndcols)+j] = true;
        }
        else{ //If ordinary square
          colors[i][j] = color(0);
          Opened[((i*rowsAndcols)+j)] = true;
        }
          saved_i = i;
          saved_j = j;
      }
      
      //Handling the rightclick, setting flags
      if(mouseX > x && mouseX < (x + boxsize) && mouseY > y && mouseY < (y + boxsize) && (mouseButton == RIGHT))
      {
        if(Opened[((i*rowsAndcols)+(j))] == true){
          //If opened, do nothing
        }else if((Flags[(i*rowsAndcols)+j]) == true){
          colors[i][j] = color(255, 204, 0);
          Flags[(i*rowsAndcols)+j] = false;
        }else{
          colors[i][j] = color(0);
          fill(40, 223, 40);
          Flags[((i*rowsAndcols)+j)] = true;
          bombscorrect = checkifcorrect();
        }
      }
    }
  }
  
  //Check if last opened
  boolean won = allopened();
  if(won == true){
    winningscreen = true;
  }
}

/* AUXILIARY FUNCTIONS */

//Check how many flags are set out correctly
int checkifcorrect(){
  int bombscorrect = 0;
  boolean check = false;
  for(int i = 0; i < rowsAndcols*rowsAndcols; i++){
    if(Mine[i] == true && Flags[i] == true)
      bombscorrect+=1;
  }
  return bombscorrect;
}
  
//Gameover state
void gameover() {
  background(64,0,0);
  fill(255,0,128);
  text("You lost.", 200, 200);
}

//Check if all tiles are opened
boolean allopened(){
  for(int i = 0; i < SIZE-1; i++){
    if(Opened[i] != true && Mine[i] == false){
      return false;
    }
  }
  return true;
}

//Give each tile the correct color after state
void checktile(){
  for (int i=0; i<columns; i++) {
    for (int j=0; j<rows; j++) {
      int x = i*boxsize;
      int y = j*boxsize;

      //If flagged and opened
      if(Flags[i*rowsAndcols+j] == true && Opened[i*rowsAndcols+j] != true) //Mine[i*10+j] == true && 
      {
        fill(40, 223, 40);
        rect(i*boxsize, j*boxsize, boxsize, boxsize);
        text(minecount[(i*rowsAndcols)+j], x + boxsize / 2 - 4, y + boxsize / 2 + 4);
      }else{ //A closed tile
        fill(colors[i][j]);
        rect(i*boxsize, j*boxsize, boxsize, boxsize);
        fill(255, 204, 0);
        text(minecount[(i*rowsAndcols)+j], x + boxsize / 2 - 4, y + boxsize / 2 +4);
      }
    } 
  }
}
  
//Purpose: establish 4-neighbours, if any of them 0, open and keep going
void checksurround(int column, int row){
  int index = (column*rowsAndcols)+row;
  if(Opened[index] == false && Flags[index] == false){
    colors[column][row] = color(0);
    fill(104, 10, 20);
    Opened[index] = true;
    if(minecount[index] == 0){
      //First check if we are in a corner
      if(index == 0){
        checksurround(1, 0);
        checksurround(0, 1);
        checksurround(1, 1);
      }else if(index == (rowsAndcols-1)){
        checksurround(1, rowsAndcols-1);
        checksurround(0, rowsAndcols-2);
        checksurround(1, rowsAndcols-2);
      }else if(index == (rowsAndcols*rowsAndcols-rowsAndcols)){
        checksurround(rowsAndcols-2, 0);
        checksurround(rowsAndcols-1, 1);
        checksurround(rowsAndcols-2, 1);
      }else if(index == (rowsAndcols*rowsAndcols-1)){
        checksurround(rowsAndcols-2, rowsAndcols-1);
        checksurround(rowsAndcols-1, rowsAndcols-2);
        checksurround(rowsAndcols-2, rowsAndcols-2);
      }else if(column == 0 && row != 0 && row != rowsAndcols-1){
        checksurround(0, row+1);
        checksurround(0, row-1);
        checksurround(1, row);
        checksurround(1, row-1);
        checksurround(1, row+1);
      }else if(column == rowsAndcols-1 && row != 0 && row != rowsAndcols-1){
        checksurround(column, row+1);
        checksurround(column, row-1);
        checksurround(column-1, row);
        checksurround(column-1, row-1);
        checksurround(column-1, row+1);
      }else if(row == 0 && column != 0 && column != rowsAndcols-1){
        checksurround(column+1, row);
        checksurround(column-1, row);
        checksurround(column, row+1);
        checksurround(column+1, row+1);
        checksurround(column-1, row+1);
      }else if(row == rowsAndcols-1 && column != 0 && column != rowsAndcols-1){
        checksurround(column+1, row);
        checksurround(column-1, row);
        checksurround(column, row-1);
        checksurround(column+1, row-1);
        checksurround(column-1, row-1);
      }else{
        checksurround(column+1, row); 
        checksurround(column-1, row);
        checksurround(column, row-1);
        checksurround(column, row+1);
        checksurround(column+1, row-1);
        checksurround(column+1, row+1);
        checksurround(column-1, row-1);
        checksurround(column-1, row+1);
      }
    }
  } 
}
