import processing.serial.*;

byte [] bytesData; 
int scale = 50 ; 
Serial myPort;  // The serial port

void settings(){
  size(600,600);
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
int val ; 
int r=100;
void setArr(){
  bytesData = myPort.readBytes();
  //println("start = "+ bytesData[0]+ ",  end = "+ bytesData[104]);
  //println("my Port Availbalbe = "+ myPort.available());
  //println(bytesData.length);
  if(bytesData[0]==83 && bytesData[104]==69){
    
    int idx = 2;
    for(int i = 0 ; i < 10 ; i++){
      for(int j = 0 ; j < 10 ; j++){      
        fill(51);
        stroke(255);
        rect(50+j*scale,50+i*scale,scale,scale);
        textSize(20);
        fill(255);
        if(2<=idx && i<52){ text(""+idx,50+j*scale+16,50+i*scale+30,scale+50); }
        else if(52<=idx && idx<102) { text(""+idx,50+j*scale+16,50+(4-i)*scale+30,scale+50); }           
        idx++;
      }
    }
  }
} 
