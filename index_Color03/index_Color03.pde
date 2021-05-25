
import processing.serial.*;
byte [] bytesData;
int rows = 10 ; 
int cols = 10 ; 
int scale = 40 ; 
int val ; 
Serial myPort;  // The serial port

void settings(){
  size(cols*scale, rows*scale);
}
void setup() {
  bytesData= new byte[105];
  myPort = new Serial(this, Serial.list()[0], 115200);  
  //background(51);

}
int start ; 
int mid;
void draw() {
 
    background(51);    
    myPort.write('s');  
    int a = myPort.available();
    if(a>=105) {  
      noLoop();
      setArr();

    }
}
void setArr(){
  start=millis(); 
  bytesData = myPort.readBytes();
  if(bytesData[0]==83 && bytesData[104]==69){
    int idx = 0 ; 
    for(int i = 0 ; i<10; i++){
      for(int j = 0 ; j< 10 ; j++){
        idx++;
        val = (int)map(bytesData[idx],0,50,150,255);
        if(bytesData[idx]<=3) val=51;
        if(bytesData[idx]==83 || bytesData[idx]==69 || bytesData[idx]<=10) continue;
        println("row="+i+",col="+j+",idx="+idx+", val="+bytesData[idx]);
 
        noStroke();
        fill(0,0,val);
        if(51<=idx && idx<=100) square(j*scale,i*scale,scale);
        else if(1<=idx && idx<=50){
          translate(j*scale,(4-i)*scale);
          square(0,0,40);
        } 

       }    
     }      
   }
   while(millis()-start<=65) continue;
   println(millis()-start);
   loop();
} 
