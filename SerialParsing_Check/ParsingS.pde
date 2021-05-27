class ParsingS {

  final int STARTSIG;
  final int ENDSIG; 
  final int S_LEN;
  final int THRESHOLD; //min-value to display
  byte bytesArr[] ; 
  
  ParsingS(int STARTSIG, int ENDSIG, int SERIAL_LENGTH, int THRESHOLD){
    this.STARTSIG = STARTSIG & 0xff;
    this.ENDSIG = ENDSIG & 0xff; 
    this.S_LEN = SERIAL_LENGTH ;
    this.THRESHOLD = THRESHOLD; 
    this.bytesArr = new byte[S_LEN];
  }
  void setBytesArr(byte[] bytesArr){
    this.bytesArr = bytesArr; 
  }
  byte[] getBytesArr(){
    return this.bytesArr; 
  }
  boolean parsingCheck(){
    if(this.bytesArr[0]!=STARTSIG || this.bytesArr[S_LEN]!=ENDSIG || this.bytesArr.length !=S_LEN) return false; 
    return true;
  }

  void drawGrid(int x, int y, int r, int c, int scale){
    int idx =0; 
    int val =0; 
    for(int i=0; i < r; i++){
       for(int j=0; j < c; j++){
         val=bytesArr[idx] & 0xff; 
         if(val <= this.THRESHOLD || val==STARTSIG || val ==ENDSIG) continue;
         println(val);
       }
     }
  }
}
