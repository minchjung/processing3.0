import processing.serial.*; 
/**********************************************************************************************************
* CONSTANTS
**********************************************************************************************************/

int COLS = 10;
int ROWS = 10;
int CELL_SIZE = 40;
int END_MARKER = 69;//255
int SCALE_READING = 2;
int min_force_thresh = 1;

boolean INVERT_X_AXIS = false;
boolean INVERT_Y_AXIS = false;
boolean SWAP_AXES = true;

/**********************************************************************************************************
* GLOBALS
**********************************************************************************************************/

Cell[][] grid;
Serial sPort;

int xcount = 0;
int ycount = 0;
boolean got_zero = false;
int got_byte_count = 0;
int last_byte_count = 0;

void setup() {
  background(0, 0, 0);
  int port_count = Serial.list().length; //Our value =1 
  sPort = new Serial(this, Serial.list()[port_count - 1], 115200);    
  size(CELL_SIZE * COLS, CELL_SIZE * ROWS); //40x10, 40x10  
  grid = new Cell[COLS][ROWS];
  for (int i = 0; i < COLS; i++){
    for (int j = 0; j < ROWS; j++){ // x=i*40, y=j*40, w=40, h=40 (temporal)
      grid[i][j] = new Cell(i * CELL_SIZE, j * CELL_SIZE, CELL_SIZE, CELL_SIZE); // 생성자 injection
    } //각각의 격자 위치 초기화 
  }
}
void draw() {
  rxRefresh();
}

void rxRefresh() {
  while(sPort.available() > 0){ //버퍼에 들어온 값이 1개라도 있으면 
    byte got_byte = (byte) sPort.read(); //버퍼의 다음값을 읽어서 got_byte에 담고 
    got_byte_count ++; //global, byte count 1개씩 증가 
    int unsigned_force = got_byte & 0xFF;//비트연산으로 부호처리해준다음 int로 받음 (중요!) 
    if(unsigned_force == END_MARKER) { // 버퍼의 값 (int로 받은값이) end marker=69이면 
      xcount = 0; //global  
      ycount = 0;// x,y count reset to start new packet <--얘들을 reset해준다.  
    }
    else if(got_zero){ //버퍼의 next byte 값이 end marker가 아니고 got_zero=True시 
      for(int i = 0; i < unsigned_force; i ++){ //int로 변환한 버퍼의 해당값(unsigned_forced)만큼 루프를 돌린다
        updatePixel(xcount, ycount, 0);// updatePixel처리 해당 포지션을 0으로 세팅하고 다음 x,y position 값을 세팅해준다 
        xcount ++; //x값 1증가 
        if(xcount >= COLS){//x 값이 가로 길이에 이르면 
          xcount = 0; // x 값 0 
          ycount ++; // y값 1증가 = 세로한칸 아래
          if(ycount >= ROWS) ycount = ROWS - 1; // y값이 증가후 세로 길이에 이르면 0부터 시작한 index길이로 맞춰준다 
        }
      }
      got_zero = false; // 버퍼의 값만큼 for룹을 돌고 나오면 got_zero=false를 바꾼다 
    }// 버퍼의 들어온값은 (end Siglnal 아니면) x,y position으로 매번 할당된다 
    else if(got_byte == 0) // 버퍼값이 0 이면 
      got_zero = true; // 다시 true로 바꾼다 <--이렇게 되면 버퍼의 값이 0일때는 위 처리를하고 0이 아닐때만 아래로 내려온다 . 
    else //버퍼의값이 endsignal 아니고 그값이 0 이 아니면   
    { //그 값과 위치를 함수로 넘겨서 할당한다 
      updatePixel(xcount, ycount, unsigned_force);
      xcount ++;
      if(xcount >= COLS){
        xcount = 0;
        ycount ++;
        if(ycount >= ROWS)
          ycount = ROWS - 1;
      }
    }
  }
}// 음?,,,
/**********************************************************************************************************
* updatePixel()
**********************************************************************************************************/

void updatePixel(int xpos, int ypos, int force){
  if(SWAP_AXES){ //x,y position 바꿔야되면 <-- 얘 바꿔주는 값이 없음 ture하면 그림 안그려져서 false로 고쳐줌 
    int temp = xpos;
    xpos = ypos;
    ypos = temp; //바꾼다 
  }
  if((xpos < ROWS) && (ypos < COLS)){ //x,y  범위내에 만족하고 
    if(INVERT_Y_AXIS) //y축으로 뒤집을 수 있으면     <--얘들도 바꾸는 조건이 없음.. 
      xpos = (COLS - 1) - xpos; //y축 기준으로 x좌표 반전 
    if(INVERT_X_AXIS) //x축으로 뒤집을 수 있으면 
      ypos = (COLS - 1) - ypos;// x축 기준으로 y좌표 반전 
    grid[ypos][xpos].display(force); // 해당 grid에 display
  }
}
/**********************************************************************************************************
* class Cell

**********************************************************************************************************/

class Cell {
  float x, y;
  float w, h;
  int current_force = 0;
  float calibrated = 0;  

  Cell(float tempX, float tempY, float tempW, float tempH) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
  } 
  void display(int newforce) {
    if(newforce < min_force_thresh) newforce = 0; // 해당 위치에 넘어온 byte=>int 값이 역치값(1)보다 작으면 그냥 0처리 
    else newforce *= SCALE_READING; 그게 아니면 증폭값?Scale_Reading=2으로 매번 2배로 증폭  
    if(newforce != current_force){ // 새로 들어온값이 현재값과 다르면 
      noStroke();
      fill(0, newforce, 0); // 그때 그림 그리고 
      rect(x, y, w, h); 
      current_force = newforce; // 현재값으로 바꿔준다 
    }
  }
}
