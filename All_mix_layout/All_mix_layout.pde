
void setup() {
  size(1000, 600);
}
void draw() {
 for(int i =1; i <= 10; i++){
   for(int j =1; j <= 10; j++){
      stroke(100,100,255,150);
      strokeWeight(1);
      fill(20,20,255,10);
      rect(i*40,j*40,40,40);
   }
 }
 for(int i = 1; i <=5;i++ ){
   stroke(255,100,255,150);
   strokeWeight(5);
   fill(255,0,255);
   int val = i%2;
   rect(440+val*60+i*60,40,60,180);
 }
 stroke(20);
 stroke(255,200,80,150);
 fill(255,255,0);
 rect(520,250,380,180);
}
