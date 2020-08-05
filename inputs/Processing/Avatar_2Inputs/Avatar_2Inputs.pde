/**
* REALLY simple processing sketch that sends mouse x and y position of box to wekinator
* This sends 2 input values to port 6448 using message /wek/inputs
* Adapated from https://processing.org/examples/mousefunctions.html by Rebecca Fiebrink
**/

import oscP5.*;
import netP5.*;
import controlP5.*;

ControlP5 cp5;
boolean toggleValue = false;


int patchSize = 14;

OscP5 oscP5;
NetAddress dest;
PFont f;
PImage img;
PImage img2;
PImage img3;
PImage img4;

float bx;
float by;
boolean overBox = false;
boolean locked = false;
float xOffset = 0.0; 
float yOffset = 0.0;
String userName = System.getProperty("user.name");




void setup() {
  f = createFont("Courier", 15);
  textFont(f);

  String url = "https://api.adorable.io/avatars/200/" + userName + ".png";
  String url2 = "https://api.adorable.io/avatars/200/" + userName + "@mountunion" + ".png";
  String url3 = "https://api.adorable.io/avatars/200/" + userName + "@edu1234fys" + ".png";
  String url4 = "https://api.adorable.io/avatars/200/umu2020fys" + userName + ".png";
  
  img = loadImage(url, "png");
  img2 = loadImage(url2, "png");
  img3 = loadImage(url3, "png");
  img4 = loadImage(url4, "png");
  size(650, 550, P2D);
  noStroke();
  smooth();

  cp5 = new ControlP5(this);

  cp5.addSlider("patchSize")
        .setPosition(500, 460)
        .setRange(1, 150)
        .setColorCaptionLabel(0);
  // customize(d1);
  
  bx = width/2.0;
  by = height/2.0;
  rectMode(RADIUS);  
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 9000);
  dest = new NetAddress("127.0.0.1",6448);

  
}

void drawShape(float x, float y, int size) {
  fill(117, 47, 138);
  stroke(255, 255, 255);
  circle(x, y, size);
}


void draw() {
  background(255);
  fill(0);
  image(img, 20, 100);
  image(img2, 280, 100);
  image(img3, 20, 340);
  image(img4, 280, 340);

  text("Continuously sends x and y position (2 inputs) to Wekinator\nUsing message /wek/inputs, to port 6448", 10, 30);
  text("x=" + bx + ", y=" + by, 10, 80);
  

  // Test if the cursor is over the box 
  if (mouseX > bx-patchSize && mouseX < bx+patchSize && 
      mouseY > by-patchSize && mouseY < by+patchSize) {
    overBox = true;  
  } else {
    overBox = false;
  }
  
  // Draw the box
  drawShape(bx, by, patchSize);
  
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
