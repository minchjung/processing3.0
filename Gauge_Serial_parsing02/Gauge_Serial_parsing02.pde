
import meter.*;
import processing.serial.*;

Serial myPort; 
Meter m; 
byte [] bytesData = new byte[105];
int sensorValue; 

void setup() {
  // Set canvas size, background 
  size(600, 300);
  background(150, 255, 100);
  // Serial init
  myPort = new Serial(this,Serial.list()[0],115200); 
  
  // Meter init
  m = new Meter(this, 90, 15, true); // full circle - true, 1/2 circle - false  
  m.setMinScaleValue(0); // Set scale range min to max (0~ 255) 
  m.setMaxScaleValue(255);
  
  m.setDisplayDigitalMeterValue(true); 
  m.setTitle("Pressure Gauge"); 
  String[] scaleLabels = {"0", "30", "60", "90", "120", "150", "180", "210", "240", "255"}; 
  m.setScaleLabels(scaleLabels);
  m.setShortTicsBetweenLongTics(9);
}

void draw() {
  myPort.write('s'); //포트 s 신호 보내면 
  if(myPort.available()>=105){  버퍼에 계속해서 쌓일텐데 105개 쌓이면 처리해준다.
    noLoop(); // draw loop를 중단하고
    setGauge();// 값을 할당 
    loop(); // 마치고 오면 다시 loop을 돌려 준다.
    }  
} // 놔두면 버퍼에 계속 쌓여서 있기 때문에 s 신호를 계속 보내줘도 덮어 쓰지 않고 버퍼에 쌓이는것 >? <--그래도 확인 필요 (데이터 유실 체크)
// 시작과 끝 타임체크에서 0이 뜨는것은  Serial data가 105단위로 들어오지 않기 때문에 draw loop가  아무처리 없이 한바뀌 돌기 때문인듯 하다. 
// 105단위로 못끊고 데이터를 처리할때, availabe함수로 버퍼의 stack size를 찍어보면 확인 가능해 보인다. 
// ex)33-66-105 이런식으로 들어오고 s신호가 계속 들어가 그 다음 데이터가 넘어올때  33-66-105-33-66-105 형태로 덮어서 다시 reset 되지 않고 
// 33-66-105-210-500....쭈욱 쌓여서  20만까지도 쌓이는것을 볼 수 있다. 즉 데이터는 뒤에 계속 붙어서 들어온다. 길이를 105개씩 끊어서 
// 앞뒤가 시작과 끝값인 83-69를 확인함과 동시에 버퍼에 값이 존재 하지 않으면 
//유실없이 들어오는 모든 Serial값을 buffer로부터 가져 오는것이 증명 가능해 보인다.   
void setGauge(){
  bytesData = myPort.readBytes(); //<-- 한방에 버퍼값을 어레이에 담고 버퍼에는 값이 clear 
  sensorValue = bytesData[101]; // gauge 에 표시할 데이터를 담아준다.
  //println("start from = "+ bytesData[0]+ ",  end untill = "+ bytesData[104]); // 확인하면 첫번째 83, 마지막69로 105단위로 짤라 들어오고
  //println("number of bytes in Buffer = "+myPort.available());  //버퍼에 값이 있는지 체크하면 항상 0으로 뜬다 
  //println(sensorValue);
  m.updateMeter(sensorValue);
} 
