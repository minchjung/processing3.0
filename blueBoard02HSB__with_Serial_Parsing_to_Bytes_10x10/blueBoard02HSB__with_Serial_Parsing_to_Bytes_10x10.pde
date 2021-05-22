import processing.serial.*;
boolean flag = true;
byte [] bytesData;
int []board = new int[104]; 
int rows = 10 ; 
int cols = 10 ; 
int scale = 40 ; 

Serial myPort;  // The serial port

void settings(){
  size(rows*scale,cols*scale);
}

void setup() {
  //timer = new StopWatchTimer();
  bytesData= new byte[105];
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 115200);  
  colorMode(HSB,360,2,2,2); // ColorMode HSB, max Hue 360 as default 
  
}
void draw() {

    myPort.write('s');  
    int a = myPort.available();

    if(a>=105) {  
      noLoop();
      setArr() ; 
    }     
}
void setArr(){
  bytesData = myPort.readBytes();
  for(int i=1 ; i <=103;i++){
    board[i-1]=bytesData[i];
    setColor();
  }
}  
void setColor(){
   int idx = 0 ; 
   for(int i=0; i < rows; i++){ 
     for(int j=0; j< cols; j++){// transfer the buffer data to the grid display for the view  
       //float val = board[idx]+100+10*(board[idx]);
       float val =board[idx] + random(1); // add the default data more to expand   
       float c = map(val,0,2,180,220); // map the value to the color as the data (max hue set 360)
       float alph = map(val,0,2,1,2); // map the value to the alpha also (max alpha set 2)
       noStroke();
       fill(c,2,2,alph);// blue range = 180 ~ 220 from 360 
       rect(j*scale,i*scale,scale,scale); // plot rect  
      // println(alph);
      idx++;
     }
   }
   loop();
 }
 
