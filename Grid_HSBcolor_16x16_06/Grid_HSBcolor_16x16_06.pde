final int maxPress=25000;
final int minPress=0; 
final float increm=0.1; // Interpolation* <-- small gets slower
final float scale = 50;// 16x16 on 800x800 pixel 
int cols; 
int rows; 
PVector pv ;

void setup(){
  size(800,800); // size can be changed, thereby 
  cols = floor(width / scale); // assign value cols, rows here 
  rows = floor(height / scale); // floor: round to int ( Math.floor Javascript)

  background(0);
}
void draw(){
  colorMode(HSB,180,100,100,255);
  // Hue max 360(its angle), Saturation max(100%), Brightness max(100%), alpha max(255)
  // we can set the range of maxVal!! above are the typical
  // now I set the Hue range from red-green-cyan-blue (50%*360=180)
  noStroke();
  setColor();
}
void setColor(){
   float ty=0;
   for(int i=0; i < rows; i++){
     float tx =0;  
     for(int j=0; j< cols; j++){
       float ranNum = random(maxPress+1);
       float H = map(ranNum,minPress,maxPress,180,0); // map the data value to the each color set 
       float S = map(ranNum,minPress,maxPress,80,100);// set the saturation and brightnessn not from 0 <-- dark and black (not pretty at all)
       float B = map(ranNum,minPress,maxPress,80,100);
       tx+=increm;
       float nH = noise(tx,ty)*H+H;
       
       fill(nH,S,B,255);
       square(j*scale,i*scale,scale);  
     }
     ty+=increm;
   }
 }
