import processing.serial.*;

byte [] bytesData; 
int scale = 50 ; 
Serial myPort;  // The serial port

void settings(){
  size(700,600);
}
void setup() {
  frameRate(30);
  bytesData= new byte[105];

  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 115200);  
}
void draw() {
    //int start = millis();
     background(51);
    for(int i = 0 ; i< 10;i++){
      textSize(18);
      fill(0,255,0);
      text(i,scale+i*scale+15,40);
      text(i,30,scale+i*scale+30);
    } 
    
    myPort.write('s');  
    int a = myPort.available();
    if(a>=105) {  
      //println(a);
      setArr() ; 
    }
}
int colors;
int start;
void setArr(){
  
  bytesData = myPort.readBytes();
  for(int i = 0 ; i < 3 ; i ++){
    fill(255);
    text( i+ ",  " + (bytesData[i]&0xff),580, 100+50*i );
    text( 102+i+ ",  " + (bytesData[102+i]&0xff),580, 300+50*i);
  }

  if(bytesData[0]==83 && bytesData[104]==69){
    textSize(12);
    println(2,bytesData[2]);
    int idx = 2;
    start=millis();
    for(int i = 0 ; i < 10 ; i++){
      for(int j = 0 ; j < 10 ; j++){      
        stroke(255);
        fill(51);
        if(idx!=101 && (bytesData[idx]&0xff)>=25){ colors=255; }
        if(2<=idx && idx<52){ 
          square(50+j*scale, 50+(4-i)*scale,  scale);
          fill(255);
          text(idx+", ", 50+j*scale+8, 50+(4-i)*scale+30,  scale+50); 
          fill(255,colors,0);
          //println(colors);
          text((bytesData[idx]&0xff)+"", 50+j*scale+8+28, 50+(4-i)*scale+30,  scale+50); 
          colors=0;
        }
        if(52<=idx && idx<102) {
          stroke(255);
          fill(51);
          square(50+j*scale,  50+i*scale,  scale); 
          fill(255);
          text(idx+", ", 50+j*scale+8, 50+i*scale+30,  scale+50);
          fill(255,colors,0);
          text((bytesData[idx]&0xff)+"", 50+j*scale+8+28, 50+i*scale+30,  scale+50);
          
          colors=0;
        }           
        idx++;
      }
    }
  }
  while(millis()-start<=30) continue ; 
} 
