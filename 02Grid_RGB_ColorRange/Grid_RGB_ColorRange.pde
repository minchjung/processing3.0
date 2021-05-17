
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
  setColor(int(random(25001)));
  fill(colArr[0],colArr[1],colArr[2]);
  rect(xPos,yPos,wd,ht);
}

void setColor(int number){
    if(number<1000){
      colArr[0] =(number/150 +number%150);
      colArr[1] =(250);
      colArr[2] =(100);
    }
    else if (number<5000){
      colArr[0] =(number/150 +number%150);
      colArr[1] =(200);
      colArr[2] =(100);
    }else if(number<7000){
      colArr[0] =(245+number/1000);
      colArr[1] =(150+number%50);
      colArr[2] =(0);
    }else if (number<10000){
      colArr[0] =(245+number/1000);
      colArr[1] =(150+number%150);
      colArr[2] =(0);
    }else if (number<15000){
      colArr[0] =(235 +number%15);
      colArr[1] =(100);
      colArr[2] =(50);       
    }else if (number<20000){
      colArr[0]=(200+number/1000);
      colArr[1]=(10);
      colArr[2]=(10);
    }else{
      colArr[0]=(200+number/500);
      colArr[1]=(0);
      colArr[2]=(0);
    }
}
