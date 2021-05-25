/**********************************************************************************************************

* Project: MatrixArrayVisualizer.pde

* By: Chris Wittmier @ Sensitronics LLC

* LastRev: 04/22/2014

* Description: Graphic visualizer for MatrixArray demo / tutorial. Draws a colored grid to show force

* reported by 16x10 ThruMode matrix array connected to Arduino and minimal circuitry
**********************************************************************************************************/ 

import processing.serial.*; 
// Constant
int COLS = 10;
int ROWS = 10;
int CELL_SIZE = 40;
int START_MARKER =83;
int END_MARKER = 69;
int SCALE_READING = 2;
int min_force_thresh = 5;

boolean INVERT_X_AXIS = false;
boolean INVERT_Y_AXIS = false;
boolean SWAP_AXES = false;

//Global
Cell[][] grid;
Serial sPort;

int xcount = 0;
int ycount = 0;
boolean got_zero = false;
int got_byte_count = 0;
int last_byte_count = 0;

void settings(){
  size(CELL_SIZE * COLS, CELL_SIZE * ROWS);  //40x10,40x10
}

void setup() {
  background(0, 0, 0);
  int port_count = Serial.list().length;// Our value =1 
  sPort = new Serial(this, Serial.list()[port_count - 1], 115200);     
  grid = new Cell[COLS][ROWS];//[10][10]
  for (int i = 0; i < COLS; i++){
    for (int j = 0; j < ROWS; j++){ // i*40, j*40, 40, 40
      grid[i][j] = new Cell(i * CELL_SIZE, j * CELL_SIZE, CELL_SIZE, CELL_SIZE);
    }
  }
}

void draw() {
  sPort.write('s');
  rxRefresh();
}

void rxRefresh() {
  while(sPort.available() > 0){
    byte got_byte = (byte) sPort.read();
    got_byte_count ++; //global, byte count 
    int unsigned_force = got_byte & 0xFF;// Ah ~~ this is freaking crucial !! Byte operation! 
    //println(got_byte, unsigned_force);
    if(unsigned_force == START_MARKER) continue;
    if(unsigned_force == END_MARKER) { // read the byte one by one if one reach to end=69
      xcount = 0; //global 
      ycount = 0;// x,y count reset to start new packet 
    }
    else if(got_zero){ //if got_zero = true 
      for(int i = 0; i < unsigned_force; i ++){ //
        updatePixel(xcount, ycount, 0);
        xcount ++;
        if(xcount >= COLS){
          xcount = 0;
          ycount ++;
          if(ycount >= ROWS) ycount = ROWS - 1;
        }
      }
      got_zero = false;
    }
    else if(got_byte == 0)
      got_zero = true;
    else{
      updatePixel(xcount, ycount, unsigned_force);
      xcount ++;
      if(xcount >= COLS){
        xcount = 0;
        ycount ++;
        if(ycount >= ROWS)
          ycount = ROWS - 1;
      }
    }
  }
}

void updatePixel(int xpos, int ypos, int force){
  if(SWAP_AXES){
    int temp = xpos;
    xpos = ypos;
    ypos = temp;
  }
  if((xpos < ROWS) && (ypos < COLS)){
    if(INVERT_Y_AXIS)
      xpos = (COLS - 1) - xpos;
    if(INVERT_X_AXIS)
      ypos = (COLS - 1) - ypos;
    grid[ypos][xpos].display(force);
  }
}

// CLass Cell 
class Cell {
  float x, y;
  float w, h;
  int current_force = 0;
  float calibrated = 0;

  Cell(float tempX, float tempY, float tempW, float tempH) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
  } 
  
  void display(int newforce) {
    if(newforce < min_force_thresh*2) newforce = 0;
    else newforce *= (int)(SCALE_READING);
   
    if(newforce != current_force){
      noStroke();
      println(newforce);
      fill(0, newforce, 0);
      rect(x, y, w, h); 
      current_force = newforce;
    }
  }
}
