class InfoCirc {
  int[] angles = { 
    120, 120, 120
  };
  float[] targetDiameter = {
    58, 60, 55
  };
  float[] diameter = {
    0, 0, 0
  };
  int[] increment = {
    1, -1, 1
  };
  float lastAngle = 0;
  float nextAngle = 360/9;
  float easing = 0.2;
  float thisDiameter;
  float readingDiameter;
  Timer timer;
  Timer[] readingTimer = new Timer[3];

  boolean[] isRead = {
    false, false, false
  };
  boolean[] once = {
    false, false, false
  };

  int[] r = {
    24, 139, 99
  };
  int[] g = {
    50, 231, 127
  };
  int[] b = {
    49, 230, 86
  };

  float thisTextFills[] = new float[isRead.length];

  float amount = 0;
  
  int picIndex = (int)random(2);
  
  boolean clean = false;

  InfoCirc() {
    for (int i=0;i<readingTimer.length;i++) {
      readingTimer[i] = new Timer(5000);
    }
  }

  void paint() {
    boolean test = false;
    for (int b=0;b<isRead.length;b++) {
      if (isRead[b]) {
        test = true;
      }
    }
    if (!test) {
      amount*=.97;
    }
    thisDiameter = amount * 20;
    readingDiameter = thisDiameter*5;
    noStroke();
    if(amount>.1){
      for (int i = 0; i < angles.length; i++) {
        fill(r[i], g[i], b[i]);
        if (!isRead[i]) {
          float dx = targetDiameter[i] + thisDiameter - diameter[i];
          if (abs(dx) > 1) {
            diameter[i] += dx * easing;
          }
          else {
            targetDiameter[i] = -targetDiameter[i];
          }
        }
        else {
          float dx = readingDiameter + thisDiameter - diameter[i];
          if (abs(dx) >= 1) {
            diameter[i] += dx * easing;
            once[i] = false;
          }
          else {
            if (!once[i]) {
              readingTimer[i].start();
              thisTextFills[i] = 255;
              once[i] = true;
            }
            else {
              if (readingTimer[i].isFinished()) {
                isRead[i] = false;
                thisTextFills[i] = 0;
                once[i] = false;
              }
            }
          }
        }
        //fill(angles[i]  3.0);
        arc(0, 0, diameter[i]*amount, diameter[i]*amount, lastAngle, lastAngle+radians(angles[i]));
        lastAngle = (lastAngle + radians(angles[i])) % radians(360);
        //increase[i] = diameter + increment[i];
        //println(lastAngle);
      }
      //text stuff...
      pushMatrix();
      tint(255, 255);
      imageMode(CORNERS);
      float divider = 4;
      rotate(PI*.5);
      rotate((PI*2)/4);
      for (int i=0;i<thisTextFills.length;i++) {
        tint(255, thisTextFills[i]);
        rotate((PI*2)/3);
        pushMatrix();
        rotate(PI/6);
        scale(-1,1);
        image(wines[picIndex], 0-((width/4)/divider), 0, (width/4)/divider, wines[picIndex].height/divider);
        popMatrix();
      }
      fill(bgColor);
      ellipse(0, 0, 90, 90);
      popMatrix();
    }
  }
}

