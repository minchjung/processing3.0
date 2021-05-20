int r = 16;  // number of rows in input 
int c = 16;  // number of columns in input 
int t = 25;  // parameter (array resize factor)
int rows = (r)*t;  // height of the heat map 400x400
int cols = (c)*t;  // width of the heat map

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
  bilinearInterpolation();
  applyColor();
}
 // Bi-linear Interpolation algorithm
void bilinearInterpolation() { 
  // Refactoring size(16x16 to 400x400)
  for (int i=0; i<r; i++) {
    for (int j=0; j<c; j++) {
      int x = j*t - 1;
      int y = i*t - 1;
      if (x<0) x=0;
      if (y<0) y=0;
      // Set value with gap 
      interp_array[y][x] = board[i][j];
    }
  }
  //Index rearrange
  // refactored the size from inital index by one UP, the other Down on every single point(vist like BFS algorithm)
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
      
      //Set the boundary when it range out 
      dx1 = setBoundary(dx1); 
      dx2 = setBoundary(dx2); 
      dy1 = setBoundary(dy1); 
      dy2 = setBoundary(dy2); 
      //Give the value to broader point (up,down,right,left on every single time <--BFS)
      float q11 = board[dy1][dx1];
      float q12 = board[dy2][dx1];
      float q21 = board[dy1][dx2];
      float q22 = board[dy2][dx2];
      
      // counting when it has any values 
      int count = 0;
      if (q11>0) count++;
      if (q12>0) count++;
      if (q21>0) count++;
      if (q22>0) count++;
      
      // Reset the value on the new index by the linear interporation 
      // the factor for the gradient depends on the counts of the values 
      if (count>2) {
        // When its not origin, but new point => go to have Reset the factor 
        if (!(y1==y2 && x1==x2)) {
          // thease are the gradient for each direction like Go up or down(<-same cols but different rows) or Left or Right, and so on..
          float t1 = (x-x1);
          float t2 = (x2-x);
          float t3 = (y-y1);
          float t4 = (y2-y);
          float t5 = (x2-x1);
          float t6 = (y2-y1);
          // From this, Reset that Interpol-value, basically with the regression by linear way from origin
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
// Boundary check 
int setBoundary(int dir){
  if(dir <0) dir=0; 
  if(dir >=r) dir=r-1; 
  return dir; 
}
// Generate the heat map 
void applyColor() {  
  // Color apply <--- *** Need to check more whether color change in variable ways or not  ****
  color c1 = color(0, 0, 255);  // Blue color
  color c2 = color(0, 255, 0);  // Green color
  color c3 = color(255, 0, 0);  // Red color
  color c4 = color(255, 255, 0);  // Yellow color

  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      float value = interp_array[i][j];
      color c;
      float fraction; // linear fraction for the color 
      println(interp_array[i][j]); 
      if (value>=0 && value<60) {
        fraction = (value)/1.0;
        c = lerpColor(c1, c2, fraction);
      } else if (value>=60 && value<120) {
        fraction = (value-60)/60.0;
        c = lerpColor(c2, c4, fraction);
      } else if (value>=120 && value<180) {
        fraction = (value-120)/120.0;
        c = lerpColor(c4, c3, fraction);
      } else {
        fraction = (value-180)/180.0;
        c = lerpColor(c3,c4,fraction);
      }
      stroke(c);
      point(j, i);
    }
  }
}
