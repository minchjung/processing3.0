final int maxPress=25000;
final int minPress=0; 
final float increm=0.01; // Interpolation*
final float scale = 50;// 16x16 on 800x800 pixel 
int cols; 
int rows; 

void setup(){
  size(800,800); // size can be changed, thereby 
  cols = floor(width / scale); // assign value cols, rows here 
  rows = floor(height / scale); // floor: round to int ( Math.floor Javascript)
  background(0);
}
void draw(){
  stroke(5);
  strokeWeight(3);
  setColor();
}
void setColor(){
  float tY = 0 ; 
   for(int i=0; i < rows; i++){
     float tX = 0; 
     for(int j=0; j< cols; j++){
       float val = map(random(25001),0,25000,0,255); 
       tX+=increm; // offset increase every step of cols (xAxis)
       float nVal = noise(tX,tY)*val; // Perlin noise function depend on the position but 
       // make on the OUR DATA VALUE, also 
       fill(nVal); // put it in and it works out (alittl bit)
       //(Color change from the data-value and blured the image when it changes)
       rect(j*scale,i*scale,scale,scale);
     }
     tY+=increm;// offset increases every step of rows (yAxis)
   }
 }
