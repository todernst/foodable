//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////

import TUIO.*;
TuioProcessing tuioClient;
import java.util.*;

import codeanticode.syphon.*;
PImage display;
SyphonServer server;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

float leftScale = -560;
float rightScale = 290;
float topScale = -220;
float bottomScale = 120;

Plate[] p = new Plate[100];
Ball[] balls = new Ball[0];
Ring[] rings = new Ring[0];
PVector[] vels = new PVector[0];

float moveAmount = 5;

int backgroundFill = 20;

int flyAmount = 1;

PImage[] fruits = new PImage[11];
PImage[] wines = new PImage[2];

float diameterAmount = 0.38;

PImage thing;

float[] textFills = new float[9];

color bgColor = color(80,95,105);

//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////

void setup(){
  size(800, 800, P3D);
  
  oscP5 = new OscP5(this,8000);
  myRemoteLocation = new NetAddress("127.0.0.1",8000);
  
  for(int i=0;i<p.length;i++){
    p[i] = new Plate();
  }
  
  tuioClient  = new TuioProcessing(this);
  server = new SyphonServer(this, "Processing Syphon");

  display = createImage(width, height, ARGB);
  
  staticDiameter = min(width, height) * diameterAmount;
  for(int i = 0; i<diameter.length; i++){
    diameter[i] = staticDiameter;
    readingTimer[i] = new Timer(2000);
  }
  
  fruits[0] = loadImage("appleSet.png");
  fruits[1] = loadImage("bananaSet.png");
  fruits[2] = loadImage("cherrySet.png");
  fruits[3] = loadImage("pineappleSet.png");
  fruits[4] = loadImage("pearSet.png");
  fruits[5] = loadImage("kiwiSet.png");
  fruits[6] = loadImage("mangoSet.png");
  fruits[7] = loadImage("orangeSet.png");
  fruits[8] = loadImage("grapeSet.png");
  fruits[9] = loadImage("pineappleSet.png");
  fruits[10] = loadImage("watermelonSet.png");
  
  wines[0] = loadImage("malbecSet.png");
  wines[1] = loadImage("merlotSet.png");
}

//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////

void draw(){
  stroke(255);
  strokeWeight(10);
  fill(bgColor,50);
  rect(0,0,width-1,height-1);

  for(int i=0;i<p.length;i++){
    p[i].update();
  }
  //updateBalls();
  updateRings();
  drawCenterPiece();
  drawTextStuff();
  sendScreenThroughSyphon();
}

//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////

void drawTextStuff(){
  pushMatrix();
  translate(width/2,height-(height/3));
  tint(255,255);
  imageMode(CORNERS);
  float divider = 12;
  rotate(PI*.5);
  for(int i=0;i<9;i++){
    tint(255,textFills[i]);
    pushMatrix();
    scale(-1,1);
    translate(0,60);
    image(fruits[i],0-width/divider,0,width/divider,fruits[i].height/(divider/5));
    popMatrix();
    rotate((PI*2)/9);
  }
  popMatrix();
}

//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////

void addTuioObject(TuioObject tobj){
  int tempId = tobj.getSymbolID();
  if(tempId<p.length){
    p[tempId].on = true;
    p[tempId].questionable = false;
    p[tempId].x = width-tobj.getScreenX(width-(int)leftScale)+rightScale;
    p[tempId].y = height-tobj.getScreenY(height-(int)topScale)+bottomScale;
    p[tempId].px = p[tempId].x;
    p[tempId].py = p[tempId].y;
    p[tempId].rotAmount = tobj.getAngle();
    p[tempId].pRot = tobj.getAngle();
  }
}

//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////

void removeTuioObject(TuioObject tobj){
  int tempId = tobj.getSymbolID();
  if(tempId<p.length){
    p[tempId].questionable = true;
  }
}

//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////

void updateTuioObject (TuioObject tobj){
  int tempId = tobj.getSymbolID();
  if(tempId<p.length){
    p[tempId].x = width-tobj.getScreenX(width-(int)leftScale)+rightScale;
    p[tempId].y = height-tobj.getScreenY(height-(int)topScale)+bottomScale;
    p[tempId].rotAmount = tobj.getAngle();
  }
}

//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////

void updateBalls(){
  for(int i=0;i<balls.length;i++){
    if(balls[i].fill<=1){
      for(int b=i;b<balls.length-1;b++){
        balls[b] = balls[b+1];
        vels[b] = vels[b+1];
      }
      balls = (Ball[]) shorten(balls);
      vels = (PVector[]) shorten(vels);
    }
    if(i<balls.length){
      balls[i].x += vels[i].x;
      balls[i].y += vels[i].y;
      balls[i].rotateAmount += balls[i].rotateSpeed;
      
      tint(255,balls[i].fill);
      float tempX = balls[i].x;
      float tempY = balls[i].y;
      imageMode(CORNERS);
      noStroke();
      pushMatrix();
      translate(tempX,tempY);
      rotate(balls[i].rotateAmount);
      image(balls[i].thisImage,-balls[i].r,-balls[i].r,balls[i].r,balls[i].r);
      popMatrix();
      checkBoundaryCollision(i);
      balls[i].fill*=.9;
    }
  }
}

//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////

void updateRings(){
  for(int i=0;i<rings.length;i++){
    if(rings[i].fill<=1){
      for(int b=i;b<rings.length-1;b++){
        rings[b] = rings[b+1];
      }
      rings = (Ring[]) shorten(rings);
    }
    if(i<rings.length){
      
      tint(255,rings[i].fill);
      float tempX = rings[i].x;
      float tempY = rings[i].y;
      pushMatrix();
      translate(tempX,tempY);
      stroke(rings[i].c,rings[i].fill);
      strokeWeight(5);
      noFill();
      ellipse(0,0,rings[i].r,rings[i].r);
      popMatrix();
      //checkBoundaryCollision(i);
      rings[i].fill*=rings[i].feedback;
      rings[i].r += rings[i].expander;
    }
  }
}

//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////

void checkBoundaryCollision(int i) {
  if (rings[i].x > width-rings[i].r) {
    rings[i].x = width-rings[i].r;
  } 
  else if (rings[i].x < rings[i].r) {
    rings[i].x = rings[i].r;
  } 
  else if (rings[i].y > height-rings[i].r) {
    rings[i].y = height-rings[i].r;
  } 
  else if (rings[i].y < rings[i].r) {
    rings[i].y = rings[i].r;
  }
}

//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////

void oscEvent(OscMessage theOscMessage){
  
  if(theOscMessage.checkAddrPattern("/touch")==true){
    
    int tempIndex = theOscMessage.get(0).intValue() - 1;
    color tempColor = color(255,255,255);
    if(tempIndex>=0 && tempIndex<isRead.length){
      isRead[tempIndex] = true;
      readingTimer[tempIndex].savedTime = millis();
      for(int i=0;i<p.length;i++){
        if(p[i].on){
          Ring r = new Ring(p[i].x,p[i].y,100,tempColor);
          rings = (Ring[]) append(rings,r);
        }
      }
    }
    else{
      Ring r = new Ring(width/2,height-(height/3),300,tempColor);
      rings = (Ring[]) append(rings,r);
    }
  }
}
