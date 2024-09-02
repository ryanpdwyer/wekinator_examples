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
float vScale=1.0;

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


// Declare variables for the green square position and velocity
float gx, gy, gvx, gvy;

int rectR = 0;
int rectG = 128;
int rectB = 0;


void setup() {
  f = createFont("Courier", 15);
  textFont(f);

  print(userName);

  String base_url = "https://us-central1-ai-fys.cloudfunctions.net/avatars/200/";

  String url = base_url + userName + ".png";
  String url2 = base_url + userName + "@mountunion" + ".png";
  String url3 = base_url + userName + "@edu1234fys" + ".png";
  String url4 = base_url + "umu2021fys" + userName + ".png";
  
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
        
  cp5.addSlider("vScale")
    .setPosition(500, 470)
    .setRange(0.0, 1.0)
    .setColorCaptionLabel(0);
    
  cp5.addButton("randomizeColor")
    .setPosition(500, 480);
  
  bx = width/2.0;
  by = height/2.0;
  rectMode(RADIUS);  
  
   // Set the initial position of the green square to the center of the screen
  gx = width/2;
  gy = height/2;
  
  // Set the initial velocity of the green square to a random value between -5 and 5
  gvx = random(-5, 5);
  gvy = random(-5, 5);
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 9000);
  dest = new NetAddress("127.0.0.1",6448);

  
}

void drawShape(float x, float y, int size) {
  fill(117, 47, 138);
  stroke(255, 255, 255);
  circle(x, y, size);
}

void randomizeColor() {
  rectR = (int)random(0, 255);
  rectG = (int)random(0, 255);
  rectB = (int)random(0, 255);
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
  
  // Call a function to update and display the green square
  updateGreenSquare();
  
  //Send the OSC message with box current position
  sendOsc();
}

// Define a function to update and display the green square
void updateGreenSquare() {
  // Update the position of the green square by adding the velocity
  gx += gvx * vScale;
  gy += gvy * vScale;
  
  // Check if the green square hits the edges of the screen and bounce it back
  if (gx < 0 || gx > width) {
    gvx *= -1;
  }
  
  if (gy < 0 || gy > height) {
    gvy *= -1;
  }
  
  // Display the green square at its current position
  fill(rectR, rectG, rectB); // Set fill color to green
  rect(gx, gy, patchSize/2, patchSize/2); // Draw a rectangle (square) at (gx, gy) with size patchSize
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
  msg.add((float)gx);
  msg.add((float)gy);
  oscP5.send(msg, dest);
}
