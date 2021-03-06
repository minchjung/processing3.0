/**
 * ControlP5 Example 1 : Basic UI elements
 *
 * Check also https://github.com/sojamo/controlp5
 * for a more straightforward approach
 * 
 * Modify the colors in the colors array with different controllers. 
 * The colors are displayed in the rectangles.
 *
 * example by Kasper Kamperman (kasperkamperman.com), 2010
 * updated 17-06-2017
 * 
 * tested with library version 2.2.6
 * ControlP5 by Andreas Schlegel 
 * http://www.sojamo.de/libraries/controlP5/
 *
 */

import controlP5.*;    // import controlP5 library
ControlP5 controlP5;   // controlP5 object

// array to store 7 colors that can be changed by the different 
// user interface elements
color [] colors = new color[7]; 

void setup() {
  size(330,260);
  smooth();
    
  controlP5 = new ControlP5(this);
  
  // description : a bang controller triggers an event when pressed. 
  // parameters  : name, x, y, width, height
  controlP5.addBang("bang1",10,10,20,20);
    
  // description : a button executes after release
  // parameters  : name, value (float), x, y, width, height
  controlP5.addButton("button1",1,70,10,60,20);
  
  // description : a toggle can have two states, true and false
  //               where true has the value 1 and false is 0.
  // parameters  : name, default value (boolean), x, y, width, height
  controlP5.addToggle("toggle1",false,170,10,20,20);
  
  // description : a slider is either used horizontally or vertically.
  //               width is bigger, you get a horizontal slider
  //               height is bigger, you get a vertical slider.  
  // parameters  : name, minimum, maximum, default value (float), x, y, width, height
  controlP5.addSlider("slider1",0,255,128,10,80,10,100);
  controlP5.addSlider("slider2",0,255,128,70,80,100,10);
  
  // description : round turning dial knob
  // parameters  : name, minimum, maximum, default value (float, x, y, diameter
  controlP5.addKnob("knob1",0,360,0,70,120,50);
  
  // description : box that displays a number. You can change the value by 
  //               click and hold in the box and drag the mouse up and down.
  // parameters : name, default value (float), x, y,  width, height
  controlP5.addNumberbox("numberbox1",50,170,120,60,14);
}
  
void draw() { 
  background(0);  // background black
  
  // draw 7 squares and use as a fill color the colors from the colors array
  for(int i=0;i<7;i++) {        // loop through colors array
    stroke(255);
    fill(colors[i]);            // use color to fill
    rect(10+(i*45),210,40,40);  // draw rectangle
  }  
}

void controlEvent(ControlEvent theEvent) {
  /* events triggered by controllers are automatically forwarded to 
     the controlEvent method. by checking the name of a controller one can 
     distinguish which of the controllers has been changed.
  */ 
 
  /* check if the event is from a controller otherwise you'll get an error
     when clicking other interface elements like Radiobutton that don't support
     the controller() methods
  */
  
  if(theEvent.isController()) { 
    
    print("control event from : "+theEvent.getController().getName());
    println(", value : "+theEvent.getController().getValue());
    
    if(theEvent.getController().getName()=="bang1") {
      colors[0] = colors[0] + color(40,40,0);
      if(colors[0]>255) colors[0] = color(40,40,0);    
    }
    
    if(theEvent.getController().getName()=="button1") {
      colors[1] = colors[1] + color(40,0,40);
      if(colors[1]>255) colors[1] = color(40,0,40);
    }
    
    if(theEvent.getController().getName()=="toggle1") {
      if(theEvent.getController().getValue()==1) colors[2] = color(0,255,255);
      else                                 colors[2] = color(0,0,0);
    }
    
    if(theEvent.getController().getName()=="slider1") {
      colors[3] = color(theEvent.getController().getValue(),0,0);
    }
    
    if(theEvent.getController().getName()=="slider2") {
      colors[4] = color(0,theEvent.getController().getValue(),0);
    }
      
    if(theEvent.getController().getName()=="knob1") {
      colors[5] = color(0,0,theEvent.getController().getValue());
    }
    
    if(theEvent.getController().getName()=="numberbox1") {
      colors[6] = color(theEvent.getController().getValue());
    } 
    
  }  
}
