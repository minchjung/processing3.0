import controlP5.*;
import processing.serial.*;

// Set Serial
Serial myPort; 
// Set CP5
ControlP5 cp5; 
Slider slider1;
Slider slider2;
Slider slider3; 
ButtonBar btnBar;
Knob myKnob; 

// Bytes global
final int threshold =35; //min-value to display
final int bytesLength =105;
byte bytesData[] ; 
boolean startSig;

// Canvas global
final int scale =40; 
final int canvasW =1000;
final int canvasH =600;
final int gridRow =10;
final int gridCol =10;
final int FPS =30;

// Grid global 
final int margin_top =80;
final int margin_left =40;
int blue;
int alph;

// Bar global
final int meterX =550;
final int meterY =180;
int sensorVal; 

// time,font,signal global
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
  String nameArr[] = Serial.list();
  String portName=""; 
  for(String name : nameArr) portName+=name;

  startSig=false;

  //Iniitialize CP5 
  font = createFont("arial",14);
  cp5 = new ControlP5(this);
  //Set Bar-slider         
  slider1 = cp5.addSlider("Bar1",0,255,0,520 + margin_left, margin_top,300,30)
               .setFont(font)
               .setColorActive(color(50,255,50));
  slider2 = cp5.addSlider("Bar2",0,255,0,520 + margin_left, 40 + margin_top,300,30)
               .setFont(font)
               .setColorActive(color(50,255,50));
  slider3 = cp5.addSlider("Bar3",0,255,0,520 + margin_left, 80 + margin_top,300,30)
               .setFont(font)
               .setColorActive(color(50,255,50));
  //Set Knob
  myKnob = cp5.addKnob("Pressure")
             .setRange(0,360)
             .setValue(0)
             .setPosition(meterX + margin_left, meterY + margin_top)
             .setRadius(120)
             .setFont(createFont("arial",18))
             .setColorActive(color(50,255,50))
             ;     
 //Set ButtonBar 
  btnBar = cp5.addButtonBar("btnBar")
              .setPosition(45,50)
              .setSize(400,40)
              .setFont(createFont("arial",12))
              .setColorActive(color(245,130,100))
              .addItems(split("START STOP "+portName," "))
              ;
 }

void draw(){
  frameRate(FPS);
  background(51);
  println(startSig, myPort.available());
  if(startSig) {
    myPort.write('s');
    getBytes();  
    drawGrid();
    drawBar();
    drawKnob();
  }    
}

void getBytes(){
  int start = millis(); 
  while(myPort.available()>0 || millis()-start <25){
    if(myPort.available() <105 && millis()-start >=550) break;
    if(myPort.available() < 105) continue; 
    bytesData = myPort.readBytes();
  } 
}

void drawGrid(){
  start=millis(); 

  if(bytesData[0]==83 && bytesData[104]==69){
    int idx = 0 ;
    //translate(margin_left,margin_top);
    stroke(50,120,255);// boundary-line (color:lawngreen)
    strokeWeight(0.2); 
    fill(51); //background
    rect(margin_left,margin_top + 50,gridCol*scale,gridRow*scale);
    for(int i = 0 ; i < gridRow; i++){
      for(int j = 0 ; j < gridCol ; j++){
        idx++;
        if(bytesData[idx]<=threshold) continue;
        blue = (int)map(bytesData[idx] & 0xff,threshold+1,threshold+50,220,255);
        alph = (int)map(bytesData[idx] & 0xff,threshold+1,threshold+50,200,255);
        //println(bytesData[idx]);
        noStroke();
        fill(10,90,blue,alph);
        if(51<=idx && idx<=100) square(j*scale + margin_left, i*scale + margin_top +50,scale);
        else if(1<=idx && idx<=50) square(j*scale + margin_left,(4-i)*scale + margin_top +50,scale);
       }    
     }
     //println(bytesData[104] & 0xff,bytesData[103] & 0xff,bytesData[102]& 0xff,bytesData[101]& 0xff,bytesData[100]& 0xff);
   }
   while(millis()-start<=35) continue;
}

void drawBar(){
  slider1.setValue(map(bytesData[101] & 0xff,0,255,0,255))
         .getValueLabel().align(ControlP5.RIGHT, ControlP5.CENTER);
  slider2.setValue(map(bytesData[102] & 0xff,0,255,0,255))
         .getValueLabel().align(ControlP5.RIGHT, ControlP5.CENTER);
  slider3.setValue(map(bytesData[103] & 0xff,0,255,0,255))
         .getValueLabel().align(ControlP5.RIGHT, ControlP5.CENTER);
}

void drawKnob(){
 sensorVal = bytesData[101] & 0xff;
 sensorVal = (int)map(sensorVal,0,255,0,360);
 myKnob.setValue(sensorVal);
}

public void controlEvent(ControlEvent theEvent) {
  if(theEvent.isFrom(cp5.getController("btnBar"))){
    ButtonBar bar =(ButtonBar) theEvent.getController();    
    int barIdx = bar.hover();
    println("buttonClicked= "+barIdx);
    if(barIdx==0) startSig=true;
    if(barIdx==1){
      startSig=false;
      //println(myPort.available());
      myPort.clear();
      //println(myPort.available());
    } 
  }
}
