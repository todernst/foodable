int[] angles = { 
  40, 40, 40, 40, 40, 40, 40, 40, 40
};
float[] targetDiameter = {
  40, 60, 40, 80, 70, 60, 40, 50, 30
};
float[] diameter = {
  0, 0, 0, 0, 0, 0, 0, 0, 0
};
int[] increment = {
  1, -1, 1, -1, 1, -1, 1, 1, -1
};
float lastAngle = 0;
float nextAngle = 360/9;
float easing = 0.15;
float staticDiameter;
float readingDiameter = 250;
Timer timer;
Timer[] readingTimer = new Timer [9];
boolean[] isRead = {
  false, false, false, false, false, false, false, false, false,
};
boolean[] once = {
  false, false, false, false, false, false, false, false, false
};

int[] r = {
  24, 139, 99, 54, 255, 24, 139, 99, 54
};
int[] g = {
  50, 231, 127, 52, 226, 50, 231, 127, 52
};
int[] b = {
  49, 230, 86, 14, 62, 49, 230, 86, 14
};

void drawCenterPiece() {
  noStroke();
  for (int i = 0; i < angles.length; i++) {
    fill(r[i], g[i], b[i]);
    if (!isRead[i]) {
      float dx = targetDiameter[i] + staticDiameter - diameter[i];
      if (abs(dx) > 1) {
        diameter[i] += dx * easing;
      }
      else {
        targetDiameter[i] = -targetDiameter[i];
      }
    }
    else {
      float dx = readingDiameter + staticDiameter - diameter[i];
      if (abs(dx) > 1) {
        diameter[i] += dx * easing;
      }
      else {
        if (!once[i]) {
          readingTimer[i].start();
          textFills[(i+5)%9] = 255;
          once[i] = true;
        }
        else {
          if (readingTimer[i].isFinished()) {
            isRead[i] = false;
            textFills[(i+5)%9] = 0;
            once[i] = false;
          }
        }
      }
    }
    //fill(angles[i] * 3.0);
    arc(width/2, height-(height/3), diameter[i], diameter[i], lastAngle, lastAngle+radians(angles[i]));
    lastAngle = (lastAngle + radians(angles[i])) % radians(360);
    //increase[i] = diameter + increment[i];
    //println(lastAngle);
  }
  fill(bgColor);
  ellipse(width/2, height-(height/3), staticDiameter - 100, staticDiameter - 100);
}

