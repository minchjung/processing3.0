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
  frameRate(30); // <--- add frameRate !! but it's not significantly work though 
  bytesData= new byte[105]; // bytes array init 105 (02 version set 104<-- too tight and very caution to the underflow); 
  
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 115200);  
}
void draw() {
    int start = millis();
    myPort.write('s');  
    int a = myPort.available();
    if(a>=105) {  
      noLoop();
      setArr() ; 
    }
    int end = millis();
    println(end - start);
}
void setArr(){
  bytesData = myPort.readBytes();
  //println("start from = "+ bytesData[0]+ ",  end untill = "+ bytesData[104]);
  for(int i=1 ; i <=103;i++){
    board[i-1]=bytesData[i];
    //println("board["+i+ "]"+"= "+ board[i]);
    setColor();
    //println(board[i]);
  }
  //println("my Port Availbalbe = "+ myPort.available());
  //println("Here to Stop loop and make the array "+myPort.available());
} 

    
void setColor(){
   int idx = 0 ; 
   for(int i=0; i < rows; i++){ 
     for(int j=0; j< cols; j++){// get the data on each spot (random Number for now) 
       //float val = board[idx]+100+10*(board[idx]);
       float val =board[idx]; 
       //println("board_"+idx+"_ ="+val);
       float blue = map(val,0,10,150,255); // map the data range to color 
       float alph = map(val,0,10,100,255);// map the data range to alpha
       noStroke();
       fill(0,0,blue,alph);
       rect(j*scale,i*scale,scale,scale); // plot rect  
      idx++;
     }
   }
   loop();
 }
 
