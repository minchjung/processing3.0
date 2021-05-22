final int maxData=255; // Data range 
final int minData=0; 
final int scale = 50;// (500/50) x (500/50)  
final int dispSize = 500 ; 
int cols; //10
int rows; //10


void settings(){
  size(dispSize, dispSize); 
} 
void setup(){
  cols = floor(dispSize / scale); // assign value to cols, rows after it 
  rows = floor(dispSize / scale); // 16 x 16 width 50 length
  background(255);
}
void draw(){
  int start = millis();
  stroke(0,0,200); // a littbit of storke 
  strokeWeight(0.5);// I think its more fine(precise look) to me 
  setColor();
  int end = millis(); 
  println(end - start);
}
void setColor(){
   for(int i=0; i < rows; i++){ 
     for(int j=0; j< cols; j++){// get the data on each spot (random Number for now) 
       float val = random(80,256); 
      // val = map(val,0,255,10,180);
       float alph = map(val,0,255,255,0); // map the data color range(0-255)--blue
       fill(0,0,val,alph);// single scale = Blue 
       rect(j*scale,i*scale,scale,scale); // plot rect  
     }
   }
 }
