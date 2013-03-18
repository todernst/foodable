class Ring{
  float x, y, r;
  color c;
  float fill = 255;
  float expander = 5;;
  float feedback = .95;
  
  Ring(){
  }

  Ring(float x, float y, float r,color _c) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.c = _c;
  }
}
