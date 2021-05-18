import java.util.*;
final int N = 480;
final int scale = 30;
final int rows = N/scale;
final int cols = N/scale; 
final int maxV = 25000;
int valMin=100;
int valMax=180;

//int dirX[] ={0,0,-1,1};
//int dirY[] ={1,-1,0,0};
void settings(){
  size(N,N);
}

void setup(){
  background(50);
  pixelDensity(1);
}
void draw(){
  colorMode(HSB,360,1,1);
  stroke(1,5);
  for(int i = 0 ; i < rows; i++){
    for(int j =0 ; j< cols ; j++){
      float ranNum = random(maxV);
      float val = map(ranNum,0,maxV,valMin,valMax);
      fill(val,1,1);  
      square(j*scale,i*scale,scale);
    }
  }
}
void mouseClicked(){
  if(valMin ==100 && valMax == 180){
    valMin =0;
    valMax =30;
  }else{
    valMin=100;
    valMax=180;
  }
}

//// Reculsive DFS wthin the boundary 
//int pressUp(int nowY, int nowX, int k){
//  float reg = 3000*k;
//  if(k==1 || reg>=18000) return 0; // k temporal val to repeat (DFS 5 times to four direction on each )  
//  for(int i= 0 ; i <4; i++){ // 4 directions 
//    int nxtX = nowX + dirX[i];
//    int nxtY = nowY + dirY[i]; // check if next direction is valid or not 
//    if(nxtX <0 || nxtX >=N || nxtY <0 || nxtY >=N) return 0; // if not continue to loop  
//    fill( map(random(18000-reg,25000-reg),18000-reg,25000-reg,100,0),1,1,255); // if so,assume that strong press are generated 
//    square(nxtX*scale,nxtY*scale,scale); 
//    pressUp(nxtX,nxtY,k++); // go further 
    
//  }
//  return 0; 
//}
