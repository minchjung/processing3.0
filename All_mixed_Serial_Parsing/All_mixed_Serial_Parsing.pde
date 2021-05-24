import meter.*;
import processing.serial.*;

Serial myPort; 
Meter m;
byte bytesData[] ; 
int board[][];
int extraPort [];
int sensorVal;
int start=0 ;  
int time ; 


void setup(){
  //Set the Canvas   
  size(1000, 600);
  colorMode(HSB,360,1,1,255); 
  background(51);

  //Initialize array 
  bytesData = new byte[105];// All Serial Data 
  board = new int[10][10]; //10x10 Serial Data 
  extraPort = new int[10]; //last 4 Serial Data
  
  //Initialize Serial Port 
  myPort = new Serial(this,Serial.list()[0],115200);     
  
  //Iniitialize Meter 
  m = new Meter(this, 520, 250, false); // full circle - true, 1/2 circle - false  
  m.setMeterWidth(380); //Meter canvas width (height calculated to accomodate new width);
  m.setMinScaleValue(0); // Set scale range min to max (0~ 255) 
  m.setMaxScaleValue(255);
  
  //Set Meter Display 
  m.setDisplayDigitalMeterValue(true);//display data value 
  m.setTitle("Pressure Gauge");
  String[] scaleLabels = {"0", "30", "60", "90", "120", "150", "180", "210", "240", "255"};
  m.setScaleLabels(scaleLabels); //display the scale labels above
  m.setShortTicsBetweenLongTics(10);// thic of long tic
}

void draw(){
  myPort.write('s');
  if(myPort.available() >=105){
    noLoop();
    start = millis(); //set start time 
    setBoard(); 
    drawBar(); 
    drawGauge();
    drawGrid();
    loop();
  }  
}

void setBoard(){
  int idx = 1 ; 
  bytesData =myPort.readBytes();
  //println("start= "+ bytesData[0]+",  end= "+ bytesData[104]);
  for(int i=0; i < 10; i++){
   for(int j=0; j < 10; j++){   
      board[i][j]=bytesData[idx]; // <-- Set Serial Parsing data here 
      idx++;
      //println(board[i][j]);
    }
  }
  for(int i=0; i<4; i++){
    extraPort[i]=bytesData[idx];
    idx++;
  }
}

void drawBar(){
 for(int i=1; i<=5; i++ ){
   int val = i%2;
   stroke(90,1,1,200); // Stroke color(lawGreen) match to the rect color(blue)
   strokeWeight(2);
   fill(90,1,1,200);
   rect(440+val*60+i*60,40,60,180);// bar height corresponding to the data value  
   //  (  (width 400+ margin-left 40) + (every other step 60)  + width 60,  height  ) 
 } 
 int val = extraPort[0];
 println(val);
 if(val<=0) val =0; 
 val = (int)map(val,0,255,0,255);
 
 //pushMatrix();
 //rotate(radians(180));
 stroke(90,1,1,200);
 strokeWeight(3);
 fill(255,1,1,255);
 rect(440+60+60,40,60,val);
 //popMatrix();
}

void drawGauge(){
 //Drawing Meter-bar 
 sensorVal = extraPort[3];
 m.updateMeter(sensorVal);
}
void drawGrid(){    // Setting our temporal frequency 
  int constFPS=20; //Just for this local function to count 
  while(millis() - start <=constFPS) continue; //FPS =50  <= [1000/(constFPS=20)]
  for(int i = 1;  i <=10; i++){ // In other words, delay 20ms 
    for(int j = 1 ; j<=10; j++){
      if(board[i-1][j-1]<=5){
        fill(51); // dark gray
        noStroke();
        rect(i*40,j*40,40,40); //scale 40
      }else{
        int val = board[i-1][j-1];
        val= (int)map(val,6,155,200,250); //blue color
        fill(val,1,1,255); //Hue-color 
        noStroke();
        rect(i*40,j*40,40,40);// scale 40
      } 
    }
  } 
}
