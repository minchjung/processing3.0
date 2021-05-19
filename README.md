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
void bilinearInterpolation() {  // Bi-linear Interpolation algorithm
  for (int i=0; i<r; i++) { r,c=8
    for (int j=0; j<c; j++) {
      int x = j*t - 1;  // t = 200 Interpolation factor
      int y = i*t - 1;
      if (x<0)
        x=0;
      if (y<0)
        y=0;                             // interp_array[rows][cols], rows,cols = (r-1)*t
      interp_array[y][x] = array[i][j]; //interp_array[200*(8-1)][200*(8-1)]
    }
  }
```
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
// Serial 값이 필때까지 반복한다 
}
 
 
```
