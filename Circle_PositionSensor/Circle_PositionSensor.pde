int ox,oy;
float Radius;
float StickRadius;
float secondsRadius;
float diameter;
float Tempangle;
float angle;
int chooseVersion =2;
void setup() {
  size(640, 360);
  ox = width /2;
  oy = height/2;
  
  int radius = min(width,height)/2;
  secondsRadius = radius * 1;
  StickRadius = radius*0.78;
  diameter = radius * 1.8;
  Tempangle =0;
  frameRate(30);
}

void draw() {
  background(80);
  /*if(Tempangle >=360)
      Tempangle =0;*/
  //Tempangle =random(360);
 if(chooseVersion == 1)
 {
    angle= radians(Tempangle);
    DrawSensorDataCircle(angle);
    Tempangle++;
 }
 else if(chooseVersion ==2 ){
    drawArrow( ox,  oy, 100, Tempangle);
    Tempangle++;
 }
 
}
void DrawSensorDataCircle(float angle)
{
   ellipse(ox, oy, diameter, diameter);
   stroke(0);
   strokeWeight(5);
  line(ox, oy, ox + cos(angle) * StickRadius, oy + sin(angle) * StickRadius);
  angle++; 
}
void drawArrow(int cx, int cy, int len, float angle){
   ellipse(ox, oy, diameter, diameter);
  pushMatrix();
  strokeWeight(5);
  translate(cx, cy);
  rotate(radians(angle));
  line(0,0,len, 0);
  line(len, 0, len - 8, -8);
  line(len, 0, len - 8, 8);
  popMatrix();
}
