import meter.*;
import processing.serial.*;

//object global 
Serial myPort; 
Meter m;

//bytes global
byte bytesData[] ; 
int barData[];
int threshold = 3; 

// color global
int blue;
int alph ;
int scale=40; 

//Meter global  
int sensorVal; 

//Bar global
int barVal; 
int barHeight=200;
int barTem;

// time global
int start=0 ;  
int time ; 

void setup(){
  //Set the Canvas   
  size(1000, 600);
  //colorMode(HSB,360,1,1,255); 

  //Initialize array 
  bytesData = new byte[105];// All Serial Data 
  barData = new int[3];
  
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
  frameRate(30);
  background(51);
  myPort.write('s');
  if(myPort.available() >=105){
    noLoop();
    start = millis(); //set start time 
    drawGrid();
    drawBar(); 
    drawMeter();
    loop();
  }  
}
void drawGrid(){
  start=millis(); 
  bytesData = myPort.readBytes();
  //println(bytesData[0], bytesData[104]);
  if(bytesData[0]==83 && bytesData[104]==69){
    int idx = 0 ;
    translate(40,40);
    stroke(50,120,255);
    strokeWeight(0.2);
    fill(51);
    rect(0,0,400,400);
    for(int i = 0 ; i<10; i++){
      for(int j = 0 ; j< 10 ; j++){
        idx++;
        if(bytesData[idx]==83 || bytesData[idx]==69 || bytesData[idx]<=threshold) continue;
        //println("row="+i+",col="+j+",idx="+idx+", val="+bytesData[idx]);
        
        blue = (int)map(bytesData[idx],4,45,220,255);
        alph = (int)map(bytesData[idx],4,55,240,255);
        //println(bytesData[idx]);
        noStroke();
        fill(10,90,blue,255);
        if(51<=idx && idx<=100) square(j*scale,i*scale,scale);
        else if(1<=idx && idx<=50) square(j*scale,(4-i)*scale,40);
       }    
     }
     println(bytesData[104],bytesData[103],bytesData[102],bytesData[101],bytesData[100]);
   }
   while(millis()-start<=65) continue;
   //println(millis()-start);
   loop();
}

void drawBar(){
 int idx = 0 ; 
 for(int i=1; i<=5; i++ ){
   int val = i%2;
   if(val==0) idx ++ ; 
   stroke(50,255,50);
   strokeWeight(2);
   fill(10,90,255); 
   barTem=(int)(bytesData[100+idx]& 0xff) +(int)random(50);
   rect(440+val*60+i*60,barHeight,60,-barTem);// bar height corresponding to the data value  
   //  (  (width 400+ margin-left 40) + (every other step 60)  + width 60,  height  ) 
  }
} 
void drawMeter(){
 //Drawing Meter-bar 
 sensorVal = bytesData[101] & 0xff;
 m.updateMeter(sensorVal);
}
