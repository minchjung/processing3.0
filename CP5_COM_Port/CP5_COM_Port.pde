import controlP5.*;
import processing.serial.*;

// Import-Serial , CP5
Serial myPort; 
ControlP5 cp5; 

// Bytes global
final int threshold =15; //min-value to display
final int bytesLength =105;
byte bytesData[] ; 

// Matrix global
Matrix matrix; 
Slider matSlider;

// Bar-Slider global
Slider slider1;
Slider slider2; 
Slider slider3; 

// Knob  global
Knob knob; 

// Button global
ButtonBar btnBar;

// bar global 
final int barW = 300;
final int barH =40;
final int barX =600; 
final int barY =50;
final int barMin =0;
final int barMax =255;
final int barNum = 3; 
String barTitle; 

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

// time global
int start=0 ;  
int time ; 
void settings(){
  size(canvasW,canvasH);
  smooth(2);

}
void setup(){
  background(31);  
  //Initialize Serial,CP5, bytesArray
  myPort = new Serial(this,Serial.list()[0],115200);
  cp5 = new ControlP5(this); 
  bytesData = new byte[bytesLength];// Serial Data 

  //Initialize slider for matrix 
  matSlider =cp5.addSlider("p2",0,255,500,100,20,400);  

  //Set Bar-Slider 
  cp5.addTextlabel("bar").setText("Pressure-Bar")
     .setPosition(barX + 100,10)
     .setColorValue(#C8FAFA)
     .setFont(createFont("arial",20))
     ;
  //Initialize bar-Slider 
  slider1 =cp5.addSlider("p101"); // <-label of each bar-slider
  slider2 =cp5.addSlider("p102");
  slider3 =cp5.addSlider("p103");

  setSliders(slider1, barY); // go to set slider style
  setSliders(slider2, barY*2);
  setSliders(slider3, barY*3);

  //slider3.setCaptionLabel("Pressure") //additional set for the last one
  //       .getCaptionLabel().align(ControlP5.CENTER,ControlP5.BOTTOM_OUTSIDE); 

  //Initialize Knob 
  knob = cp5.addKnob("Meter")
            .setRange(0,360)
            .setPosition(barX+15,barY*5+10)
            .setRadius(130)
            .setColorActive(color(50,255,50))
            .setFont(createFont("arial",14))
            ;
 //Initialize ButtonBar 
  btnBar = cp5.addButtonBar("btnBar")
              .setPosition(50,30)
              .setSize(400,40)
              .setFont(createFont("arial",12))
              .setColorActive(color(245,130,100))
              //.setColorBackground(color(245,130,100))
              .addItems(split("Start COM4 COM5 COM6 COM7 COM8"," "))
              ;
  //btnBar.onMove(new CallbackListener(){
  //  public void controlEvent(CallbackEvent ev) {
  //    ButtonBar bar = (ButtonBar)ev.getController();
      
  //  }
  //});
}

void draw(){
  frameRate(15);
  myPort.write('s');
  if(myPort.available() >=bytesLength){
    noLoop();
    start = millis(); //set start time 
    drawGrid();
    loop();
  }  
}
void drawGrid(){
  start=millis(); 
  bytesData = myPort.readBytes();
  println(bytesData[0], bytesData[104]);
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
   //slider1.setValue(bytesData[101] & 0xff);
   //slider2.setValue(bytesData[102] & 0xff);
   //slider3.setValue(bytesData[103] & 0xff);  
   //knob.setValue(bytesData[101] & 0xff);
   while(millis()-start<=65) continue;
   //println(millis()-start);

}

//bar-Slider Setter 
Slider setSliders(Slider slider, int gap){  //gap btween bar in y-axis

  slider.setSize(barW,barH)
     .setPosition(barX,gap)
     .setRange(barMin,barMax)
     .setFont(createFont("arial",12))
     .setColorValueLabel(color(200,250,250))
     .setColorCaptionLabel(color(200,250,250))
     .setColorActive(color(50,255,50))
     .setSliderMode(Slider.FIX)
     .setColorForeground(color(50,55,255))
     .setColorBackground(color(100))
     .getValueLabel().align(ControlP5.RIGHT, ControlP5.CENTER)
     ;

   return slider;
}

public void controlEvent(ControlEvent theEvent) {
  if(theEvent.isFrom(cp5.getController("btnBar"))){
    ButtonBar bar =(ButtonBar) theEvent.getController();    
    int barIdx = bar.hover();
    //if(barIdx==0) myPort.write('s');
  }
}


//void getGrid(){
//  //cp5.addTextlabel("val").setText(matrix.getValue()+"")
//  //   .setPosition(barX + 100,10)
//  //   .setColorValue(#C8FAFA);

//}



//void mouse
  //fill(cp5.isMouseOver(cp5.getController("btnBar"))? hover:color(255));
