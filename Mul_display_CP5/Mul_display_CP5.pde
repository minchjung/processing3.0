import controlP5.*;
import processing.serial.*;

// Import-obj
Serial myPort; 

ControlP5 cp5; 
Knob myKnob; 
Slider slider1;
Slider slider2;
Slider slider3; 

// Bytes global
final int threshold =15; //min-value to display
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
final int meterX =550;
final int meterY =180;
int sensorVal; 

// time global
int start=0 ;  
int time ; 
PFont font ; 

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

  //Iniitialize CP5 
  font = createFont("arial",20);

  cp5 = new ControlP5(this);
  myKnob = cp5.addKnob("Pressure")
             .setRange(0,360)
             .setValue(0)
             .setPosition(meterX,meterY)
             .setRadius(120)
             .setFont(createFont("arial",18))
             .setColorLabel(color(50,255,50))
             .setNumberOfTickMarks(10)
             .setTickMarkLength(4)
             .snapToTickMarks(true)
             .setColorForeground(color(50,255,50))
             .setColorBackground(color(10, 90, 250))
             ;               
  slider1 = cp5.addSlider("Bar1",0,255,0,520,0,300,30)
                        .setFont(createFont("arial",15))
                        .setColorCaptionLabel(color(20,255,50))
                        .setColorLabel(color(20,255,50));
  slider2 = cp5.addSlider("Bar2",0,255,0,520,40,300,30)
                        .setFont(createFont("arial",15))
                        .setColorCaptionLabel(color(20,255,50))
                        .setColorLabel(color(20,255,50));
                        
  slider3 = cp5.addSlider("Bar3",0,255,0,520,80,300,30)
                        .setFont(createFont("arial",15))
                        .setColorCaptionLabel(color(20,255,50))
                        .setColorLabel(color(20,255,50));
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
    drawCircle();
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
        blue = (int)map(bytesData[idx] & 0xff,threshold+1,threshold+50,220,255);
        alph = (int)map(bytesData[idx] & 0xff,threshold+1,threshold+50,200,255);
        //println(bytesData[idx]);
        noStroke();
        fill(10,90,blue,alph);
        if(51<=idx && idx<=100) square(j*scale,i*scale,scale);
        else if(1<=idx && idx<=50) square(j*scale,(4-i)*scale,scale);
       }    
     }
     //println(bytesData[104] & 0xff,bytesData[103] & 0xff,bytesData[102]& 0xff,bytesData[101]& 0xff,bytesData[100]& 0xff);
   }
   //for(int i = 51 ; i< 101; i++) print(bytesData[i]+" ");
   while(millis()-start<=65) continue;
   //println(millis()-start);
   //loop();
}

void drawBar(){
  //println(map(bytesData[101] & 0xff,0,255,0,255));
  slider1.setValue(map(bytesData[101] & 0xff,0,255,0,255));
  slider2.setValue(map(bytesData[102] & 0xff,0,255,0,255));
  slider3.setValue(map(bytesData[103] & 0xff,0,255,0,255));
}

void drawCircle(){
 //Drawing Meter-bar 
 sensorVal = bytesData[101] & 0xff;
 sensorVal = (int)map(sensorVal,0,255,0,360);
 myKnob.setValue(sensorVal);
}
