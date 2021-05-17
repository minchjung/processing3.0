class Board{
  // Class field
  PVector position;  // <-- vector-DataStructure, more like to the Pair on C++
  float len;
  float biteVal;
  float grayScale;

  // Constructor to inject the dependecny field value
  Board(float x, float y,float len, float bitVal){
    position = new PVector(x,y);
    this.len = len; 
    this.biteVal = bitVal;  
  }
  // Define the plot function of a single Object 
  void plot(){
    setColor();
    colorMode(HSB,grayScale);
    stroke(0);
    fill(grayScale);
    //print(biteVal);
    //println(grayScale);
   
    pushMatrix();
    translate(position.x,position.y);
    rect(0,0,len,len);
    popMatrix();  
  }
  void setColor(){
 
    float start = 20.0;
    if(biteVal >=20000 && biteVal <= 25000) grayScale = random(0,start);  
    else if (biteVal >= 15000) grayScale = random(start,start*2);  
    else if (biteVal >= 10000) grayScale = random(start*4, start*6);
    else if (biteVal >= 5000) grayScale = random(start*8,start*10); 
    else grayScale = random(start*11,255); 
  }
  
}

// == Canvas Rendering ==
// Set the global field
final int N = 256; // <--- cant assign to size 
int gridNumX = 16;
int gridNumY = 16; // <-- here to put X by Y like(16 x 16) 
Board[][] board = new Board[gridNumY][gridNumX]; //Caution to set Coord in array  

void setup(){
  size(256,256,P2D); // <-- no way to put the variable into the size ??
  float len = 16; // length of the single size of the rectangle 
  for(int i = 0; i < gridNumY; i++){
    for(int j = 0; j< gridNumX; j++){
        board[i][j]= new Board(len*i,len*j,len,random(25001)); // Init the Object with biteVal
    }
  }
}

void draw(){
  background(50);
  for(int i = 0; i <gridNumY; i++){
    for(int j = 0 ; j<gridNumX; j++){
          board[i][j].plot();
    }
  }
}
