/**
* REALLY simple processing sketch that sends mouse x and y position of box to wekinator
* This sends 2 input values to port 6448 using message /wek/inputs
* Adapated from https://processing.org/examples/mousefunctions.html by Rebecca Fiebrink
**/

import oscP5.*;
import netP5.*;


int patchSize = 11;

OscP5 oscP5;
NetAddress dest;
PFont f;
PImage img;

float bx;
float by;
boolean overBox = false;
boolean locked = false;
float xOffset = 0.0; 
float yOffset = 0.0;

void setup() {
  f = createFont("Courier", 15);
  textFont(f);

  img = loadImage("mountain.png");
  size(600, 400, P2D);
  noStroke();
  smooth();
  
  bx = width/2.0;
  by = height/2.0;
  rectMode(RADIUS);  
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 9000);
  dest = new NetAddress("127.0.0.1",6448);

  
}


void drawEyePatch(float x, float y, int size) {
  fill(117, 47, 138);
  stroke(117, 47, 138);
  ellipse(x, y, size, size);
}

void draw() {
  background(255);
  fill(0);
  image(img, 50, 100);

  text("Continuously sends box x and y position (2 inputs) to Wekinator\nUsing message /wek/inputs, to port 6448", 10, 30);
  text("x=" + bx + ", y=" + by, 10, 80);
  

  // Test if the cursor is over the box 
  if (mouseX > bx-patchSize && mouseX < bx+patchSize && 
      mouseY > by-patchSize && mouseY < by+patchSize) {
    overBox = true;  
  } else {
    overBox = false;
  }
  
  // Draw the box
  drawEyePatch(bx, by, patchSize);
  
  //Send the OSC message with box current position
  sendOsc();
}

void mousePressed() {
  if(overBox) { 
    locked = true; 
  } else {
    locked = false;
  }
  xOffset = mouseX-bx; 
  yOffset = mouseY-by; 

}

void mouseDragged() {
  if(locked) {
    bx = mouseX-xOffset; 
    by = mouseY-yOffset; 
  }
}

void mouseReleased() {
  locked = false;
}


void sendOsc() {
  OscMessage msg = new OscMessage("/wek/inputs");
  msg.add((float)bx); 
  msg.add((float)by);
  oscP5.send(msg, dest);
}
