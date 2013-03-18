class Plate{
  
  float x,y,px,py;
  float size = 100;
  
  float amp = 0;
  float jitterAmount = 200;
  
  float distThresh = 50;
  
  boolean on = false;
  boolean questionable = false;
  
  int offThresh = 1;
  int offCounter = 0;
  
  int offset = (int)random(1000);
  
  InfoCirc info;
  
  int now = -10000;
  int time = 5000;
  
  int isReadIndex;
  
  float rotAmount = 0;
  float pRot = rotAmount;
  float rotThresh = .2;
  
  Plate(){
    info = new InfoCirc();
    isReadIndex = (int) random(info.isRead.length);
  }
  
  void update(){
    if(on){
      paint();
      if(dist(x,y,px,py) > distThresh || abs(rotAmount-pRot)>rotThresh){
        moved();
        pRot = rotAmount;
      }
      if(millis() > now+time){
        info.isRead[isReadIndex] = false;
        info.thisTextFills[isReadIndex] = 0;
      }
      if(questionable){
        offTest();
      }
      amp*=.95;
      px = x;
      py = y;
    }
  }
  
  void paint(){
    float jitter = (noise(frameRate+offset+(frameCount*.5)) * jitterAmount) * amp;
    
    pushMatrix();
    translate(x,y);
    rotate(rotAmount);
    noFill();
    strokeWeight(1);
    stroke(255);
    //ellipse(0,0,100,100);
    info.paint();
    popMatrix();
  }
  
  void moved(){
    amp = 1;
    info.isRead[isReadIndex] = true;
    info.amount = 1.5;
    //info.readingTimer[isReadIndex].savedTime = millis();
    now  = millis();
  }
  
  void offTest(){
    offCounter++;
    if(offCounter>offThresh){
      on = false;
      questionable = false;
    }
  }
  
  void hit(color flyerColor){
    amp = 1;
  }
}
