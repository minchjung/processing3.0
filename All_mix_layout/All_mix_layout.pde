
void setup() {
  size(1000, 600);

}

void draw() {
 for(int i =1; i <= 10; i++){
   for(int j =1; j <= 10; j++){
      stroke(5);
      strokeWeight(1);
      fill(255,255,0);
      rect(i*40,j*40,40,40);
   }
 }
 for(int i = 1; i <=5;i++ ){
   stroke(5);
   strokeWeight(8);
   fill(255,0,255);
   int val = i%2;
   rect(440+val*60+i*60,40,60,180);
 }
 stroke(5);
 fill(0,255,255);
 rect(520,250,380,180);
}
