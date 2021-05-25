import processing.serial.*;
boolean flag = true;
byte [] bytesData;
int []board = new int[104]; 
int rows = 10 ; 
int cols = 120 ; 
int scale = 20 ; 
Serial myPort;  // The serial port

void settings(){
  size((int)(cols*scale*2),rows*scale);
}
void setup() {
  frameRate(30);
  bytesData= new byte[105];

  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 115200);  
  background(51);
  //noLoop();
}
void draw() {
    //int start = millis();
    myPort.write('s');  
    int a = myPort.available();
    //println("its on draw loop"+a);
    if(a>=105) {  
      noLoop();
      //println(a);
      int tem = setArr() ; 
      loop();
    }
    //int end = millis();
    //println(end - start);


}
int val ; 
int setArr(){

  bytesData = myPort.readBytes();
  //println("start = "+ bytesData[0]+ ",  end = "+ bytesData[104]);
  //println("my Port Availbalbe = "+ myPort.available());
  //println(bytesData.length);
  if(bytesData[0]==83 && bytesData[104]==69){
    int idx = 0;
    for(byte b : bytesData){
      idx++;
      if(b==83 || b ==69 || b<=10) continue;
      println("Index="+idx+",  Val="+b);
      fill(0,50,255,255);
      square(idx*scale,50,scale);
      textSize(20);
      text(""+idx,idx*scale,100);
    }
  }
  //  for(int i = 1; i <=10; i++){
  //    for(int j =1; j <= 10 ; j++){
  //      val = bytesData[idx];
  //      idx++;
  //      if(val <=2) continue; 
  //      noStroke(); 
  //      fill(0,0,180,200);
  //      square(i*scale,j*scale,scale);
  //      println("row="+i+", col="+j+", val="+val);
  //    }
  //  }  
  //}

  return 0 ; 
} 
