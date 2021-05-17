
int w=500; 
int h =500; 
int colArr[];

void setup(){
  size(800,800);
  background(0);
  
}
void draw(){
  noStroke();
  int r = w/10; 
  int c = h/10; 
  for(int i=0; i < r; i++){
    for(int j=0; j < c; j++ ){
      setRec(c*j,r*i,c,r);   
    }
  }
}
void setRec(int xPos,int yPos,int wd,int ht){ 
  colArr = new int[3];
  for(int i =0; i<3;i++){
     colArr[i]=setColor((int)random(250001));
  } 
  fill(colArr[0],colArr[1],colArr[2]);
  rect(xPos,yPos,wd,ht);
}

int setColor(int number){
   return number/1000 + number%100;
}
