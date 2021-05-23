import meter.*;
Meter m;
int board[][];
int sensorVal;
int start=0 ;  
int time ; 


void setup(){
  size(1000, 600);
  colorMode(HSB,360,1,1,255); //colorMode HSB
  background(51);

  board = new int[10][10]; //10x10
  m = new Meter(this, 520, 250, false); // full circle - true, 1/2 circle - false  
  m.setMeterWidth(380); //Meter canvas width (height calculated to accomodate new width);

  m.setMinScaleValue(0); // Set scale range min to max (0~ 255) 
  m.setMaxScaleValue(255);
  
  
  m.setDisplayDigitalMeterValue(true);//display data value 
  m.setTitle("Pressure Gauge");
  String[] scaleLabels = {"0", "30", "60", "90", "120", "150", "180", "210", "240", "255"};
  m.setScaleLabels(scaleLabels); //display the scale labels above
  m.setShortTicsBetweenLongTics(10);// thic of long tic
}
void draw(){
  start = millis(); //set start time
  setBoard(); 
  drawBar(); 
  drawGauge();
  drawGrid();
}

void setBoard(){
  for(int i =0; i < 10; i++)
   for(int j =0; j < 10; j++)   
      board[i][j]=(int)random(256); // <-- Set Serial Parsing data here 
}

void drawBar(){
 for(int i = 1; i <=5;i++ ){
   int nxtPort= (int)random(256); // <-- board103,102,101 
   int heightSize = (int)map(nxtPort,0,256,0,180); // height 0~180 
   stroke(90,1,1,200); // Stroke color(lawGreen) match to the rect color(blue)
   strokeWeight(2);
   fill(255,1,1,255);
   int val = i%2; //spacing one to another
   rect(440+val*60+i*60,40,60,heightSize);// bar height corresponding to the data value  
   //  (  (width 400+ margin-left 40) + (every other step 60)  + width 60,  height  ) 
 }
}

void drawGauge(){
 //Drawing Gauge background as Rectangle
 noStroke();
 fill(90,1,1,255);
 rect(520,250,380,180);
 
 sensorVal = (int)random(256);
 m.updateMeter(sensorVal);
}
void drawGrid(){    // Setting our temporal frequency 
  int constFPS=20; //Just for this local function to count 
  while(millis() - start <=constFPS) continue; //FPS =50  <= [1000/(constFPS=20)]
  for(int i = 1;  i <=10; i++){ // In other words, delay 20ms 
    for(int j = 1 ; j<=10; j++){
      if(board[i-1][j-1]<=230){
        fill(51); // dark gray
        noStroke();
        rect(i*40,j*40,40,40); //scale 40
      }else{
        int val = board[i-1][j-1];
        val= (int)map(val,231,255,190,250); //blue color

        fill(val,1,1,255); //Hue-color 
        noStroke();
        rect(i*40,j*40,40,40);// scale 40
      } 
    }
  } 
}
