//PImage winning, losing;
int boxsize = 50;
int columns, rows;
color[][] colors;
boolean[][] mines;
int saved_i = -1;
int saved_j = -1;
int SIZE = 101;
int difficulty = 20, neighbourMineCount;
public boolean Mine[] = new boolean[SIZE];
public boolean Flags[] = new boolean[SIZE];
public boolean Opened[] = new boolean[SIZE];
public int minecount[] = new int[SIZE];
boolean lost = false, winningscreen = false;
int bombscorrect = 0;
 
void setup() {
  size(500, 500);
  columns = 10;
  rows = 10;
  colors = new color[columns][rows];
  frameRate(60);
  
  //winning = loadImage("winningscreen.png");
  //losing = loadImage("losingscreen.png");
  
  //Generating random numbers for placing of the mines
  for(int i = 0; i < difficulty; i++){
    int randnr1 = int(random(0, 9));
    int randnr2 = int(random(0, 9));
    colors[randnr1][randnr2] = color(200); //to see where bombs are
    int MineIndex = (randnr1*10)+randnr2;
    if(Mine[MineIndex] != true)
    {
      Mine[MineIndex] = true;
    }
    else
      i--;
  }
  
  //Calculation of neighbourMineCount and drawing the board
    for (int i=0; i<SIZE; i++) {
      if(Mine[i] == true)
      {
        
        if(i == 0){
          minecount[i+1] ++;
          minecount[i+10]++;
          minecount[i+11]++;
        }
        else if(i == 9)
        {
          minecount[i-1]++;
          minecount[i+10]++;
          minecount[i+9]++;
        }
        else if(i == 90)
        {
          minecount[i-10]++;
          minecount[i-9]++;
          minecount[i+1]++;
        }
        else if(i == 99)
        {
          minecount[i-1] ++;
          minecount[i-10]++;
          minecount[i-11]++;
        }
        else if(i==19 || i ==29 || i == 39 || i == 49 || i==59 || i == 69 || i == 79 || i == 89)
        {
          minecount[i-1]++;
          minecount[i-10]++;
          minecount[i-11]++;
          minecount[i+9]++;
          minecount[i+10]++;
        }
        else if(i==10 || i ==20 || i == 30 || i == 40 || i==50 || i == 60 || i == 70 || i == 80)
        {
          minecount[i+1]++;
          minecount[i-9]++;
          minecount[i-10]++;
          minecount[i+10]++;
          minecount[i+11]++;
        }
        else if( i > 0 && i < 9)
        {
          minecount[i-1]++;
          minecount[i+1]++;
          minecount[i+9]++;
          minecount[i+10]++;
          minecount[i+11]++;
        }
        else if(i > 90 && i<99) //j == rad
        {
          minecount[i-1]++;
          minecount[i+1]++;
          minecount[i-9]++;
          minecount[i-10]++;
          minecount[i-11]++;
        }
        else{
        minecount[i-9]++;
        minecount[i-10]++;
        minecount[i-11]++;
        minecount[i-1]++;
        minecount[i+1]++;
        minecount[i+9]++;
        minecount[i+10]++;
        minecount[i+11]++;
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
      //fill(200);
      //rect(i*boxsize, j*boxsize, boxsize, boxsize);
      //fill(255);
      //text(minecount[(i*10)+j], x + boxsize / 2, y + boxsize / 2);
      colors[i][j] = color(255, 204, 0);
      
    }
  }
  }
  
 
void draw() {
  if(lost){
    //image(losing, 0, 0);
    background(40, 223, 40);
    fill(0);
    text("You lost", 220,220);
  }else if(bombscorrect == difficulty){
    //Check if all tiles are opened
    if(winningscreen == true){
        //image(winning, 0, 0);
        background(255, 204, 0);
        fill(0);
        text("You won", 220,220);
     }else if(winningscreen == false){
        checktile();
     }
  }else {
    checktile();
  }
}
 
void mousePressed() {
  for (int i=0; i<columns; i++) {
    for (int j=0; j<rows; j++) {
      int x = i*boxsize;
      int y = j*boxsize;
      if(mouseX > x && mouseX < (x + boxsize) && mouseY > y && mouseY < (y + boxsize) && (mouseButton == LEFT)) {
        
        if(minecount[i*10+j]==0)//Check if surrounding cells have 0, then open them up
        {
          checksurround(i, j);
        }
        
        
        if(Mine[((i*10)+j)] == true)
        {
          colors[i][j] = color(0);
          lost = true;
        }
        else if(Flags[(i*10)+j] == true)
        {
          fill(0);
          text(minecount[(i*10)+j], x + boxsize / 2 - 4, y + boxsize / 2 +4);
          colors[i][j] = color(200);
          Flags[(i*10)+j] = false;
          colors[i][j] = color(0);
          Opened[(i*10)+j] = true;
        }
        else{
          colors[i][j] = color(0);
          Opened[((i*10)+j)] = true;
        }
          saved_i = i;
          saved_j = j;
      }
      
      //Handling the rightclick, setting flags
      if(mouseX > x && mouseX < (x + boxsize) && mouseY > y && mouseY < (y + boxsize) && (mouseButton == RIGHT))
      {
        if(Opened[((i*10)+(j))] == true)
        {
        }
        else
        {
          colors[i][j] = color(0);
          fill(40, 223, 40);
          Flags[((i*10)+j)] = true;
          bombscorrect = checkifcorrect();
        }
      }
    }
    }
    boolean won = allopened();
    if(won == true){
      winningscreen = true;
    }
  }


//Check how many flags are set out correctly
int checkifcorrect()
{
  int bombscorrect = 0;
  boolean check = false;
  for(int i = 0; i < 100; i++)
  {
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

boolean allopened(){
  for(int i = 0; i < SIZE-1; i++){
      if(Opened[i] != true && Mine[i] == false)
      {
        return false;
      }
  }
  return true;
}

void checktile(){
  for (int i=0; i<columns; i++) {
    for (int j=0; j<rows; j++) {
      int x = i*boxsize;
      int y = j*boxsize;
      
      if(Flags[i*10+j] == true && Opened[i*10+j] != true) //Mine[i*10+j] == true && 
      {
        fill(40, 223, 40);
        rect(i*boxsize, j*boxsize, boxsize, boxsize);
        text(minecount[(i*10)+j], x + boxsize / 2 - 4, y + boxsize / 2 +4);
      }
      else
      {
        fill(colors[i][j]);
        rect(i*boxsize, j*boxsize, boxsize, boxsize);
        fill(255, 204, 0);
        text(minecount[(i*10)+j], x + boxsize / 2 - 4, y + boxsize / 2 +4);
      }
    } 
  }
}

void checksurround(int column, int row){
  //Purpose: establish 4-neighbours, if any of them 0, open and keep going
  int index = (column*10)+row;
  if(minecount[index] == 0 && Opened[index] == false){
    colors[column][row] = color(0);
    fill(104, 10, 20);
    Opened[index] = true;
    //First check if we are in a corner
    if(index == 0){
      checksurround(1, 0);
      checksurround(0, 1);
    }else if(index == 9){
      checksurround(1, 9);
      checksurround(0, 8);
    }else if(index == 90){
      checksurround(8, 0);
      checksurround(9, 1);
    }else if(index == 99){
      checksurround(8, 9);
      checksurround(9, 8);
    }else if(column == 0 && row != 0 && row != 9){
      checksurround(0, row+1);
      checksurround(0, row-1);
      checksurround(1, row);
    }else if(column == 9 && row != 0 && row != 9){
      checksurround(9, row+1);
      checksurround(9, row-1);
      checksurround(8, row);
    }else if(row == 0 && column != 0 && column != 9){
      checksurround(column+1, row);
      checksurround(column-1, row);
      checksurround(column, row+1);
    }else if(row == 9 && column != 0 && column != 9){
      checksurround(column+1, row);
      checksurround(column-1, row);
      checksurround(column, row-1);
    }else{
      checksurround(column+1, row);
      checksurround(column-1, row);
      checksurround(column, row-1);
      checksurround(column, row+1);
    }
 } 
}
