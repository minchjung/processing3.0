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
[14. mousePressed 🔴MUST OVERRIDE FUCNTION 🔴](https://processing.org/reference/mousePressed_.html)    
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
void draw()
{
  while (myPort.available() > 0 ) { // Serial 로 받는 input이 있을때 까지 
 
    //Expand array size to the number of bytes you expect
    byte[] inBuffer = new byte[1024]; //매번 byte 배열을 생성해서 
    myPort.readBytesUntil('\n', inBuffer); //Serial input list로부터 
                  //개행전까지 읽어서 byte 어레이에 담음
 
    if (inBuffer != null) { // while에서 포트에 값이 있는게 처리고 값이 있을때만 
    //inBuffer로 옮겼기 때문에 이중처리 일 수 있는데  underflow를 꼼꼼하게 체크하기 위함인듯)
      myString = new String(inBuffer); 전역에 선언된 String  변수에 inBuffer배열값을 String으로 할당한다 
      list = split(myString, ','); // 위의 할당된 버퍼의(String으로 캐스팅된)bite값을 콤마(,) 단위로 쪼개서 리스트로 닮고 
     //그 값을 다시8로 두번 쪼개서 16x16 으로 돌려줌 
      for (int i = 0; i < (list.length)/8; i++) { 
         for (j = 0; j < (list.length)/8; j++) {
          array[j][i] = float(list[m]); 버퍼의 //bite값을 array에 한개씩 할당한다
          m++; // 0부터~16까지 인덱스용으로 사용되는 m (전역선언 m=0되있음)
        }
      }
      m = 0; // array bite값을 모두 float로 할당하면 다시 0으로 초기화하고 다음 serial 값을 빌때까지 반복하것지 .. 
    }
  } 
  // 그 전에 serial 의 값이 flaot를 array에 다 할당되면 Interpolation 과 Color를 설정하러 간다
  bilinearInterpolation();  //these are IN the while loop
  applyColor();
// Serial 값이 때까지 반복한다 
}
 
 
```
```java
void bilinearInterpolation() {  // Bi-linear Interpolation algorithm
 
  for (int i=0; i<r; i++) { //r=8
    for (int j=0; j<c; j++) { //c=8
      int x = j*t - 1; //t=200 
      int y = i*t - 1; //     x ,y= -1 ~ (1400-1) 까지 설정 되는데  
      if (x<0) // 음수는 둘다 0 으로 만든다
         x=0;
      if (y<0)
        y=0; //==> x,y = 0,199,399,599,799,....1399 로 설정되서 16번 돈다 
      interp_array[y][x] = array[i][j]; //interp_array[0][0]= Serial bite 값을 순서대로 할당함(float임)   
      //interp_array[199][199]= 두번째 bite 값 
      // ... 이렇게 약 200 간격으로 띄움 띄움 들어간다
      // interp_array[1399][1399] = 마지막 serial bite 값 
      //길이 1400까지 설정됨 .. 차 아슬하게도한돠암.ㅇㅇ
    } // 이게 Serial bite 값을 16x16으로 쪼개진 단위 마다 설정 
  }
 // interp_array에 띄엄띄엄 serial bite 값이 할당되면 
  for (int y=0; y<rows; y++) {//rows 1400 <--- 이게 canvas size 란다. 
    int dy1 = floor(y/(t*1.0)); //세로로 gradient 만드는 작업을 수동으로 하는듯 하다 
    int dy2 = ceil(y/(t*1.0));  // 방식은 간격을 factor t =200 간격으로 dy1는 소수점 버리고 dy2는 올림으로 설정 
    // 둘의 차이는 항상 1이며 값은 0아니면 1    
    int y1 = dy1*t - 1; // gradient,, 그걸 기울기로 각각 사용한다  
    int y2 = dy2*t - 1; 
    //따라서 y1,y2 =199 이거나 -1 일텐데 그때 y2가 199면 y1= -1 임 
    if (y1<0)
      y1 = 0;
    if (y2<0)
      y2 = 0; //이러면 차이나는 구간은 y2=199, y1= 0 이된다. 참 ..어렵게도 한다..
    for (int x=0; x<cols; x++) { // 가로 방향도 x 로 똑같이 수행해준다 
    //순서는 세로 y번째 하고 0~1400번째 까지 가로 x다 함
      int dx1 = floor(x/(t*1.0));// 
      int dx2 = ceil(x/(t*1.0));
      int x1 = dx1*t - 1;
      int x2 = dx2*t - 1;
      if (x1<0)
        x1 = 0;
      if (x2<0)
        x2 = 0;
      //그러면 array[0][0,1,0,1,0,1..0,1] 
      //       array[1][0,1,0,1,0....0,1]
      float q11 = array[dy1][dx1];
      float q12 = array[dy2][dx1];
      float q21 = array[dy1][dx2];
      float q22 = array[dy2][dx2];
      // 그 지점에서 상하좌우로만 검사함 .. 그냥 BFS 하믄 안될라낭.,
      int count = 0;
      if (q11>0)
        count++;
      if (q12>0)
        count++;
      if (q21>0)
        count++;
      if (q22>0) // 값이 있으면 카운트해주고 
        count++; // 딱 BFS 알고리즘을 기이이이일게 정렬한듯해 보인다. 
 
      if (count>2) { // 값이 3개 이상이면서 
        if (!(y1==y2 && x1==x2)) { // 두값중 하나라도 gradient 적용 값이 다를때 
 
          float t1 = (x-x1); // factor를 바꾼다 
          float t2 = (x2-x); 
          // x,y는 canvas size pixel로 0~1400 일텐데 199값  or 0을 뺀  pixel 지점 그대로 값이 보정 상수로 새로 할당된다 ?  
          float t3 = (y-y1);
          float t4 = (y2-y);
          float t5 = (x2-x1);
          float t6 = (y2-y1);
 
          if (y1==y2) { // 세로로 같을때의 경우는 가로열 차이가 있는 q11,q21값을 바뀐 해당 gradient 해주고 더함...
            interp_array[y][x] = q11*t2/t5 + q21*t1/t5;
          } else if (x1==x2) { // 가로로 같을때 세로줄 차이가 있는 것들을 똑같이 하고 
            interp_array[y][x] = q11*t4/t6 + q12*t3/t6;
          } else {
            float diff = t5*t6; // 완전 다르면 아래처럼 하나보다..;;;;;
            interp_array[y][x] = (q11*t2*t4 + q21*t1*t4 + q12*t2*t3 + q22*t1*t3)/diff;
          }
        } else { // 둘다 같으면 
          interp_array[y][x] = q11;
        }
      } else {// 상하좌우 할당된 값이 3개 이하면 걍 0
        interp_array[y][x] = 0;
      }
    }
  }
}
 
```
