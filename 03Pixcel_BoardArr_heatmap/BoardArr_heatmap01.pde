
int w=500; 
int h =500; 
int colArr[];
float board[][];
void setup(){
  size(800,800); 
  background(0);
  
}
void draw(){
  noStroke();
  board = new float[width][height];
  setBoard(); 
  setColor();
}
 void setBoard(){
   for(int i=0; i < height; i++){
     for(int j=0; j< width; j++){
       float ranNum = random(25001);
       ranNum = constrain(ranNum,24.5,25.8);
       board[j][i] =ranNum + 6.0*noise(i*0.02, j*0.02);
     }
   }
 }
 void setColor(){
   pushStyle();
   colorMode(HSB,1,1,1);
   loadPixels();
   int p = 0;
   float val; 
   for(int i=0; i < height; i++){
     for(int j=0; j< width; j++){
       board[j][i] = constrain(board[j][i], 25,30);
       val = map(board[j][i],25,30,0.2,1.0); 
       pixels[p++] = color(val,0.9,1);
     }
   }
   updatePixels();
   popStyle();
 }
