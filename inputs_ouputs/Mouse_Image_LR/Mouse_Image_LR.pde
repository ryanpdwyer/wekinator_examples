/**
* REALLY simple processing sketch that sends mouse x and y position to wekinator
* This sends 2 input values to port 6448 using message /wek/inputs
**/

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;

PFont f;
PImage img;
PImage[] imgs = new PImage[2];
String[] imgPaths = {"img1.png", "img2.png"};

void setup() {
  // Pulling the display's density dynamically
  pixelDensity(displayDensity());
  f = createFont("Courier", 16);
  textFont(f);

  size(512, 480, P2D);
  noStroke();
  smooth();
  imgs[0] = loadImage(imgPaths[0]);
  imgs[1] = loadImage(imgPaths[1]);
  img = imgs[0];
  
  
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);
  dest = new NetAddress("127.0.0.1", 6448);
  
}

void draw() {
  background(255);
  fill(0);
  ellipse(mouseX, mouseY, 10, 10);
  if(frameCount % 2 == 0) {
    sendOsc();
  }
  text("Continuously sends mouse x and y position (2 inputs) to Wekinator\nUsing message /wek/inputs, to port 6448", 10, 30);
  text("x=" + mouseX + ", y=" + mouseY, 10, 80);
  image(img, 0, 100);
}

void sendOsc() {
  OscMessage msg = new OscMessage("/wek/inputs");
  msg.add((float)mouseX); 
  msg.add((float)mouseY);
  oscP5.send(msg, dest);
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
 println("received message");
    if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
      if(theOscMessage.checkTypetag("f")) {
      int f = (int)theOscMessage.get(0).floatValue();
      println("received1");
      img = imgs[f-1];
      }
    }
 
}
