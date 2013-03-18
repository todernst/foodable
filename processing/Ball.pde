class Ball{
  float x, y, r, m;
  PImage thisImage;
  float fill = 255;
  float rotateAmount = random(PI);
  float rotateSpeed = random(-.5,.5);
  
  Ball(){
  }

  Ball(float x, float y, float r,PImage _thisImage) {
    this.x = x;
    this.y = y;
    this.r = r;
    m = r*.1;
    thisImage = _thisImage;
  }
}
