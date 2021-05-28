import controlP5.*;
import processing.serial.*;
import java.lang.management.ManagementFactory;
import java.lang.management.MemoryMXBean;

// Set Serial
Serial myPort; 
// Set CP5
ControlP5 cp5; 
Slider slider[];
ButtonBar btnBar;
Knob myKnob; 

// Bytes, signal global
final int threshold =35; //min-value to display
final int bytesLength =105;
byte bytesData[] ; 
boolean startSig;
int STR; // your start signal from Serial-Port
int END;// your end signal from Serial-Port

// Canvas global
final int scale =40; 
final int canvasW =1000;
final int canvasH =600;
final int gridRow =10;
final int gridCol =10;
final int FPS =30;
PFont font ; 

// Grid global 
final int margin_top =80;
final int margin_left =40;
int blue;
int alph;

// Bar global
final int meterX =580;
final int meterY =200;
int sensorVal; 

//timeVal
long timeVal;

// Setting and setup 
void settings(){
  size(canvasW,canvasH);
}

void setup(){
   //Initialize array 
  bytesData = new byte[bytesLength];// Serial Data 
  slider = new Slider[3]; // bar-Slider array

  //Initialize Serial Port 
  myPort = new Serial(this,Serial.list()[0],115200);  
  String portName=""; 
  for(String name : Serial.list()) portName+=name; //gets your Port number
  STR=83; // set Start & and End signal on your Serial
  END=69; //  
  startSig=false;

  //Iniitialize CP5 
  font = createFont("arial",14);
  cp5 = new ControlP5(this);
  //Set Bar-slider array         
  for(int i = 0 ; i<3; i++){
    slider[i]=cp5.addSlider("p10"+(i+1),0,255,0,520 + margin_left, 50*i + margin_top-20,350,40 )
                 .setFont(font)
                 .setColorActive(color(245,130,100))
                 .setColorForeground(color(50,55,255))
                 ;
  } 
  //Set Knob
  myKnob = cp5.addKnob("Meter")
             .setRange(0,360)
             .setValue(0)
             .setPosition(meterX + margin_left-20, meterY + margin_top-20)
             .setRadius(135)
             .setFont(createFont("arial",18))
             .setColorActive(color(245,130,100))
             .setColorForeground(color(50,55,255))
             ;     
 //Set ButtonBar 
  btnBar = cp5.addButtonBar("btnBar")
              .setPosition(45,50)
              .setSize(400,40)
              .setFont(createFont("arial",15))
              .setColorActive(color(245,130,100))
              .addItems(split("START STOP "+portName," "))
              ;
//Set Bar-Slider 
  cp5.addTextlabel("bar").setText("PRESSURE-BAR")
     .setPosition(580 + 80,15)
     .setFont(createFont("arial",20))
     ;
  cp5.addTextlabel("TITLE").setText("POLYWORKS")
     .setPosition(870,570)
     .setFont(createFont("arial",16))
     .setColor(color(255,180));
     ;

}

void draw(){
  frameRate(FPS);
  background(25);
  //println(startSig, myPort.available());
  if(startSig) {
    timeVal=millis();
    myPort.write('s');
    getBytes();  
    drawGrid();
    drawBar();
    drawKnob();
    println("One-LoopTime="+(millis()-timeVal)+", Frame="+1000/(millis()-timeVal));
  }    
}

void getBytes(){
  int start = millis();
  while(myPort.available()>0 || millis()-start <25){
    if(myPort.available() < bytesLength && millis()-start >=550) break; 
    if(myPort.available() < bytesLength) continue;
    bytesData = myPort.readBytes();
  } 
}

void drawGrid(){  
  int start2=millis(); 

  if((bytesData[0] & 0xff) == STR && (bytesData[bytesLength-1] & 0xff)== END){
    int idx = 0 ;
    stroke(50,120,255);// boundary-line
    strokeWeight(0.2); 
    fill(25); //background
    rect(margin_left,margin_top + 50,gridCol*scale,gridRow*scale); //stroke on grid-area
    fill(255);
    textSize(20);
    text("GRID", gridCol*scale/2, canvasH-30); //Title 
    for(int i = 0 ; i < gridRow; i++){
      for(int j = 0 ; j < gridCol ; j++){
        idx++;
        if(bytesData[idx]<=threshold) continue;
        blue = (int)map(bytesData[idx] & 0xff,threshold+1,threshold+50,220,255);
        alph = (int)map(bytesData[idx] & 0xff,threshold+1,threshold+50,245,255);
        noStroke();
        fill(50,55,blue,alph);
        if(51<=idx && idx<=100) square(j*scale + margin_left, i*scale + margin_top +50,scale);
        else if(1<=idx && idx<=50) square(j*scale + margin_left,(4-i)*scale + margin_top +50,scale);
       }    
     }
   }
   while(millis()-start2<=10) continue;
}

void drawBar(){
  for(int i = 0 ; i < 3 ; i ++){
    slider[i].setValue(map(bytesData[101+i] & 0xff,0,255,0,255))
             .getValueLabel().align(ControlP5.RIGHT, ControlP5.CENTER);  
  }
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
    if(barIdx==0) {startSig=true;}
    if(barIdx==1){
      //myPort.write(END);
      startSig=false;
      myPort.clear();
      println("Memory Usage ="+ ((Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory())/1000000 )+" MB");
    } 
  }
}
