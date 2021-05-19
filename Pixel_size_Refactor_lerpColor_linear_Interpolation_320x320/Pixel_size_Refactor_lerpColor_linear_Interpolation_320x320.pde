
int r = 16;  // number of rows in input array
int c = 16;  // number of columns in input array
int t = 20;  // parameter (array resize factor)
int rows = r*t;  // height of the heat map
int cols = c*t;  // width of the heat map

float[][] board = new float[r][c];  // input array
float[][] interp_array = new float[rows][cols]; // interpolated array
 
void settings(){
  size(cols, rows);
}
 
void setup(){ 
  noStroke();
} 
void draw(){
  for(int i = 0 ; i < r ; i++){
    for(int j =0; j< c; j++){
       board[i][j]=random(256);
    }
  }
  bilinearInterpolation();  //these are IN the while loop
  applyColor();
}
void bilinearInterpolation() {  // Bi-linear Interpolation algorithm
  for (int i=0; i<r; i++) {
    for (int j=0; j<c; j++) {
      int x = j*t - 1;
      int y = i*t - 1;
      if (x<0) x=0;
      if (y<0) y=0;
      interp_array[y][x] = board[i][j];
    }
  }
  for (int y=0; y<rows; y++) {
    int dy1 = floor(y/(t*1.0));
    int dy2 = ceil(y/(t*1.0)); 
    int y1 = dy1*t - 1;
    int y2 = dy2*t - 1;
    if (y1<0) y1 = 0;
    if (y2<0) y2 = 0;
    for (int x=0; x<cols; x++) {
      int dx1 = floor(x/(t*1.0));
      int dx2 = ceil(x/(t*1.0));
      int x1 = dx1*t - 1;
      int x2 = dx2*t - 1;
      if (x1<0) x1 = 0;
      if (x2<0) x2 = 0;

      if(dx1>=16 || dx2>=16 || dy1>=16 || dy2>=16){ 
        dx1 =15;
        dx2 =15;
        dy1 =15;
        dy2 =15;
      }
      float q11 = board[dy1][dx1];
      float q12 = board[dy2][dx1];
      float q21 = board[dy1][dx2];
      float q22 = board[dy2][dx2];

      int count = 0;
      if (q11>0) count++;
      if (q12>0) count++;
      if (q21>0) count++;
      if (q22>0) count++;
 
      if (count>2) {
        if (!(y1==y2 && x1==x2)) {
         
          float t1 = (x-x1);
          float t2 = (x2-x);
          float t3 = (y-y1);
          float t4 = (y2-y);
          float t5 = (x2-x1);
          float t6 = (y2-y1);
 
          if (y1==y2) {
            interp_array[y][x] = q11*t2/t5 + q21*t1/t5;
          } else if (x1==x2) {
            interp_array[y][x] = q11*t4/t6 + q12*t3/t6;
          } else {
            float diff = t5*t6;
            interp_array[y][x] = (q11*t2*t4 + q21*t1*t4 + q12*t2*t3 + q22*t1*t3)/diff;
          }
        } else {
          interp_array[y][x] = q11;
        }
      } else {
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
 
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      float value = interp_array[i][j];
      color c;
      float fraction;
      println(interp_array[i][j]); 
      if (value>=0 && value<60) {
        fraction = (value)/1.0;
        c = lerpColor(c3, c4, fraction);
      } else if (value>=60 && value<120) {
        fraction = (value-60)/1.0;
        c = lerpColor(c4, c3, fraction);
      } else if (value>=120 && value<180) {
        fraction = (value-120)/2.0;
        c = lerpColor(c3, c2, fraction);
      } else c = c1;
      stroke(c);
      point(j, i);
    }
  }
}
