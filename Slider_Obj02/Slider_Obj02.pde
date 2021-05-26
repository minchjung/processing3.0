import controlP5.*;

ControlP5 cp5; 
Slider slider1;
Slider slider2; 
Slider slider3; 

//bytes global 


// bar global 
final int barW = 300;
final int barH =40;
final int barX =600; 
final int barY =50;
final int barMin =0;
final int barMax =255;
final int barNum = 3; 

void setup(){
  size(1000,600); 
  cp5 = new ControlP5(this); //new cp5 obj 

  slider1 =cp5.addSlider("slider1");
  slider2 =cp5.addSlider("slider2");
  slider3 =cp5.addSlider("slider3");
  
  setSliders(slider1, barY); // go to set slider
  setSliders(slider2, barY*2);
  setSliders(slider3, barY*3);
  
  //slider3.setCaptionLabel("Pressure") //additional set for the last one
  //       .getCaptionLabel().align(ControlP5.CENTER,ControlP5.BOTTOM_OUTSIDE); 
}

void draw(){
  frameRate(10);
  background(21);
  setValue(slider1);
  setValue(slider2);
  setValue(slider3);
}

Slider setSliders(Slider slider, int gap){  //gap btween bar in y-axis
  println("you Slider here uh?? sibonga~");  
  slider.setSize(barW,barH)
     .setPosition(barX,gap)
     .setRange(barMin,barMax)
     .setFont(createFont("arial",14))
     .setColorValueLabel(color(200,250,250))
     .setColorCaptionLabel(color(200,250,250))
     .setColorActive(color(50,255,50))
     .setSliderMode(Slider.FIX)
     .setColorForeground(color(50,55,255))
     .setColorBackground(color(100))
     ;
     
   return slider;
}

void setValue(Slider slider){
  //println("you here uh?? sibonga~");
  for(int i = 0 ; i < barNum ; i++)
    slider.setValue(random(20,255))
          .getValueLabel().align(ControlP5.RIGHT, ControlP5.CENTER); 
}
