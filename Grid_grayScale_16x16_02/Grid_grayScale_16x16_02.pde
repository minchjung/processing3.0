final int maxData=25000; // Data range 
final int minData=0; 
final float scale = 50;// (800/50) x (800/50)  
int cols; //16 
int rows; //16

void setup(){
  size(800,800); // size init here, thereby 
  cols = floor(width / scale); // assign value to cols, rows after it 
  rows = floor(height / scale); // 16 x 16 width 50 length
  background(0);
}
void draw(){
  stroke(5); // a littbit of storke 
  strokeWeight(3);// I think its more fine(precise look) to me 
  setColor();
}
void setColor(){
   for(int i=0; i < rows; i++){ 
     for(int j=0; j< cols; j++){// get the data on each spot (random Number for now) 
       float val = map(random(maxData+1),minData,maxData,0,255);// and map the random value to the color range  
       fill(val);// single scale = Gray 
       rect(j*scale,i*scale,scale,scale); // plot rect  
     }
   }
 }
