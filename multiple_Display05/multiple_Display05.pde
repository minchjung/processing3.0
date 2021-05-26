import meter.*;
import processing.serial.*;

// Import-obj
Serial myPort; 
Meter m;

// Bytes global
final int threshold =3; //min-value to display
final int bytesLength =105;
byte bytesData[] ; 

// Canvas global
final int scale =40; 
final int canvasW =1000;
final int canvasH =600;
final int gridRow =10;
final int gridCol =10;

// Grid global 
final int framePS =30;
final int margin_top =80;
final int margin_left =40;
int blue;
int alph;

// Bar global
final int barM_top =10; //bar Margin-top
final int barW =60;// bar Width  
final int barH_max =150; // bar Height-max 
int barVal; 
int barHeight;

// Meter global  
final int meterX =520;
final int meterY =200;
final int meterW =380;
int sensorVal; 

// time global
int start=0 ;  
int time ; 

// Setting and setup 
void settings(){
  //Set the canvas   
  size(canvasW,canvasH);
  //colorMode(HSB,360,1,1,255); //Now-RGB 
}
void setup(){
  //Initialize array 
  bytesData = new byte[bytesLength];// Serial Data 
  
  //Initialize Serial Port 
  myPort = new Serial(this,Serial.list()[0],115200);     

  //Iniitialize Meter 
  m = new Meter(this, meterX, meterY, false); // full circle - true, 1/2 circle - false  
  m.setMeterWidth(meterW); //Meter canvas width (height calculated to accomodate new width);
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
  frameRate(framePS);
  background(51);
  myPort.write('s');
  if(myPort.available() >=bytesLength){
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
    translate(margin_left,margin_top);
    stroke(50,120,255);// boundary-line (color:lawngreen)
    strokeWeight(0.2); 
    fill(51); //background
    rect(0,0,gridCol*scale,gridRow*scale);
    for(int i = 0 ; i < gridRow; i++){
      for(int j = 0 ; j < gridCol ; j++){
        idx++;
        if(bytesData[idx]==83 || bytesData[idx]==69 || bytesData[idx]<=threshold) continue;
        //println("row="+i+",col="+j+",idx="+idx+", val="+bytesData[idx]);        
        blue = (int)map(bytesData[idx],4,45,220,255);
        alph = (int)map(bytesData[idx],4,55,240,255);
        //println(bytesData[idx]);
        noStroke();
        fill(10,90,blue,alph);
        if(51<=idx && idx<=100) square(j*scale,i*scale,scale);
        else if(1<=idx && idx<=50) square(j*scale,(4-i)*scale,scale);
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
   stroke(50,255,50); //color:lawngreen
   strokeWeight(2);
   fill(10,90,255); //color:blue
   barHeight=(int)(bytesData[100+idx] & 0xff) +(int)random(20);
   barHeight=(int)map(barHeight,0,275,0,150);
   rect(440+val*barW+i*barW,barH_max+barM_top,barW,-barHeight);// bar height corresponding to the data value  
   //  (  x=(gridCol*scale: 400 + margin-left:40) + (every other step of barWidth:60) + barWidth:60, y=barMax:180, w=barWidth:60  h=-barHeight  ) 
  }
}

void drawMeter(){
 //Drawing Meter-bar 
 sensorVal = bytesData[101] & 0xff;
 m.updateMeter(sensorVal);
}
