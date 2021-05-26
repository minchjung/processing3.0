import controlP5.*;

ControlP5 cp5; 
Slider slider1;
Slider slider2; 
Slider slider3; 
Knob knob; 
Matrix matrix; 
Slider matSlider1;
Slider matSlider2;

//array 
float arr[]= new float[105];

// bar global 
final int barW = 300;
final int barH =40;
final int barX =600; 
final int barY =50;
final int barMin =0;
final int barMax =255;
final int barNum = 3; 
String barTitle; 

void setup(){
  
  //Set Canvas 
  size(1000,600); 
  smooth(2);
  background(31);
  
  //Initialize CP5
  cp5 = new ControlP5(this); //new cp5 obj 
  
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
  
  
  setSliders(slider1, barY); // go to set slider
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
  //Initialize Matrix-grid board
  matrix = cp5.addMatrix("matrix")
              .setPosition(50,100)
              .setSize(400,400)
              .setGrid(10,10)
              .setArrayValue(arr)
              .setColorBackground(color(0,45,90))
              .setFont(createFont("arial",18))
              .setCaptionLabel("GRID").align(ControlP5.CENTER, ControlP5.BOTTOM_OUTSIDE,ControlP5.CENTER,ControlP5.BOTTOM_OUTSIDE);
              ;
  //Initialize slider for matrix 
  matSlider1 =cp5.addSlider("p1",0,255,50,50,400,20);
  matSlider2 =cp5.addSlider("p2",0,255,500,100,20,400);                
}

void draw(){
  frameRate(15);
  setData();
  drawAll();
  //getGrid();

}
//Set data 
void setData(){
  for(int i = 0 ; i < 105; i++)
    arr[i] = random(10,255);// <-- Put Serial here
}
//Draw All
void drawAll(){
  slider1.setValue(arr[101]);
  slider2.setValue(arr[102]);
  slider3.setValue(arr[103]);  
  knob.setValue(arr[101]);
}


//bar-Slider Setter 
Slider setSliders(Slider slider, int gap){  //gap btween bar in y-axis
  println("you Slider here uh?? sibonga~");  
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
void getGrid(){
  //cp5.addTextlabel("val").setText(matrix.getValue()+"")
  //   .setPosition(barX + 100,10)
  //   .setColorValue(#C8FAFA);
  
}
