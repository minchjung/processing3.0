import processing.serial.*;
Serial myPort ; 
ParsingS ps; 


void setup(){
  size(1000,600);
  myPort = new Serial(this, Serial.list()[0],115200);
  ps = new ParsingS(83,60,105,10);
}

int startSigCNT; 
void draw(){
  startSigCNT++;
  
  myPort.write('s');
  setBytesArr();  
  
  startSigCNT=0;
}
int cnt = 0 ; 
void setBytesArr(){
  int start = millis(); 
  while(myPort.available()>0 || millis()-start <25){
    if(myPort.available() < ps.S_LEN) continue; 
    print("SignalCNT="+startSigCNT+",CompletCNT="+cnt+" "+"Before clear buffer = "+ myPort.available()+"   ");
    ps.setBytesArr(myPort.readBytes());
    println("After clear buffer = "+ myPort.available());
  } 
  cnt++;
  //if( ps.parsingCheck()){
  //  noLoop();
  //  ps.drawGrid(50,100,10,10,40); 
  //}     
} 
