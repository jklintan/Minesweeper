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
boolean lost = false, won = false;
int bombscorrect = 0;


class Square{
  boolean hasMine = false;
  boolean isOpened = false;
  boolean hasFlag = false; 
  int neighbourMineCount;
  int columns;
  int rows;
  
  //Constuctor
  Square(int  xpos, int ypos, int width, int height)
  {
    
  }
  
}
 
void setup() {
  size(501, 501);
  columns = 10;
  rows = 10;
  colors = new color[columns][rows];
  frameRate(60);
  
  
  //Generating random numbers for placing of the mines
  for(int i = 0; i < difficulty; i++){
    int randnr1 = int(random(0, 9));
    int randnr2 = int(random(0, 9));
    colors[randnr1][randnr2] = color(255);
    int MineIndex = (randnr1*10)+randnr2+1;
    if(Mine[MineIndex] != true)
    {
      Mine[MineIndex] = true;
    }
    else
      i--;
  }
  
  //Calculation of neighbourMineCount and drawing the board
    for (int i=0; i<columns; i++) {
    for (int j=0; j<rows; j++) {
      colors[i][j] = color(200);
      int index = ((j*10)+i);
      if(Mine[index] == true)
      {
        if(index == 0){
          minecount[index+1] ++;
          minecount[index+10]++;
          minecount[index+11]++;
        }
        else if(i == 9 && j == 0)
        {
          minecount[index-1] ++;
          minecount[index+10]++;
          minecount[index+9]++;
        }
        else if(i == 0 && j == 9)
        {
          minecount[index-10]++;
          minecount[index-9]++;
          minecount[index+1]++;
        }
        else if(i == 9 && j == 9)
        {
          minecount[index-1] ++;
          minecount[index-10]++;
          minecount[index-11]++;
        }
        else if(i == 0 && j!=0 && j!=9)
        {
          minecount[index+1]++;
          minecount[index-9]++;
          minecount[index-10]++;
          minecount[index+10]++;
          minecount[index+11]++;
        }
        else if(i == 9)
        {
          minecount[index-1]++;
          minecount[index-10]++;
          minecount[index-11]++;
          minecount[index+9]++;
          minecount[index+10]++;
        }
        else if(j == 0)
        {
          minecount[index-1]++;
          minecount[index+1]++;
          minecount[index+9]++;
          minecount[index+10]++;
          minecount[index+11]++;
        }
        else if(j == 9)
        {
          minecount[index-1]++;
          minecount[index+1]++;
          minecount[index-9]++;
          minecount[index-10]++;
          minecount[index-11]++;
        }
        else{
        minecount[index-9]++;
        minecount[index-10]++;
        minecount[index-11]++;
        minecount[index-1]--;
        minecount[index+1] ++;
        minecount[index+9]++;
        minecount[index+10]++;
        minecount[index+11]++;
        }
        
    }
    }
  }
  print(minecount[34]);
}
 
void draw() {
  if(lost){
  background(255);
  fill(0);
  text("You lost", 220,220);
  }else if(bombscorrect == difficulty){
  background(255);
  fill(0);
  text("You won", 220,220);
} else {
  for (int i=0; i<columns; i++) {
    for (int j=0; j<rows; j++) {
      fill(colors[i][j]);
      rect(i*boxsize, j*boxsize, boxsize, boxsize);
    }
  }
  
}

}
 
void mousePressed() {
  for (int i=0; i<columns; i++) {
    for (int j=0; j<rows; j++) {
      int x = i*boxsize;
      int y = j*boxsize;
      if(mouseX > x && mouseX < (x + boxsize) && mouseY > y && mouseY < (y + boxsize) && (mouseButton == LEFT)) {
        if(Mine[((i*10)+(j+1))] == true)
        {
          colors[i][j] = color(0);
          lost = true;
        }
        else{
          colors[i][j] = color(104, 10, 20);
          Opened[((i*10)+(j+1))] = true;
        }
          saved_i = i;
          saved_j = j;
      }
      
      //Handling the rightclick, setting flags
      if(mouseX > x && mouseX < (x + boxsize) && mouseY > y && mouseY < (y + boxsize) && (mouseButton == RIGHT))
      {
        if(Opened[((i*10)+(j+1))] == true)
        {
        }
        else
        {
          colors[i][j] = color(255, 200, 200);
          fill(0, 102, 153);
          Flags[((i*10)+j+1)] = true;
          bombscorrect = checkifcorrect();
        }
      }
    }
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
