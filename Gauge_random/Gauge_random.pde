import meter.*;
import processing.serial.*;

int sensorValue;
float ivalue ;
byte [] bytesData;
int []board = new int[104]; 
int rows = 10 ; 
int cols = 10 ; 
int scale = 40 ; 
Serial myPort; 
Meter m;

void setup() {
  
  size(600, 300);
  background(150, 255, 100);
  
   
  m = new Meter(this, 90, 15, true); // full circle - true, 1/2 circle - false  
  m.setMinScaleValue(0); // Set scale range min to max (0~ 255) 
  m.setMaxScaleValue(255);

  // Display digital meter value.
  m.setDisplayDigitalMeterValue(true);
  m.setTitle("Pressure Gauge");
  String[] scaleLabels = {"0", "30", "60", "90", "120", "150", "180", "210", "240", "255"};
  m.setScaleLabels(scaleLabels);
  m.setShortTicsBetweenLongTics(9);
   
  //datafile1 = createReader("/dev/ttyUSB0");
}
 
void draw() {
  
  ivalue = random(256);
  println(ivalue);
  println("currentMeterValue: " + m.getCurrentMeterValue());
  sensorValue = int(map((ivalue), float(0), float(256), float(0), float(256)));
 
  m.updateMeter(sensorValue);
}
