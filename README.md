# Processing3.0 Drawing Integ.Dev.Env
#### :link:  Function && Systemic variables  
[01. colorMode()](https://processing.org/reference/colorMode_.html)  
[02. constrain()](https://processing.org/reference/constrain_.html)  
[03. loadPixels()](https://processing.org/reference/loadPixels_.html)  
[04. pixels[]](https://processing.org/reference/pixels.html)  
[05. pushStyle()](https://www.processing.org/reference/pushStyle_.html)  
[06. pushMatrix()](https://processing.org/reference/pushMatrix_.html)    
[07. translate()](https://processing.org/reference/translate_.html)    
[08. PVector()](https://processing.org/reference/PVector.html)  
[09. point[]](https://processing.org/reference/point_.html)  
[10. text()](https://processing.org/reference/text_.html)    
[11. vertex()](https://processing.org/reference/vertex_.html)    
[12. texture()](https://processing.org/reference/texture_.html)    
[13. box()](https://processing.org/reference/box_.html)   
[14. mousePressed 🔴MUST OVERRIDE FUCNTION🔴](https://processing.org/reference/mousePressed_.html)    
[15. PGraphics](https://processing.org/reference/PGraphics.html)  

#### :link: Library && API (:eggplant: Processing ,  :chestnut:Java )
[:eggplant: ArrayList](https://processing.org/reference/ArrayList.html)     
[:eggplant: Peasycam](http://mrfeinberg.com/peasycam/)  
[:eggplant: Serial](https://www.processing.org/reference/libraries/serial/Serial.html)  
[:chestnut: HashMap: import.java.util.*](https://processing.org/reference/HashMap.html)  
[:chestnut: Queue: import.java.util.*](https://forum.processing.org/two/discussion/23900/fifo-and-lifo)  
[:chestnut: Deque import.java.util.*](https://forum.processing.org/two/discussion/23900/fifo-and-lifo)  
***
#### :link: Works  
[:white_check_mark: 01.HSB Pixel Noise-Perlin](https://github.com/minchjung/processing3.0/commit/5eb564780b49d74e4ba613e2fb4b23739890c62a)  
[:white_check_mark: 02.Gray Grid Basic](https://github.com/minchjung/processing3.0/commit/f6dd84972d2e8de67d7b1a5367915c430f357d53)  
[:white_check_mark: 03.Gray Grid Blur](https://github.com/minchjung/processing3.0/commit/a1ec1397cc06c6f0cd924a4250b7550ac959cce8)  
[:white_check_mark: 04.HSB Grid Basic](https://github.com/minchjung/processing3.0/commit/88a08d6d1a308f5b0ecf8a9aaf70f3be180f5891)   
[:white_check_mark: 05.HSB Grid Blur](https://github.com/minchjung/processing3.0/commit/9ac638407579eb7f734a2da2a06462141cb32af4)  
  
#### :link: Not done yet 
[:x: HSB Grid MouseEvent](https://github.com/minchjung/processing3.0/commit/a258af83b770b330eec3ff04bf2abfa14688b81b)  
<br>
***
# Study
#### 🔗: Interpolation   


```java
void draw(){
  while (myPort.available() > 0 ) { // Serial 로 받는 input이 있을때 까지 
 
    //Expand array size to the number of bytes you expect
    byte[] inBuffer = new byte[1024]; //매번 byte 배열을 생성해서 
    myPort.readBytesUntil('\n', inBuffer); //Serial input list로부터 
                  //개행전까지 읽어서 byte 어레이에 담음
 
    if (inBuffer != null) { // while에서 포트에 값에 있을때만  
    //inBuffer로 옮겼기 때문에 이중처리 일 수 있는데  underflow를 꼼꼼하게 체크하기 위함인듯)
      myString = new String(inBuffer); // 전역에 선언된 String  변수에 inBuffer배열값을 String으로 할당
      list = split(myString, ','); // 위의 할당된 버퍼의(String으로 캐스팅된)bite값을 콤마(,) 단위로 쪼개서 리스트
     //그 값을 다시8로 두번 쪼개서 16x16 돌려줌 
      for (int i = 0; i < (list.length)/8; i++) { 
         for (j = 0; j < (list.length)/8; j++) {
          array[j][i] = float(list[m]); 버퍼의 //bite값을 array에 한개씩 할당
          m++; // 0부터~16까지 인덱스용으로 사용되는 m (전역선언 m=0)
        }
      }
      m = 0; // index = 0으로 초기화 
    }
  } 
  //array 할당된 serial 값 => Interpolation 과 Color를 설정
  bilinearInterpolation();  //these are IN the while loop
  applyColor();
// Serial input 있을때 까지 반복  
}
```
```java
void bilinearInterpolation() {  // Bi-linear Interpolation algorithm
  for (int i=0; i<r; i++) { //r=8
    for (int j=0; j<c; j++) { //c=8
      int x = j*t - 1; //t=200 
      int y = i*t - 1; //     x ,y= -1 ~ (1400-1) 까지 설정됨  
      if (x<0) // -1을 0 으로 
         x=0;
      if (y<0)
        y=0; //==> x,y = 0,199,399,599,799,....1399 로 설정 (16바퀴) 
      interp_array[y][x] = array[i][j]; //interp_array[0][0]= Serial bite 값을 순서대로 할당(float임)   
      //interp_array[199][199]= 두번째 bite 값 
      // ... 이렇게 200 간격으로 띄음 띄음 늘려서 설정
      // interp_array[1399][1399] = 마지막 serial bite 값 
      //길이 1400 전역설정
    } // Serial bite 값을 16x16으로 쪼개서 들어올때마다 위 과정 반복 
  }
 // interp_array에 띄엄띄엄 serial bite 값이 할당되면 
  for (int y=0; y<rows; y++) {//rows 1400 <--- 이게 canvas size 란다. (factor t=200으로 계산됨)
    int dy1 = floor(y/(t*1.0)); //세로로 gradient 만드는 작업을  하는듯
    int dy2 = ceil(y/(t*1.0));  // facor t =200 간격으로 dy1는 소수점 버리고 dy2는 올림으로 설정 
    // 둘의 차이는 항상 0 아니면 1  (200 배수가 아니면 차이가 남)
    int y1 = dy1*t - 1; // gradient,, 그걸 기울기로 각각 사용,  ex) rows-1 일때 y1=1199, y2=1399 
    int y2 = dy2*t - 1;  // 
   
    if (y1<0) // y1 ,y2 음수 (모서리 구석진곳의 index 시작값) 0 설정
      y1 = 0;
    if (y2<0)
      
    for (int x=0; x<cols; x++) { 
    //세로 y번째, 가로 0~1400번째 위와 동일 처리
      int dx1 = floor(x/(t*1.0));// 
      int dx2 = ceil(x/(t*1.0));
      int x1 = dx1*t - 1;
      int x2 = dx2*t - 1;
      if (x1<0)
        x1 = 0;
      if (x2<0)
        x2 = 0;
      float q11 = array[dy1][dx1]; //array[0,0,0,0,0,0,...1,1,1,1,1,1,....2,2,2,2,2.....3,3,3,3,3,....6,6,6,6,6 200번씩, 마지막7한번][가로줄도 동일] 
      float q12 = array[dy2][dx1]; //array[1,1,1,1,1,1,...2,2,2,2,2.....3,3,3,3,3,....6,6,6,6,6......7,7,7,7..200번씩][0~6까지 200번, 마지막7한번]
      float q21 = array[dy1][dx2]; //array[0 ~6까지 각각 200번씩 마지막 7한번][1~7까지 각각 200번씩]
      float q22 = array[dy2][dx2]; //array[1~7까지 각각 200번씩][1~7까지 각각 200번씩]     
      int count = 0; // 16x16의 인덱스를 원하는 배수(200배)로 나눠서 올림,버림으로 쪼개고, 4 -direction[상하좌우]로 조합한것  
      if (q11>0)
        count++;
      if (q12>0)
        count++;
      if (q21>0)
        count++;
      if (q22>0) // 값이 있으면 카운트 
        count++; // 
 
      if (count>2) { // 값이 3개 이상이면 
        if (!(y1==y2 && x1==x2)) { // 세로 가로 방향 두 값중 하나라도 gradient 적용 인덱스 다를때 ==> 200으로 나눠떨어진 원래 지점이 아닐때만
 
          float t1 = (x-x1); // 각각의 원 지점 인덱스와 내림값 올림값들의 차이값 =new gradient 설정  
          float t2 = (x2-x); 
          float t3 = (y-y1);
          float t4 = (y2-y);
          float t5 = (x2-x1);
          float t6 = (y2-y1);
 
          if (y1==y2) { // 세로로 같을때의 경우는 가로열 차이가 있는 q11,q21값을   (올림설정값-원래값 +원래값-내림설정값)/(가로 최대 차이) 
            interp_array[y][x] = q11*t2/t5 + q21*t1/t5;
          } else if (x1==x2) { // 가로로 같을때 세로줄 차이가 있는 것들을 똑같이 하고 
            interp_array[y][x] = q11*t4/t6 + q12*t3/t6;
          } else { // 
            float diff = t5*t6; // 완전 다르면 아래처럼 각가의 케이스를 모두 계산 완전 차이나는 t5,t6로 기울기 깍아줌;;;;;
            interp_array[y][x] = (q11*t2*t4 + q21*t1*t4 + q12*t2*t3 + q22*t1*t3)/diff;
          }
        } else { // 둘다 같으면 둘다같은 q11값 설정
          interp_array[y][x] = q11;
        }
      } else {// 할당값 3개 이하면 늘려서 할당 안함 
        interp_array[y][x] = 0;
      }
    }
  }
}
void applyColor() {  // Generate the heat map 
  color c1 = color(0, 0, 255);  // Blue color
  color c2 = color(0, 255, 0);  // Green color
  color c3 = color(255, 0, 0);  // Red color
  color c4 = color(255, 255, 0);  // Yellow color
 
  for (int i = 0; i < rows; i++) {//1400 by 1400
    for (int j = 0; j < cols; j++) {
      float value = interp_array[i][j]; // 16x16을 늘려서 값을 들고 있는걸 하나씩 꺼냄 
      color c;
      float fraction;
      //값을 4구간 나눠서 색 할당 
      if (value>=1 && value<2) {
        fraction = (value-1)/1.0; 
        c = lerpColor(c1, c2, fraction);
      } else if (value>=2 && value<3) {
        fraction = (value-2)/1.0;
        c = lerpColor(c2, c3, fraction);
      } else if (value>=3 && value<5) {
        fraction = (value-3)/2.0;
        c = lerpColor(c3, c4, fraction);
      } else
      c = c4;
      stroke(c); //테두리도 같은색할당
      point(j, i); //할당된 색으로 해당 지점 점찍음
    }
  }
}
```
