//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////

void keyPressed() {
  //  if (key == '1') {
  //    leftScale++;
  //    println("HORIZONTAL      " + leftScale + " -- " + rightScale);
  //  }
  //  else if (key == '2') {
  //    leftScale--;
  //    println("HORIZONTAL      " + leftScale + " -- " + rightScale);
  //  }
  //  else if (key == '3') {
  //    rightScale++;
  //    println("HORIZONTAL      " + leftScale + " -- " + rightScale);
  //  }
  //  else if (key == '4') {
  //    rightScale--;
  //    println("HORIZONTAL      " + leftScale + " -- " + rightScale);
  //  }
  //  if (key == '5') {
  //    topScale++;
  //    println("VERTICAL      " + topScale + " -- " + bottomScale);
  //  }
  //  else if (key == '6') {
  //    topScale--;
  //    println("VERTICAL      " + topScale + " -- " + bottomScale);
  //  }
  //  else if (key == '7') {
  //    bottomScale++;
  //    println("VERTICAL      " + topScale + " -- " + bottomScale);
  //  }
  //  else if (key == '8') {
  //    bottomScale--;
  //    println("VERTICAL      " + topScale + " -- " + bottomScale);
  //  }
}

//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////

void sendScreenThroughSyphon() {

  loadPixels();
  display.loadPixels();

  for (int i=0;i<width*height;i++) {
    display.pixels[i] = pixels[i];
  }
  updatePixels();
  display.updatePixels();

  server.sendImage(display);
}

//////////////////////////////////////////////////
//////////////////////////////////////////////////
//////////////////////////////////////////////////

